import 'dart:io';

import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../backend/api/api.dart';
import '../backend/helper/app_router.dart';
import '../backend/models/InterestsModel.dart';
import '../backend/models/getUserProfile.dart';
import '../backend/models/imagesModel.dart';
import '../backend/parser/CompleteProfileParser.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../view/connectivity_service.dart';

class CompleteProfileController extends GetxController {
  final ConnectivityService connectivityService = Get.find();
  final CompleteProfileParser parser;
  final formKey = GlobalKey<FormState>();
  XFile? selectedImage;
  var profile_image;

  bool isBottomSheetOpen = false;
  bool isProfileLoading = true;
  GetProfileResponse getProfileResponse = GetProfileResponse();

  List<dynamic>? images = [];
  List<String>? images_uuid = [];
  //List<XFile>? images;
  List<XFile>? upload_images  = [];

  List<InterestsModel> Interest_list = <InterestsModel>[];
  List<String> selectsInterest_list = <String>[];

  List<InterestsModel> edit_Interest_list = <InterestsModel>[];
  List<ImagesModel> images_list = <ImagesModel>[];

  final userNameController = TextEditingController();
  final dobController = TextEditingController();
  final IntroController = TextEditingController();

  String selectedGender = "man";
  Color? man_boder_color, Woman_boder_color;

  // Set the default gender

  // Function to handle the gender selection

  @override
  void onInit() {
    super.onInit();
    Interest_list.clear();
    selectsInterest_list.clear();
    edit_Interest_list.clear();

   if(connectivityService.isConnected.value){
     getInterst();
   }else{
     showToast(AppString.internet_connection);
     Get.back();
   }


  }

  updatefunction() {
    update();
  }

  handleGenderSelection(String gender) {
    selectedGender = gender;
    update();
  }

  CompleteProfileController({required this.parser});

  void selectFromGallery(String kind) async {
    selectedImage = await ImagePicker().pickImage(
      source: kind == 'gallery' ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 25,
    );

    //  profile_image = File(selectedImage).path;

    if (selectedImage != null) {
      // Use cropImage to allow the user to crop the selected image
      final croppedImage = await cropImage(
          imageFile: File(selectedImage!.path), type: "profile");

      // If the user cancels cropping or an error occurs, croppedImage will be null
      if (croppedImage != null) {
        profile_image = File(croppedImage.path).path;
        update();
      }
    }
  }

 /* Future<void> pickImages() async {
    try {
      final List<XFile>? result = await ImagePicker().pickMultiImage();

      if (result != null ) {
        // Initialize the list if it's null (user's first time)
        images ??= [];
        List<XFile?> croppedImages = [];

        // List to store only the cropped images
        if (images!.length + images!.length <= 5) {
          for (XFile imageFile in result) {
            final croppedImage =
                await cropImage(imageFile: File(imageFile.path), type: '');
            if (croppedImage != null) {
              // Add the cropped image to the list
              croppedImages.add(croppedImage);
            }
          }

          images!.addAll(croppedImages.whereType<XFile>());
        } else {
          showToast('You can select only six images or less than six');
        }

        update();
      }
    } catch (e) {
      // Handle exception
      print("Error picking images: $e");
    }
  }*/

  Future<void> pickImages() async {
    try {
      final List<XFile>? result = await ImagePicker().pickMultiImage();

      if (result != null) {
        // Initialize the list if it's null (user's first time)
        images ??= [];
        List<XFile?> croppedImages = [];

        // Calculate the maximum number of images that can be added
        int maxImages = 6 - images!.length;

        // Check if the user has exceeded the maximum number of allowed images
        if (result.length > maxImages) {
          showToast('You can select only up to 6 images.');
          return;
        }


        // List to store only the cropped images
        for (XFile imageFile in result) {
          final croppedImage = await cropImage(imageFile: File(imageFile.path), type: '');
          if (croppedImage != null) {
            // Add the cropped image to the list
            croppedImages.add(croppedImage);
          }
        }

        // Add the cropped images to the main list
        images!.addAll(croppedImages.whereType<XFile>());

        update();
      }
    } catch (e) {
      // Handle exception
      print("Error picking images: $e");
    }
  }

  Future<XFile?> cropImage(
      {required File imageFile, required String type}) async {
    CroppedFile? croppedFile;
    if (type == "profile") {
      croppedFile = await ImageCropper()
          .cropImage(sourcePath: imageFile.path, cropStyle: CropStyle.circle);
    } else {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
      );
    }

    if (croppedFile == null) return null;
    return XFile(croppedFile.path);
  }

  void removeImage(int index) {
    print("selected image index $index");
    if (images != null && index >= 0 && index < images!.length) {

      if(images![index].toString().contains("https")){


          for (var img in getProfileResponse.data!.images!) {
            if (img.image == images![index].toString()) {
              String? image = img.image;
              String? image_uuid = img.uuid;
              print("delete image === $image");
              print("delete uuid === $image_uuid");
              print("after that we need to call api");
              DelateImage(image_uuid!);

              break;
            //  need to call there api
            }
          }




      }

      images!.removeAt(index);

      update();
    }
  }

  void toggleBottomSheet() {
    isBottomSheetOpen = !isBottomSheetOpen;
    update();
  }

  Future<void> onbuttonClicked(BuildContext context) async {
    if (profile_image == null || profile_image == "") {

      if(getProfileResponse.data!
          .profilePicture ==
          null){
        showToast('Please select profile image');
        return;
      }

    } else if (selectsInterest_list.length <= 0) {
      showToast('Please edit Intrerst');
      return;
    }
    if(images == null || images!.length <= 0){
      showToast('Please select any your photos');
      return;
    }

    upload_images!.clear();
    upload_images ??= [];

    if (images != null) {
      for (int i = 0; i < images!.length; i++) {
        if(!images![i].toString()!.contains("https")){
          upload_images!.add(images![i] as XFile);
        }
      }
    }

    // String finalNumber = countryCodeController.text + mobileNumberController.text;

    final multipartBody = [

      if(selectedImage != null)
      MultipartBody('profile_picture', selectedImage as XFile),

      // MultipartBody('profile_picture', selectedImage as XFile),
      // Add each image from the images list separately

        for (var image in upload_images!) MultipartBody('images', image),


    ];

    final textData = {
      "full_name": userNameController.text.toString(),
      "dob": dobController.text.toString(),
      "intro": IntroController.text.toString(),
      "gender": selectedGender == 'man' ? "male" : "female",
      "latitude": parser.sharedPreferencesManager.getDouble('lat') ?? '',
      "longitude": parser.sharedPreferencesManager.getDouble('lng') ?? '',
      "is_profile_setup": true,
      "device_token":  AppConstants.fcm_token,
    };


    if (selectsInterest_list.length > 0) {
      if (selectsInterest_list.isNotEmpty) {
        textData["interests"] = selectsInterest_list
            .join(','); // Join interests into a single string
      }

      /* selectsInterest_list.forEach((data) {
        textData["interests"] = data.toString();
      });*/
    }

    //HtmlLoader();
    // htmlLoaderController.startLoading();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            color: ThemeProvider.loader_color,
            size: Dimens.loder_size,
          ),
        ); // Display the custom loader
      },
    );

    var response = await parser.completeProfile_api(textData, multipartBody);
    Navigator.of(context).pop();

    print("response body--->${response.body}");
    print("response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == true) {
        /// successToast(myMap['message']);

        Get.toNamed(AppRouter.getDashboardScreenRoute());
      }
    } else if (response.statusCode == 401) {
      showToast('Something went wrong while signup');
      update();
    } else if (response.statusCode == 404) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      showToast(myMap['error']);
      update();
    } else if (response.statusCode == 500) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['message'] != '') {
        showToast(myMap['message']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  Future<void> getInterst() async {
    edit_Interest_list.clear();

    var response = await parser.getInterst_api();

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == true) {
        //  successToast(myMap['message']);

        dynamic body = myMap["data"];
        // finalchatList.clear();
        // chatList.clear();
        print(
            "Hello edit_Interest_list ===> " + response.bodyString.toString());
        log("edit_Interest_list result length is ${edit_Interest_list.length} ");
        body.forEach((data) {
          InterestsModel datas = InterestsModel.fromJson(data);
          edit_Interest_list.add(datas);
        });
        update();
      }
    } else if (response.statusCode == 401) {
      showToast('Something went wrong for fetching edit Interest list');
      update();
    } else if (response.statusCode == 404) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      showToast(myMap['error']);
      update();
    } else if (response.statusCode == 500) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['message'] != '') {
        showToast(myMap['message']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  /*void onBackRoutes() {
      var context = Get.context as BuildContext;
      Navigator.of(context).pop(true);
    }*/

  Future<void> getUserProfileApi() async {
    Response response = await parser.getUserProfile();

    print("response body--->${response.body}");
    print("response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      getProfileResponse = GetProfileResponse.fromJson(myMap);
      print(
          "UserProfileResponse ---->${getProfileResponse.message.toString()}");

      if (getProfileResponse.data!.fullName != null) {
        userNameController.text = getProfileResponse.data!.fullName!;
      }
      if (getProfileResponse.data!.dob != null) {
        dobController.text = formatDate(getProfileResponse.data!.dob!);
      }
      if (getProfileResponse.data!.intro != null) {
        IntroController.text = getProfileResponse.data!.intro!;
      }
      if (getProfileResponse.data!.gender != null) {
        if (getProfileResponse.data!.gender.toString() == "male") {
          selectedGender = "man";
        } else {
          selectedGender = "woman";
        }
      }

      print("(getProfileResponse.data!.images======= ${getProfileResponse.data!.images!.length}");


      images!.clear();
      images ??= [];
      images_uuid!.clear();
      images_uuid ??= [];
      //images_uuid

      if (getProfileResponse.data!.images != null) {


          for (int i = 0; i < getProfileResponse.data!.images!.length; i++) {
            images?.add(getProfileResponse.data!.images![i].image);
          }


        /*images?.addAll(
            getProfileResponse.data!.images!. as Iterable<Images>);*/

      /*  getProfileResponse.data!.images!.forEach((image_data) {
          images?.add(image_data.image);
        });*/

      }

      print("(fetch images======= ${images?.length}");

      Interest_list.clear();
      selectsInterest_list.clear();

      Interest_list?.addAll(
          getProfileResponse.data!.interests as Iterable<InterestsModel>);

      if(Interest_list!.isNotEmpty){
        Interest_list.forEach((data) {
          selectsInterest_list?.add(data.uuid!);
        });
      }


      isProfileLoading = false;
      update();


    } else if (response.statusCode == 401) {
      isProfileLoading = false;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['auth'] == false) {
        showToast(myMap['message'.tr]);
      } else {
        showToast('Something went wrong'.tr);
      }
      update();
    } else {
      isProfileLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  Future<void> DelateImage(String uuid) async {

    var response = await parser.DeleteUserImage(uuid);

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      showToast('Delete Image Susss');

      update();
    } else if (response.statusCode == 401) {
      showToast('Something went wrong for fetching edit Interest list');
      update();
    } else if (response.statusCode == 404) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      showToast(myMap['error']);
      update();
    } else if (response.statusCode == 500) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['message'] != '') {
        showToast(myMap['message']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

}
