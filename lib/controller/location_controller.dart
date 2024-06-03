import 'package:arspace/backend/parser/location_parser.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../backend/api/handler.dart';
import '../backend/helper/app_router.dart';
import '../backend/helper/uuid_generator.dart';
import '../backend/models/google_places_model.dart';
import '../util/environment.dart';
import '../util/toast.dart';

class LocationController extends GetxController {
  final LocationParser parser;
  final searchController = TextEditingController();
  List<GooglePlacesModel> _getList = <GooglePlacesModel>[];
  List<GooglePlacesModel> get getList => _getList;
  List recentSearchList = [];
  String currentAddress = "";
  double myLat = 51.509865;
  double myLng = -0.118092;

  bool isConfirmed = false;
  bool isFetchingLocation = true;

  LocationController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLocation();
    });
  }

  void getLocation() async {
    isFetchingLocation = true;
    _determinePosition().then((value) async {
      isFetchingLocation = false;
      debugPrint(value.toString());
      List<Placemark> newPlace = await placemarkFromCoordinates(value.latitude, value.longitude);
      Placemark placeMark = newPlace[0];
      String name = placeMark.name.toString();
      String subLocality = placeMark.subLocality.toString();
      String locality = placeMark.locality.toString();
      String administrativeArea = placeMark.administrativeArea.toString();
      String postalCode = placeMark.postalCode.toString();
      String country = placeMark.country.toString();
      String address = "$name,$subLocality,$locality,$administrativeArea,$postalCode,$country";
      String shrt_address = "$subLocality,$administrativeArea";
      print("name == $name , subLocality== $subLocality , administrativeArea== $administrativeArea , postalCode===$postalCode ,country==  $country");
      currentAddress = shrt_address;
      update();
      print("CurrentAddress--> $currentAddress");
      debugPrint(address);
      parser.saveLatLng(value.latitude, value.longitude, shrt_address ,shrt_address);
      print("latlng--->${value.latitude}${value.longitude}");
    }).catchError((error) async {
      Get.back();
      showToast(error.toString());
      await Geolocator.openLocationSettings();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.'.tr);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied'.tr);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.'
              .tr);
    }
    return await Geolocator.getCurrentPosition();
  }

  void onSearchChanged(String value) {
    debugPrint(value);
    if (value.isNotEmpty) {
      getPlacesList(value);
    }
  }

  Future<void> getPlacesList(String value) async {
    String googleURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    var sessionToken = Uuid().generateV4();
    var googleKey = Environments.googleMapsKey;
    String request =
        '$googleURL?input=$value&key=$googleKey&sessiontoken=$sessionToken&types=locality';

    '$googleURL?input=$value&key=$Environments.googleMapsKey&sessiontoken=$sessionToken';
    Response response = await parser.getPlacesList(request);

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['predictions'];

      print("MaP_body == ${body.toString()}");


      _getList = [];
      body.forEach((data) {
        GooglePlacesModel datas = GooglePlacesModel.fromJson(data);

        print("MaP body forEach == ${body.toString()}");

        _getList.add(datas);

      });
      isConfirmed = false;
      update();
      debugPrint(_getList.length.toString());
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getLatLngFromAddress(String address, String recent) async {
    List<Location> locations = await locationFromAddress(address);
    debugPrint(locations.toString());
    if (locations.isNotEmpty) {
      if(recent.isEmpty || recent == ""){
        recentSearchList.insert(0, address);
      }

      print("recentSearchList--->${recentSearchList.toString()}");
      _getList = [];
      searchController.text = address;
      myLat = locations[0].latitude;
      myLng = locations[0].longitude;
      isConfirmed = true;


      parser.saveLatLng(myLat, myLng, address ,address);

      update();

      if(parser.CheckToken() != null && parser.CheckToken().isNotEmpty){
        UpDateLocation();
      }

    }
  }


  Future<void> UpDateLocation() async {
    var body = {
      // "email": countryCodeController.text,
      "location": parser.sharedPreferencesManager.getString("address")?? '',
      "latitude":parser.sharedPreferencesManager.getDouble("lat")?? 0.0,
      "longitude":parser.sharedPreferencesManager.getDouble("lng")?? 0.0,
    };

    Response response = await parser.PutLocation(body);

    print("UpDateLocation body--->${response.body}");
    if (response.statusCode == 200) {

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      print("UpDateLocation ---->${myMap.toString()}");

      update();
      Get.toNamed(AppRouter.getDashboardScreenRoute(), preventDuplicates: false);

    }
    else if (response.statusCode == 401) {
      parser.ClearPrafrence();
      Get.toNamed(AppRouter.getLoginRoute(), preventDuplicates: false);

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      if (myMap['auth'] == false) {
        showToast(myMap['error']);
      } else {
        if (myMap['error'] != '') {
          showToast(myMap['error']);
        } else {
          showToast('Token Expire');
        }
      }
      update();
    }
    else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}