import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arspace/util/environment.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../backend/models/chat_box_model.dart';
import '../controller/chat_inbox_controller.dart';
import '../util/all_constants.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/playPauseButton.dart';
import 'connectivity_service.dart';
import 'full_image.dart';

class ChatInboxScreen extends StatefulWidget {
  const ChatInboxScreen({Key? key}) : super(key: key);

  @override
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;
  int? currentrecordingIndex;

  String roomId = "";
  String? name;
  String? type;
  String? token;
  String? UUID;
  late final WebSocketChannel channel;

  final ChatInboxController chatInboxController =
  Get.put(ChatInboxController(parser: Get.find()));

  XFile? selectedImage;
  var profile_image;

  // String? audioFilePath;
  // audioplayers.PlayerState audioPlayerState = audioplayers.PlayerState.STOPPED;
  late audioplayers.AudioPlayer audioPlayer;
  late List<audioplayers.PlayerState> audioPlayerStates;

  FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool isRecording = false;
  String mainfilePath = '';

  late ScrollController _scrollController;
  FocusNode? myFocusNode;

  //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    myFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(myFocusNode);
    });

    chatInboxController.initialized;

    roomId = Get.arguments[0].toString();
    name = Get.arguments[1].toString();
    type = Get.arguments[2].toString();

    chatInboxController.getRoomMessage(roomId).then((value) =>
    {
      audioPlayerStates = List.filled(
          chatInboxController.roomChatList.length,
          audioplayers.PlayerState.stopped),

      print("======= call down function roomId"),

      //_scrollToBottom(1000)
      move_down(0)
    });

    token = chatInboxController.parser.sharedPreferencesManager
        .getString('token') ??
        '';
    UUID =
        chatInboxController.parser.sharedPreferencesManager.getString('UUID') ??
            '';

    print("token=== $token");
    print("UUID=== $UUID");

    if (type == "group") {
      channel = WebSocketChannel.connect(
        //old
        // Uri.parse('ws://34.135.45.97/ws/group/$roomId?token=$token'),
        //new
        //Uri.parse('ws://34.121.97.111/ws/group/$roomId?token=$token'),
        Uri.parse("${Environments.webSoketURL}" + "group/$roomId?token=$token"),
      );

      /* channel = WebSocketChannel.connect(
        Uri.parse('ws://34.135.45.97/ws/private/$roomId?token=$token'),
      );*/
    } else {
      channel = WebSocketChannel.connect(
        // Uri.parse('ws://34.121.97.111/ws/private/$roomId?token=$token'),
        Uri.parse(
            "${Environments.webSoketURL}" + "private/$roomId?token=$token"),
      );
    }

    setState(() {
      channel!.stream.listen(
        /*channel.stream.listen(*/
            (message) {
          setState(() {
            Map<String, dynamic> jsonData = jsonDecode(message);

            // Check if the message contains a "messages" key
            if (jsonData.containsKey("messages")) {
              // Extract the list of messages
              chatInboxController.roomChatList.clear();
              List<dynamic> messages = jsonData["messages"];

              // Iterate over the list of messages in reverse order
              for (int i = messages.length - 1; i >= 0; i--) {
                var messageData = messages[i];
                chatInboxController.roomChatList
                    .add(ChatBoxModelData.fromJson(messageData));
              }
            }

            audioPlayerStates = List.filled(
                chatInboxController.roomChatList.length,
                audioplayers.PlayerState.stopped);

            chatInboxController.update();

            print("WebSocketChannel data: $message");
            Future.delayed(Duration.zero, () {
              print("down to botttom _scrollToBottom");

              _scrollToBottom(300);
            });
          });
        },
        onError: (error) {
          print("WebSocketChannel error: $error");
          // Handle WebSocket errors here
        },
        onDone: () {
          print("=======call onDone down function stream");
          // move_down(1000);
        },
      );
    });

    audioPlayer = audioplayers.AudioPlayer();

    audioPlayer.onPlayerStateChanged.listen((audioplayers.PlayerState state) {
      setState(() {
        audioPlayerStates[currentrecordingIndex!] = state;
      });
    });

    print("======= call down function outer");

    Future.delayed(Duration.zero, () {
      _scrollToBottom(300);
    });

    // move_down(1000);

    // isRecording = false;
    // mainfilePath = '';
  }

  @override
  void dispose() {
    channel.sink.close();
    _audioRecorder.closeRecorder();
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  move_down(int seconds) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Add a delay before scrolling to ensure the ListView is fully populated
      Future.delayed(Duration(milliseconds: seconds), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  _scrollToBottom(int millisecond) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: millisecond),
      curve: Curves.easeOut,
    );
  }

  // void _play(String filePath, int index) {
  //   // Stop all other players before starting a new one
  //   _stopAllPlayers();
  //   audioPlayer.play(filePath);
  //   setState(() {
  //     currentrecordingIndex = index;
  //     audioPlayerStates[index] = audioplayers.PlayerState.playing;
  //   });
  // }


  void _play(String filePath, int index) {
    // Stop all other players before starting a new one
    _stopAllPlayers();
    audioPlayer.play(filePath as audioplayers.Source);
    setState(() {
      currentrecordingIndex = index;
      audioPlayerStates[index] = audioplayers.PlayerState.playing;
    });
  }

// Pause audio
  void _pause() {
    audioPlayer.pause();
    // Find the index of the currently playing item and update its state
    int playingIndex =
    audioPlayerStates.indexOf(audioplayers.PlayerState.playing);
    if (playingIndex != -1) {
      setState(() {
        audioPlayerStates[playingIndex] = audioplayers.PlayerState.paused;
      });
    }
  }

// Stop audio
  void _stop() {
    audioPlayer.stop();
    // Find the index of the currently playing item and update its state
    int playingIndex =
    audioPlayerStates.indexOf(audioplayers.PlayerState.playing);
    if (playingIndex != -1) {
      setState(() {
        audioPlayerStates[playingIndex] = audioplayers.PlayerState.stopped;
      });
    }
  }

// Stop all audio players
  void _stopAllPlayers() {
    audioPlayer.stop();
    setState(() {
      // Reset all player states to STOPPED
      audioPlayerStates = List.filled(chatInboxController.roomChatList.length,
          audioplayers.PlayerState.stopped);
    });
  }

// Subscribe to player state changes
  void _subscribeToPlayerStateChanges() {
    audioPlayer.onPlayerStateChanged.listen((audioplayers.PlayerState state) {
      setState(() {
        // Not necessary to update player state here as it's being managed by audioPlayerStates list
      });
    });
  }

  Future<void> _startRecording(ChatInboxController value,
      BuildContext context) async {
    if (!await _checkPermission()) return;

    //  final Directory? appDirectory = await getExternalStorageDirectory();

    Directory? appDirectory;
    if (Platform.isAndroid) {
      appDirectory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      appDirectory = await getApplicationDocumentsDirectory();
    } else {
      // Handle other platforms if needed
      throw UnsupportedError('Unsupported platform');
    }
    final String filePath = '${appDirectory!.path}/audio_recording.aac';

    /* try {*/
    await _audioRecorder.openRecorder();
    await _audioRecorder.startRecorder(toFile: filePath);
    setState(() {
      print("isRecording is update");
      isRecording = true;
      chatInboxController.update();
      mainfilePath = filePath;
    });
    /*} catch (e) {
      print('Failed to start recording: $e');
    }*/
  }

  Future<void> _stopRecording(ChatInboxController controller,
      BuildContext context) async {
    try {
      await _audioRecorder.stopRecorder();
      await _audioRecorder.closeRecorder();
      setState(() {
        isRecording = false;
      });

      if (mainfilePath.isNotEmpty) {
        controller.UploadImage(null, mainfilePath, "recorder", context)
            .then((value) {
          if (isWebSocketConnected()) {
            print('Socket is connected!');

            var message = {
              "message": controller.messageController.text.toString(),
              "attachment": controller.attached_image,
            };
            channel.sink.add(jsonEncode(message));
            controller.messageController.clear();
            FocusScope.of(context).unfocus();
            mainfilePath = "";
            controller.attached_image = "";
          } else {
            print('Socket is not connected!');
            // Handle case when socket is not connected
          }
        });
      }
    } catch (e) {
      print('Failed to stop recording: $e');
    }
  }

  Future<bool> _checkPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      if (await Permission.microphone
          .request()
          .isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return GetBuilder<ChatInboxController>(builder: (value) {
      return value.isChatBox_Loading == true
          ? Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: ThemeProvider.loader_color,
          size: Dimens.loder_size,
        ),
      )
          : Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          color: ThemeProvider.blackColor,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: CircleAvatar(
                        maxRadius: screenWidth * 0.055,
                        backgroundColor: ThemeProvider.text_background,
                        child: Center(
                          child: SvgPicture.asset(
                            AssetPath.left_arrow,
                            height: 25,
                          ),
                        ),
                      ),
                    ),
                    CommonTextWidget(
                      heading: name,
                      fontSize: Dimens.twentyFour,
                      color: ThemeProvider.whiteColor,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                    CircleAvatar(
                      maxRadius: screenWidth * 0.055,
                      backgroundColor: ThemeProvider.blackColor,
                    )
                  ],
                ),
              ),
              value.roomChatList != null
                  ? Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                      left: 20, right: 20, bottom: 60, top: 20),
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.roomChatList.length!,
                  itemBuilder: (context, index) {
                    // Your chat message item widget
                    return Column(
                      crossAxisAlignment: value.roomChatList[index]
                          .messageSender?.uuid! !=
                          value.getUUID()
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        value.roomChatList[index].messageSender
                            ?.uuid! !=
                            value.getUUID()
                            ? Column(
                          children: [
                            value.roomChatList[index]
                                .attachment !=
                                null &&
                                value
                                    .roomChatList[index]
                                    .attachment!
                                    .isNotEmpty
                                ? Container(
                              height:
                              screenHeight * 0.3,
                              width: screenWidth * 0.6,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius
                                    .circular(20),
                                border: Border.all(
                                  color: ThemeProvider
                                      .primary,
                                  // Add your border color here
                                  width:
                                  1, // Adjust the border width as needed
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius
                                    .circular(20),
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: value
                                          .roomChatList[
                                      index]
                                          .attachment !=
                                          null,
                                      child:
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (_) {
                                                    //return FullScreenImage(imageUrl: _planDeatailsController.galleryImage?[index] ?? "" ,);
                                                    return FullScreenImage(
                                                        imageUrl:
                                                        value
                                                            .roomChatList[index]
                                                            .attachment ??
                                                            "");
                                                  }));
                                        },
                                        child: Image
                                            .network(
                                          value
                                              .roomChatList[
                                          index]
                                              .attachment!,
                                          fit: BoxFit
                                              .fill,
                                          // Adjusted here
                                          width: double
                                              .infinity,
                                          loadingBuilder: (BuildContext
                                          context,
                                              Widget
                                              child,
                                              ImageChunkEvent?
                                              loadingProgress) {
                                            if (loadingProgress ==
                                                null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child:
                                                CircularProgressIndicator(
                                                  value: loadingProgress
                                                      .expectedTotalBytes !=
                                                      null
                                                      ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: value
                                          .roomChatList[
                                      index]
                                          .attachment ==
                                          null,
                                      child: Center(
                                        child:
                                        CircularProgressIndicator(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : Container(),
                            value.roomChatList[index]
                                .message !=
                                null &&
                                value.roomChatList[index]
                                    .message!.isNotEmpty
                                ? Row(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                value
                                    .roomChatList[
                                index]
                                    .messageSender
                                    ?.profilePicture !=
                                    null
                                    ? CircleAvatar(
                                    radius: 20,
                                    //  backgroundImage: AssetImage(AssetPath.dummy_profile),
                                    backgroundImage:
                                    NetworkImage(
                                        "${value.roomChatList[index]
                                            .messageSender?.profilePicture!}"))
                                    : CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                  ThemeProvider
                                      .text_background
                                      .withOpacity(
                                      0.4),
                                  child: Icon(
                                    Icons.person,
                                    // Replace this with the desired icon
                                    color: Colors
                                        .white, // Adjust the color as needed
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  margin:
                                  const EdgeInsets
                                      .only(top: 5),
                                  constraints:
                                  BoxConstraints(
                                    maxWidth: MediaQuery
                                        .of(
                                        context)
                                        .size
                                        .width *
                                        0.7,
                                    // minWidth:  MediaQuery.of(context).size.width * 0.10
                                  ),
                                  // Set maximum width
                                  padding:
                                  const EdgeInsets
                                      .only(
                                      top: 10,
                                      bottom: 10,
                                      left: 16,
                                      right: 16),
                                  decoration:
                                  BoxDecoration(
                                    borderRadius:
                                    BorderRadius
                                        .only(
                                      topLeft: Radius
                                          .circular(6),
                                      topRight: Radius
                                          .circular(20),
                                      bottomRight:
                                      Radius
                                          .circular(
                                          20),
                                      bottomLeft: Radius
                                          .circular(20),
                                    ),
                                    color: ThemeProvider
                                        .text_background,
                                  ),
                                  child: Text(
                                    textAlign:
                                    TextAlign.start,
                                    "${value.roomChatList[index].message.toString()}",
                                    //"${Utf8Decoder().convert(value.roomChatList[index].message.toString().codeUnits)}",
                                    style: TextStyle(fontFamily: 'NotoColorEmoji' ,
                                      color: ThemeProvider
                                      .whiteColor,
                                    ),

                                    /*style: TextStyle(
                                      fontFamily:
                                      'Inter',
                                      fontWeight:
                                      FontWeight
                                          .w400,
                                      fontSize: Dimens
                                          .sixteen,
                                      color: ThemeProvider
                                          .whiteColor,
                                    ),*/
                                  ),
                                ),
                              ],
                            )
                                : Container(),
                          ],
                        )
                            : Column(
                          mainAxisAlignment:
                          MainAxisAlignment.end,
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            value.roomChatList[index]
                                .attachment !=
                                null &&
                                value
                                    .roomChatList[index]
                                    .attachment!
                                    .isNotEmpty
                                ? value.roomChatList[index]
                                .attachment!
                                .contains(".aac")
                                ? /*IconButton(
                                                icon: Icon(
                                                  audioPlayerStates[index] == audioplayers.PlayerState.PLAYING
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: ThemeProvider.whiteColor,
                                                ),
                                                onPressed: () {
                                                  // Toggle play/pause for the specific chat item
                                                  if (audioPlayerStates[index] == audioplayers.PlayerState.PLAYING) {
                                                    _pause();
                                                  } else {
                                                    _play(value.roomChatList[index].attachment!, index);
                                                  }
                                                },
                                              )*/
                            PlayPauseButton(
                              isPlaying:
                              audioPlayerStates[
                              index] ==
                                  audioplayers
                                      .PlayerState
                                      .playing,
                              onPressed: () {
                                // Toggle play/pause for the specific chat item
                                if (audioPlayerStates[
                                index] ==
                                    audioplayers
                                        .PlayerState
                                        .playing) {
                                  _pause();
                                } else {
                                  _play(
                                      value
                                          .roomChatList[
                                      index]
                                          .attachment!,
                                      index);
                                }
                              },
                            )
                                : Container(
                              height: screenHeight *
                                  0.3,
                              width:
                              screenWidth * 0.6,
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    20),
                                border: Border.all(
                                  color:
                                  ThemeProvider
                                      .primary,
                                  // Add your border color here
                                  width:
                                  1, // Adjust the border width as needed
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    20),
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: value
                                          .roomChatList[
                                      index]
                                          .attachment !=
                                          null,
                                      child:
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder:
                                                  (_) {
                                                //return FullScreenImage(imageUrl: _planDeatailsController.galleryImage?[index] ?? "" ,);
                                                return FullScreenImage(
                                                    imageUrl:
                                                    value.roomChatList[index]
                                                        .attachment ?? "");
                                              }));
                                        },
                                        child: Image
                                            .network(
                                          value
                                              .roomChatList[
                                          index]
                                              .attachment!,
                                          fit: BoxFit
                                              .fill,
                                          // Adjusted here
                                          width: double
                                              .infinity,
                                          loadingBuilder: (BuildContext context,
                                              Widget
                                              child,
                                              ImageChunkEvent?
                                              loadingProgress) {
                                            if (loadingProgress ==
                                                null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child:
                                                CircularProgressIndicator(
                                                  value: loadingProgress
                                                      .expectedTotalBytes !=
                                                      null
                                                      ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: value
                                          .roomChatList[
                                      index]
                                          .attachment ==
                                          null,
                                      child: Center(
                                        child:
                                        CircularProgressIndicator(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : Container(),
                            value.roomChatList[index]
                                .message !=
                                null &&
                                value.roomChatList[index]
                                    .message!.isNotEmpty
                                ? Container(
                              margin:
                              const EdgeInsets.only(
                                  top: 5),
                              constraints:
                              BoxConstraints(
                                maxWidth: MediaQuery
                                    .of(
                                    context)
                                    .size
                                    .width *
                                    0.7,
                                // minWidth:  MediaQuery.of(context).size.width * 0.10
                              ),
                              // Set maximum width
                              padding:
                              const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  left: 16,
                                  right: 16),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.only(
                                  topLeft:
                                  Radius.circular(
                                      20),
                                  topRight:
                                  Radius.circular(
                                      6),
                                  bottomRight:
                                  Radius.circular(
                                      20),
                                  bottomLeft:
                                  Radius.circular(
                                      20),
                                ),
                                color: ThemeProvider
                                    .primary,
                              ),
                              child: Text(
                                textAlign:
                                TextAlign.start,
                                "${value.roomChatList[index].message}",
                              //  "${Utf8Decoder().convert(value.roomChatList[index].message.toString().codeUnits)}",

                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight:
                                  FontWeight.w400,
                                  fontSize:
                                  Dimens.sixteen,
                                  color: ThemeProvider
                                      .whiteColor,
                                ),
                              ),
                            )
                                : Container(),
                          ],
                        ),
                        SizedBox(height: 10),
                        CommonTextWidget(
                          heading:
                          value.roomChatList[index].created_at_utc !=
                              null
                              ? _miliseconds_to_date(
                              userTime: timestampToString(
                                  value.roomChatList[index].created_at_utc!))
                              : "",
                          fontSize: Dimens.twelve,
                          color: ThemeProvider.chatTimeTextColor,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                    ;
                  },
                ),
              )
                  : Container(),
              type != "notification"
                  ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: screenWidth * .78,
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          //autofocus: true,
                          focusNode: myFocusNode,
                          onChanged: (value) {},
                          controller: value.messageController,
                          minLines: 3,
                          // Set this
                          maxLines: 6,
                          cursorColor: ThemeProvider.greyColor,
                          style: TextStyle(fontFamily: 'NotoColorEmoji',
                            color: ThemeProvider
                            .whiteColor,),


                          /*style: TextStyle(
                              color: ThemeProvider.whiteColor),*/
                          decoration: InputDecoration(

                            prefixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  openDialogImageType(value);
                                  // addAttachmentBottomSheet(value);
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                size: 25,
                                color: ThemeProvider.whiteColor,
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isRecording) {
                                    _stopRecording(value, context);
                                  } else {
                                    _startRecording(value, context);
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.mic_outlined,
                                size: 30,
                                color: isRecording
                                    ? ThemeProvider.redColor
                                    : ThemeProvider.whiteColor,
                              ),
                            ),
                            filled: true,
                            fillColor:
                            ThemeProvider.text_background,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ThemeProvider.greyColor),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10)),
                            hintText: 'Write an message',
                            hintStyle: TextStyle(
                                color: ThemeProvider.greyColor),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (connectivityService.isConnected.value) {
                          if (value
                              .messageController.text.isNotEmpty) {
                            _scrollToBottom(300);
                            // Check if socket is connected
                            if (isWebSocketConnected()) {
                              print('Socket is connected!');
                              var message = {
                                "message": value
                                    .messageController.text
                                    .toString(),
                                "attachment": ""
                              };
                              channel.sink.add(jsonEncode(message));
                              value.messageController.clear();
                              FocusScope.of(context).unfocus();

                              // Send message
                              // Clear message text field
                            } else {
                              print('Socket is not connected!');
                              // Handle case when socket is not connected
                            }
                          }
                        } else {
                          showToast(AppString.internet_connection);
                        }
                      },
                      child: Container(
                        height: Get.height * .065,
                        width: Get.width * .14,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(70),
                            gradient: LinearGradient(colors: [
                              ThemeProvider.buttonfirstClr,
                              ThemeProvider.buttonSecondClr,
                              ThemeProvider.buttonThirdClr
                            ])),
                        child: Center(
                          child: SvgPicture.asset(AssetPath.send),
                        ),
                      ),
                    )
                  ],
                ),
              )
                  : SizedBox.shrink()
            ],
          ),
        ),
      );
    });
  }

  bool isWebSocketConnected() {
    return channel.closeCode == null; // Returns true if WebSocket is connected
  }

  String _miliseconds_to_date({required String userTime}) {
    // Parse the string date into a DateTime object
    DateTime notificationDate = DateTime.parse(userTime);

    // Format the time to 'HH:mm' (24-hour clock format)
    String formattedTime = DateFormat.Hm().format(notificationDate);

    return formattedTime; // Return the formatted time
  }

  /*void addAttachmentBottomSheet(ChatInboxController value) {
    showModalBottomSheet(
      constraints: BoxConstraints(
        maxWidth: screenWidth,
      ),
      context: context,
      backgroundColor: ThemeProvider.text_color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      isScrollControlled: true,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: screenHeight * 0.15,
                width: screenWidth,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                              title: Text('Choose From'.tr),
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    selectFromGallery('camera', value, context);
                                  },
                                  child: Text('Camera'.tr),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    selectFromGallery(
                                        'gallery', value, context);
                                  },
                                  child: Text('Gallery'.tr),
                                ),
                                CupertinoActionSheetAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'.tr),
                                )
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 55,
                          color: ThemeProvider.whiteColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {

                          setState(() {
                            if(isRecording){
                              _stopRecording();
                            }else{

                              _startRecording();
                            }
                          });


                        },
                        child: Icon(
                          Icons.mic,
                          size: 55,
                          color: isRecording ? ThemeProvider.redColor :ThemeProvider.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ));
          },
        );
      },
    );
  }*/

  Future<void> openDialogImageType(ChatInboxController value) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
            title: Text('Choose From'.tr),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  selectFromGallery('camera', value, context);
                },
                child: Text('Camera'.tr),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  selectFromGallery('gallery', value, context);
                },
                child: Text('Gallery'.tr),
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'.tr),
              )
            ],
          ),
    );
  }

  void selectFromGallery(String kind, ChatInboxController controller,
      BuildContext context) async {
    selectedImage = await ImagePicker().pickImage(
      source: kind == 'gallery' ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 25,
    );

    if (selectedImage != null) {
      final croppedImage =
      await cropImage(imageFile: File(selectedImage!.path));

      if (croppedImage != null) {
        controller.UploadImage(croppedImage, "", "image", context)
            .then((value) {
          if (isWebSocketConnected()) {
            print('Socket is connected!');

            var message = {
              "message": controller.messageController.text.toString(),
              "attachment": controller.attached_image,
            };
            channel.sink.add(jsonEncode(message));
            controller.messageController.clear();
            FocusScope.of(context).unfocus();
            controller.attached_image = "";
          } else {
            print('Socket is not connected!');
            // Handle case when socket is not connected
          }
        });
      }
    }
  }

  Future<XFile?> cropImage({required File imageFile}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
    );
    if (croppedFile == null) return null;
    return XFile(croppedFile.path);
  }


  String timestampToString(String timestamp) {
    // Parse the string to an integer
    int timestampInt = int.parse(timestamp);

    // Convert the integer timestamp to a DateTime object
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000);

    // Return the DateTime object as a string
    return dateTime.toString();
  }

}
