
import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/model/categoty_model.dart';
import 'package:ride_sharing_user_app/view/screens/profile/model/profile_model.dart';
import 'package:ride_sharing_user_app/view/screens/profile/model/reward_model.dart';
import 'package:ride_sharing_user_app/view/screens/profile/model/vehicle_brand_model.dart';
import 'package:ride_sharing_user_app/view/screens/profile/repository/profile_repo.dart';
import 'package:ride_sharing_user_app/view/screens/profile/widget/vehicle_body.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/config.dart';
import 'package:ride_sharing_user_app/view/widgets/confirmation_dialog.dart';

class ProfileController extends GetxController implements GetxService{
  final ProfileRepo profileRepo;

  ProfileController({required this.profileRepo});


  bool isLoading = false;
  List<RewardModel> rewardList = [];
  List<String> termList = [];

  List<String> profileType = ['my_profile', 'my_vehicle'];

  int _profileTypeIndex = 0;
  int get profileTypeIndex => _profileTypeIndex;



  void setProfileTypeIndex(int index){
    _profileTypeIndex = index;
    update();
  }


  final zoomDrawerController = ZoomDrawerController();
  bool toggle = false;

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    toggle = ! toggle;
    debugPrint("Toggle drawer===>$toggle");
    update();
  }



  int _offerSelectedIndex = 0;
  int get offerSelectedIndex => _offerSelectedIndex;

  void setOfferTypeIndex(int index){
    _offerSelectedIndex = index;
    update();
  }



  ProfileInfo? profileInfo;

  String driverName = '';
  String driverImage = '';
  String driverId = '';

  String isOnline = '0';
  Future<Response> getProfileInfo() async {
    isLoading = true;
    Response? response = await profileRepo.getProfileInfo();
    if(response!.statusCode == 200){
      profileInfo = ProfileModel.fromJson(response.body).data!;
      driverId = profileInfo!.id!;
      driverImage = profileInfo!.profileImage??'';
      print('call-----profiledata----> ${profileInfo?.details?.isOnline}');
      isOnline = profileInfo?.details?.isOnline ?? '0';
      if (isOnline == "1") {
        LocationPermission permission = await Geolocator.checkPermission();
        if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
            || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
          Get.dialog(ConfirmationDialog(
            icon: Images.location,
            description: 'this_app_collects_location_data'.tr,
            onYesPressed: () {
              Get.back();
              _checkPermission(() => startLocationRecord());
            },
          ), barrierDismissible: false);
        }else {
          startLocationRecord();
        }
      } else {
        stopLocationRecord();
      }
    }else{
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;

  }


  Future<void> getDailyLog() async {
    Response? response = await profileRepo.dailyLog();
    if(response!.statusCode == 200){
    }
    update();

  }

  Future<Response> updateProfile( String firstName, String lastName, email) async {
    isLoading = true;
    update();
    Response? response = await profileRepo.updateProfileInfo(firstName, lastName,email ,Get.find<AuthController>().pickedProfileFile);
    if(response!.statusCode == 200){
      Get.back();
      showCustomSnackBar('profile_info_updated_successfully'.tr, isError: false);
      isLoading = false;
      getProfileInfo();

    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
    return response;

  }

  Future<Response> profileOnlineOffline( bool value) async {
    isLoading = true;
    update();
    Response? response = await profileRepo.profileOnlineOffline();
    print('profileOnlineOffline ----> ${response?.body}');
    if(response!.statusCode == 200){
      if(isOnline == "0"){
        isOnline = "1";
      }else if(
      isOnline == "1"){
        isOnline = "0";
      }
    }else{
      Get.back();
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;

  }

  List<Brand> brandList = [];
  List<VehicleModels> modelList = [];
  int selectedBrandIndex = 0;
  int selectedBrandId = 0;
  int selectedModelId = 0;
  int selectedModelIndex = 0;
  List<int> brandIds = [];
  List<int> modelIds = [];

  Brand? selectedBrand;

  Future<Response> getVehicleBrandList(int offset) async {
    brandIds = [];
    brandIds.add(0);
    isLoading = true;
    Response? response = await profileRepo.getVehicleBrandList(offset);
    if(response!.statusCode == 200){
      brandList = [];
      brandList.add(Brand(id: 'abc', name: 'select_brand_model'.tr, vehicleModels: []));
      brandList.addAll(VehicleBrandModel.fromJson(response.body).data!);
      selectedBrand = brandList[0];
      if(brandList.isNotEmpty){
        setBrandIndex(brandList[0], true);
      }

    }else{
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;

  }

  void setBrandIndex(Brand brand, bool notify) {
    selectedBrand = brand;
    modelList = [];
    if(selectedBrand != null){
      modelList.add(VehicleModels(id: 'abc', name: 'select_vehicle_model'));
      modelList.addAll(selectedBrand!.vehicleModels!);
      if(modelList.isNotEmpty){
        selectedModel = modelList[0]
;      }
    }
    if(notify) {
      update();
    }
  }
  VehicleModels selectedModel = VehicleModels();
  void setModelIndex(VehicleModels model, bool notify) {
    selectedModel = model;
    if(notify) {
      update();
    }
  }


  List<String> fuelType = ["select_fuel_type", "petrol", "diesel", "cng", "lpg"];
  String selectedFuelType = 'select_fuel_type';
  void setFuelType(String type, bool notify){
    selectedFuelType = type;
    update();
  }



  List<Category> categoryList =[];
  Future<void> getCategoryList(int offset) async {
    Response? response = await profileRepo.getCategoryList(offset);
    if(response!.statusCode == 200 && response.body['data'] != null){
      categoryList = [];
      categoryList.add(Category(id: 'abc', name: 'select_vehicle_category'));
      categoryList.addAll(CategoryModel.fromJson(response.body).data!);
      if(categoryList.isNotEmpty){
        selectedCategory = categoryList[0];
      }
    }else{
      isLoading = false;
     ApiChecker.checkApi(response);
    }
    update();
  }


  Category selectedCategory = Category();
  void setCategoryIndex(Category category, bool notify) {
    selectedCategory = category;
    if(notify) {
      update();
    }
  }

  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

  void selectDate(String type, BuildContext context){
    showDatePicker(
      cancelText: 'cancel'.tr,
      confirmText: 'ok'.tr,
      helpText: 'select_date'.tr,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      if (type == 'start'){
        _startDate = date!;
      }else{
        _endDate = date!;
      }
      update();
    });
  }


  bool creating = false;
  Future<void> addNewVehicle(VehicleBody vehicleBody) async {
    creating = true;
    update();
    Response? response = await profileRepo.addNewVehicle(vehicleBody, documents);
    if(response!.statusCode == 200){
      creating = false;
      getProfileInfo().then((value) {
        if(value.statusCode == 200){
          Get.back();
          showCustomSnackBar('vehicle_added_successfully'.tr, isError: false);
        }
      });
    }else{
      creating = false;
      ApiChecker.checkApi(response);
    }
    creating = false;
    update();
  }
  void clearVehicleData(){
    listOfDocuments = [];
  }


  File? selectedFileForImport = File('');
  void setSelectedFileName(File fileName){
    selectedFileForImport = fileName;
    update();
  }


  List<MultipartDocument> documents = [];
  FilePickerResult? _otherFile;
  FilePickerResult? get otherFile => _otherFile;
  List<FilePickerResult> listOfDocuments = [];
  File? _file;
  PlatformFile? objFile;
  File? get file=> _file;

  void pickOtherFile(bool isRemove) async {
    if(isRemove){
      _otherFile=null;
      _file = null;
    }else{
      _otherFile = (await FilePicker.platform.pickFiles(withReadStream: true))!;
      if (_otherFile != null) {
        listOfDocuments.add(_otherFile!);
        objFile = _otherFile!.files.single;
        documents.add(MultipartDocument('upload_documents[]', objFile));
      }
    }
    update();
  }

  void removeFile(int index) async {
    listOfDocuments.removeAt(index);
    documents.removeAt(index);
    update();
  }

  Timer? _timer;
  final Location _location = Location();
  void startLocationRecord() {
    _location.enableBackgroundMode(enable: true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if(Get.find<RideController>().tripDetail != null && Get.find<RideController>().tripDetail!.currentStatus! =='ongoing' && Get.find<AuthController>().getUserToken() != ''){
        Get.find<RideController>().remainingDistance(Get.find<RideController>().tripDetail!.id!);
      }
      Get.find<LocationController>().getCurrentLocation(callZone: false);
    });
  }

  void stopLocationRecord() {
    _location.enableBackgroundMode(enable: false);
    _timer?.cancel();
  }

  void _checkPermission(Function callback) async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied
        || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
      Get.dialog(ConfirmationDialog(description: 'you_denied'.tr, onYesPressed: () async {
        Get.back();
        await Geolocator.requestPermission();
        _checkPermission(callback);
      }, icon: Images.logo,), barrierDismissible: false);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(ConfirmationDialog(description: 'you_denied_forever'.tr, onYesPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
        _checkPermission(callback);
      }, icon: Images.logo,), barrierDismissible: false);
    }else {
      callback();
    }
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }

}