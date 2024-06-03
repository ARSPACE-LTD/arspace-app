import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../backend/helper/app_router.dart';
import '../controller/complete_profile_controller.dart';
import '../util/dimens.dart';
import '../util/environment.dart';
import '../util/theme.dart';
import '../util/all_constants.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:intl/intl.dart';

import 'connectivity_service.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;
  GlobalKey<FormState> complete_profile_formKey = GlobalKey<FormState>();
  final CompleteProfileController completeProfileController =
      Get.put(CompleteProfileController(parser: Get.find()));

  @override
  void initState() {
    completeProfileController.initialized;
    completeProfileController.getUserProfileApi();
    completeProfileController.profile_image = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<CompleteProfileController>(builder: (value) {
      return value.isProfileLoading == true
          ? Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: ThemeProvider.loader_color,
          size: Dimens.loder_size,
        ),
      )
          : Scaffold(
              backgroundColor: ThemeProvider.blackColor,
              resizeToAvoidBottomInset: true,
              appBar: value.isBottomSheetOpen == false
                  ? AppBar(
                      centerTitle: true,
                      backgroundColor: ThemeProvider.blackColor,
                      leading: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: ThemeProvider.whiteColor,
                          size: 20,
                        ),
                      ),
                      title: CommonTextWidget(
                        heading: AppString.my_rofile,
                        fontSize: Dimens.twenty,
                        color: ThemeProvider.whiteColor,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                      ))
                  : null,
              body: Stack(
                children: [
                  SafeArea(
                    child: Form(
                      key: complete_profile_formKey,
                      child: Container(
                        height: screenHeight,
                        color: ThemeProvider.blackColor,
                        padding: EdgeInsets.only(
                          left: Get.width * 0.06,
                          right: Get.width * 0.06,
                        ),
                        child: WillPopScope(
                          onWillPop: () async {
                            if (value.isBottomSheetOpen) {
                              Get.close(2);

                              // If the bottom sheet is open, close it
                              //Navigator.of(context).pop();

                              value.toggleBottomSheet();
                              return false; // Prevent default back press behavior
                            } else {
                              // If the bottom sheet is closed, check if the AppBar back button is pressed
                              if (Navigator.of(context).canPop()) {
                                // If you can pop, navigate back
                                Navigator.of(context).pop();
                                return false; // Prevent default back press behavior
                              } else {
                                // If neither bottom sheet nor AppBar can be popped, allow default back press behavior
                                return true;
                              }
                            }
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.02,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
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
                                                value.selectFromGallery(
                                                    'camera');
                                              },
                                              child: Text('Camera'.tr),
                                            ),
                                            CupertinoActionSheetAction(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                value.selectFromGallery(
                                                    'gallery');
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
                                    child: Stack(
                                      children: [
                                        Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          width: 100,
                                          height: 100,
                                          child: value.profile_image != null && value.profile_image != ""
                                              ? Image.file(
                                            File(
                                                value.profile_image!),
                                            width: 200.0,
                                            height: 200.0,
                                            fit: BoxFit.fill,
                                          )
                                              : value.getProfileResponse.data!
                                              .profilePicture !=
                                              null &&
                                              value
                                                  .getProfileResponse
                                                  .data!
                                                  .profilePicture!
                                                  .isNotEmpty
                                              ? CircleAvatar(
                                            maxRadius: screenWidth * 0.12,
                                            backgroundColor: ThemeProvider
                                                .text_background
                                                .withOpacity(0.4),
                                            backgroundImage: NetworkImage(
                                                "${value.getProfileResponse.data?.profilePicture ?? ""}"),
                                          )
                                                  : Image.asset(
                                                      AssetPath.notfound,
                                                      height: Get.height * 0.7,
                                                      width: Get.width,
                                                      fit: BoxFit.fill,
                                                    ),
                                        ),

                                        //  value.getProfileResponse.data!.profilePicture!.isNotEmpty || value.profile_image != null?
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: ThemeProvider.primary,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: ThemeProvider.whiteColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.04,
                                ),
                                Container(
                                  child: CommonTextWidget(
                                    heading: AppString.user_name,
                                    fontSize: Dimens.twenty,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                CustomTextField(
                                  controller: value.userNameController,
                                  hintText: AppString.input_your_user_name,
                                  keyboardType: TextInputType.text,
                                  backgroundColor:
                                      ThemeProvider.text_background,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppString.error_userName;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: screenHeight * 0.03,
                                ),
                                Container(
                                  child: CommonTextWidget(
                                    heading: AppString.upload_your_photo,
                                    fontSize: Dimens.twenty,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                value.images != null
                                    ? /*Container(
                                  // Adjust the height based on your needs
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                    ),
                                    itemCount: value.images!.length +
                                        (value.images!.length < 6 ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index < value.images!.length) {
                                        return Container(
                                          margin: EdgeInsets.all(5),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Image.file(
                                            File(value.images![index].path),
                                            fit: BoxFit.cover,
                                            width: Get.width * 0.30,
                                            height: Get.width * 0.30,
                                          ),
                                        );
                                      } else {
                                        // Display "Add More" option
                                        return InkWell(
                                          onTap: () {
                                            value.pickImages();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Image.asset(
                                              AssetPath.notfound,
                                              width: Get.width * 0.30,
                                              height: Get.width * 0.30,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )*/
                                    GridView.builder(
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                        ),
                                        itemCount: value.images!.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index < value.images!.length) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(5),
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: value.images![index].toString().contains("https")
                                                      ? Image.network("${value.images![index]}" , fit: BoxFit.cover,
                                                    width:
                                                    Get.width * 0.30,
                                                    height:
                                                    Get.width * 0.30,)
                                          /*CircleAvatar(
                                                          backgroundColor:
                                                              ThemeProvider
                                                                  .text_background
                                                                  .withOpacity(
                                                                      0.4),
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  "${value.images![index]}"),
                                                        )*/
                                                      : Image.file(
                                                          File(value
                                                              .images![index]
                                                              .path),
                                                          fit: BoxFit.cover,
                                                          width:
                                                              Get.width * 0.30,
                                                          height:
                                                              Get.width * 0.30,
                                                        ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: InkWell(
                                                    onTap: () {
                                                      value.removeImage(index);
                                                    },
                                                    child: CircleAvatar(
                                                      maxRadius:
                                                          screenWidth * 0.030,
                                                      backgroundColor:
                                                          ThemeProvider
                                                              .whiteColor,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            // Display "Add More" option
                                            if (value.images!.length <= 5) {
                                              return InkWell(
                                                onTap: () {
                                                  value.pickImages();
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(5),
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Image.asset(
                                                    AssetPath.notfound,
                                                    width: Get.width * 0.30,
                                                    height: Get.width * 0.30,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      )
                                    : InkWell(
                                        onTap: () {
                                          value.pickImages();
                                        },
                                        child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Image.asset(
                                            AssetPath.notfound,
                                            width: Get.width * 0.30,
                                            height: Get.width * 0.30,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: screenHeight * 0.03,
                                ),
                                Container(
                                  child: CommonTextWidget(
                                    heading: AppString.your_birthday,
                                    fontSize: Dimens.twenty,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                CustomTextField(
                                  readOnly: true,
                                  controller: value.dobController,
                                  hintText: AppString.dop,
                                  keyboardType: TextInputType.text,
                                  backgroundColor:
                                      ThemeProvider.text_background,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        pickedDate(value);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                    ),
                                  ),
                                  ontap: () {
                                    pickedDate(value);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppString.error_msg_date_of_birth;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: screenHeight * 0.03,
                                ),
                                CommonTextWidget(
                                  heading: AppString.your_gender,
                                  fontSize: Dimens.twenty,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          value.handleGenderSelection("man"),
                                      child: genderSelection(
                                          "man",
                                          value,
                                          value.selectedGender == "man"
                                              ? ThemeProvider.whiteColor
                                              : ThemeProvider.text_background),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.03,
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          value.handleGenderSelection("woman"),
                                      child: genderSelection(
                                          "woman",
                                          value,
                                          value.selectedGender == "woman"
                                              ? ThemeProvider.whiteColor
                                              : ThemeProvider.text_background),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.03,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonTextWidget(
                                      heading: AppString.interest,
                                      fontSize: Dimens.twenty,
                                      color: ThemeProvider.whiteColor,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w700,
                                    ),
                                    RichText(
                                      text: new TextSpan(
                                        // Note: Styles for TextSpans must be explicitly defined.
                                        // Child text spans will inherit styles from parent
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                          color: ThemeProvider.whiteColor,
                                        ),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text:
                                                  '${value.Interest_list.length}'),
                                          new TextSpan(
                                              text:
                                                  '/${value.edit_Interest_list.length}',
                                              style: new TextStyle(
                                                  color: ThemeProvider
                                                      .text_light_gray)),
                                        ],
                                      ),
                                    ),
                                    /* CommonTextWidget(
                                heading: AppString.interest,
                                fontSize: Dimens.sixteen,
                                color: ThemeProvider.whiteColor,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),*/
                                  ],
                                ),
                                value.Interest_list != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          spacing: 8.0,
                                          // Set spacing between items horizontally
                                          runSpacing: 8.0,
                                          // Set spacing between items vertically
                                          children: [
                                            ...value.Interest_list.map((item) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: ThemeProvider
                                                        .text_background),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: CommonTextWidget(
                                                    heading: item.title!,
                                                    fontSize: Dimens.forteen,
                                                    color: ThemeProvider
                                                        .whiteColor,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              );
                                            }),
                                            if (value.Interest_list.length ==
                                                    0 ||
                                                value.Interest_list.length <
                                                    value.edit_Interest_list
                                                        .length)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: ThemeProvider
                                                        .text_background),
                                                child: InkWell(
                                                  onTap: () {
                                                    openBottomSheet(
                                                        context, value);
                                                    // Handle Edit button click
                                                    print(
                                                        'Edit button clicked!');
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: CommonTextWidget(
                                                      heading:
                                                          '+ edit intrerst',
                                                      fontSize: Dimens.forteen,
                                                      color: ThemeProvider
                                                          .whiteColor,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    : Wrap(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: ThemeProvider
                                                    .text_background),
                                            child: InkWell(
                                              onTap: () {
                                                openBottomSheet(context, value);

                                                // Handle Edit button click
                                                print('Edit button clicked!');
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: CommonTextWidget(
                                                  heading: '+ edit intrerst',
                                                  fontSize: Dimens.forteen,
                                                  color:
                                                      ThemeProvider.whiteColor,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(
                                  height: screenHeight * 0.03,
                                ),
                                CommonTextWidget(
                                  heading: AppString.self_intro,
                                  fontSize: Dimens.twenty,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.02,
                                ),
                                CustomTextField(
                                  controller: value.IntroController,
                                  minLines: 3,
                                  // Set this
                                  maxLines: 6,
                                  hintText: AppString.write_an_massage,
                                  keyboardType: TextInputType.text,

                                  backgroundColor:
                                      ThemeProvider.text_background,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppString.error_write_an_massage;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: screenHeight * 0.06,
                                ),
                                SubmitButton(
                                  onPressed: () => {
                                    if (complete_profile_formKey.currentState!
                                        .validate())
                                      {

                                    connectivityService.isConnected.value
                                    ? value.onbuttonClicked( context)
                                  : showToast(AppString.internet_connection)


                                        //  Get.toNamed(AppRouter.requestToSetProfile()),
                                      }
                                  },
                                  title: AppString.Continue,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (value.isBottomSheetOpen)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        //  color: Colors.black.withOpacity(0.6),
                        // Adjust opacity as needed
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ThemeProvider.background_first_Clr
                                  .withOpacity(0.4),
                              ThemeProvider.background_second_Clr
                                  .withOpacity(0.4)
                            ],
                          ), // Set the main screen gradient
                        ),
                      ),
                    ),
                ],
              ),
            );
    });
  }

  Widget genderSelection(
      String gender, CompleteProfileController value, Color borderClr) {
    return Container(
      width: Get.width * 0.42,
      height: Get.width * 0.20,
      //  clipBehavior: Clip.antiAlias,
      //color: Colors.white,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ThemeProvider.text_background,
        border: Border.all(
          width: 1.5,
          color: value.selectedGender == gender
              ? ThemeProvider.whiteColor
              : ThemeProvider.text_background,
        ),
      ),

      child: Row(
        children: [
          SizedBox(
            width: 15,
          ),
          Image.asset(
            width: 40,
            height: 40,
            gender == "man" ? AssetPath.man : AssetPath.woman,
            fit: BoxFit.fill,
          ),
          SizedBox(
            width: 10,
          ),
          CommonTextWidget(
            heading: gender == "man" ? AppString.man : AppString.woman,
            fontSize: Dimens.twenty,
            color: ThemeProvider.whiteColor,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  pickedDate(CompleteProfileController value) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime.now());

    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        value.dobController.text =
            formattedDate; //set output date to TextField value.
      });
    } else {}
  }

  void openBottomSheet(context, CompleteProfileController value) {
    value.toggleBottomSheet();
    Get.bottomSheet(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Container(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: ThemeProvider.blackColor,
                ),
                height: Get.height * 0.80,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget(
                              heading: AppString.edit_intrersting,
                              fontSize: Dimens.twentyFour,
                              color: ThemeProvider.whiteColor,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w800,
                            ),
                            InkWell(
                              onTap: () {
                                value.toggleBottomSheet();
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                AssetPath.cross_button,
                                width: Get.width * 0.08,
                                height: Get.width * 0.08,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget(
                              heading: AppString.pick_interests,
                              fontSize: Dimens.sixteen,
                              color: ThemeProvider.whiteColor,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            RichText(
                              text: new TextSpan(
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: ThemeProvider.whiteColor,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(
                                      text: '${value.Interest_list.length}'),
                                  new TextSpan(
                                      text:
                                          '/${value.edit_Interest_list.length}',
                                      style: new TextStyle(
                                          color:
                                              ThemeProvider.text_light_gray)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin:
                                  EdgeInsets.only(bottom: Get.height * 0.020),
                              child: Wrap(
                                spacing: 8.0,
                                // Set spacing between items horizontally
                                runSpacing: 8.0,
                                // Set spacing between items vertically
                                children: value.edit_Interest_list.map((item) {
                                  bool isSelected =
                                      value.Interest_list.contains(item);

                                  return GestureDetector(
                                    onTap: () {
                                      // value.toggleSelection(item);
                                      setState(() {
                                        if (isSelected) {
                                          value.Interest_list.remove(item);
                                          value.selectsInterest_list
                                              .remove(item);
                                          value.updatefunction();
                                        } else {
                                          value.Interest_list.add(item!);
                                          value.selectsInterest_list
                                              .add(item.uuid!);
                                          value.updatefunction();
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: isSelected
                                            ? ThemeProvider
                                                .primary // Change to your selected color
                                            : ThemeProvider.text_background,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: CommonTextWidget(
                                          heading: item.title!,
                                          fontSize: Dimens.forteen,
                                          color: ThemeProvider.whiteColor,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ) ,
                        SizedBox(
                          height: screenHeight * 0.08,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 20,
                right: 20,
                child: SubmitButton(
                  onPressed: () =>
                      {value.toggleBottomSheet(), Navigator.pop(context)},
                  title: AppString.Continue,
                ),
              ),
            ],
          ),
        );
      }),
      backgroundColor: Colors.transparent,
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      isDismissible: false,
      enableDrag: true,
    ).then((value) => {
          // value.toggleBottomSheet()
        });
  }
}
