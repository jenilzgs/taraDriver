
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/route_helper.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/view/access_location_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/final_fare_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/on_going_trip_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/parcel_list_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/pending_ride_request_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/remaining_distance_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/trip_details_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/repository/ride_repo.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/payment_received_screen.dart';



class RideController extends GetxController implements GetxService{
  final RideRepo rideRepo;
  RideController({required this.rideRepo});

  int _orderStatusSelectedIndex = 0;
  int get orderStatusSelectedIndex => _orderStatusSelectedIndex;
  bool isLoading = false;


  void setOrderStatusTypeIndex(int index){
    _orderStatusSelectedIndex = index;
    update();
  }





  Future<Response> bidding(String tripId, String amount) async {
    isLoading = true;
    update();
    Response response = await rideRepo.bidding(tripId, amount);
    if (response.statusCode == 200) {
      Get.back();
      isLoading = false;
     showCustomSnackBar('bid_submitted_successfully'.tr, isError: false);
     getPendingRideRequestList(1);
     getRideDetailBeforeAccept(tripId);
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  bool notSplashRoute= false;
  void updateRoute(bool showHideIcon, {bool notify = false}){
    notSplashRoute = showHideIcon;
    if(notify){
      update();
    }

  }


  String currentRideStatus = 'fresh';
  bool getResult = false;
  Future<Response> getCurrentRideStatus({bool fromRefresh = false, froDetails = false}) async {
    isLoading = true;
    if(froDetails){
      getResult = true;
      update();
    }

    Response response = await rideRepo.currentRideStatus();
    if (response.statusCode == 200 ) {
      getResult = false;
      if(response.body['data'] != null){
        tripDetail = TripDetailsModel.fromJson(response.body).data!;
        currentRideStatus = tripDetail!.currentStatus!;
        polyline = tripDetail!.encodedPolyline!;
        Get.find<RiderMapController>().getPolyline();
        if(Get.find<AuthController>().getZoneId() != '') {
          if (Get.find<RideController>().currentRideStatus == 'fresh') {
            Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
            Get.offNamed(RouteHelper.getHomeRoute());
          } else if (Get.find<RideController>().currentRideStatus == 'accepted') {
            Get.find<RiderMapController>().setRideCurrentState(RideState.accepted);
            Get.find<RideController>().remainingDistance(tripDetail!.id!);
            Get.find<RideController>().updateRoute(false, notify: true);
            Get.to(() => const MapScreen(fromScreen: 'splash'));
          }
          else if (Get.find<RideController>().currentRideStatus == 'ongoing') {
            Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
            Get.find<RideController>().remainingDistance(tripDetail!.id!);
            Get.find<RideController>().updateRoute(false, notify: true);
            Get.to(() => const MapScreen(fromScreen: 'splash'));
          }else if (Get.find<RideController>().currentRideStatus == 'completed' || Get.find<RideController>().currentRideStatus == 'cancelled') {
            Get.find<RideController>().getFinalFare(Get.find<RideController>().tripDetail!.id!);
            Get.offAll(() =>  const PaymentReceivedScreen());
          }
        }else{
          Get.to(()=> const AccessLocationScreen());
        }
      }
      isLoading = false;
    }else if(response.statusCode == 403){
      getResult = false;
      if(Get.find<AuthController>().getZoneId() != '') {
        if(!fromRefresh){
          Get.offNamed(RouteHelper.getHomeRoute());
        }
      }else{
        Get.to(()=> const AccessLocationScreen());
      }


    }else{
      getResult = false;
      isLoading = false;
      Get.offNamed(RouteHelper.getHomeRoute());
    }
    update();
    return response;
  }


  TripDetail? tripDetail;
  Future<Response> getRideDetails(String tripId) async {
    isLoading = true;
    if (kDebugMode) {
      print('details api call-====> $tripId');
    }
    Response response = await rideRepo.getRideDetails(tripId);
    if (response.statusCode == 200) {
      tripDetail = TripDetailsModel.fromJson(response.body).data!;
      polyline = tripDetail!.encodedPolyline!;
      isLoading = false;


    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> uploadScreenShots(String tripId, XFile file) async {
    Response response = await rideRepo.uploadScreenShots(tripId, file);
    if (response.statusCode == 200) {
    }
    update();
    return response;
  }


  String polyline = '';

  Future<Response> getRideDetailBeforeAccept(String tripId) async {
    isLoading = true;
    update();
    Response response = await rideRepo.getRideDetailBeforeAccept(tripId);
    if (response.statusCode == 200) {
      tripDetail = TripDetailsModel.fromJson(response.body).data!;
      isLoading = false;
      polyline = tripDetail!.encodedPolyline!;
      Get.find<RideController>().remainingDistance(tripId);
      Get.find<RiderMapController>().getPolyline();
      if (kDebugMode) {
        print('polyline is ====> $polyline');
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  List<TripDetail>? ongoingTrip;

  Future<Response> getLastTrip() async {
    Response response = await rideRepo.ongoingTripRequest();
    if (response.statusCode == 200) {
      ongoingTrip = [];
      if(response.body['data'] != null){
        ongoingTrip!.addAll(OngoingTripModel.fromJson(response.body).data!);
      }

    }else{
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  bool accepting = false;
  Future<Response> tripAcceptOrRejected(String tripId, String type, {bool fromList = true, int index = 0}) async {
    if(fromList){
      pendingRideRequestModel?.data?[index].isLoading = true;
      update();
    }
      accepting = true;
      update();
    Response response = await rideRepo.tripAcceptOrReject(tripId, type);
    if (response.statusCode == 200) {
      if(fromList){
        pendingRideRequestModel?.data?[index].isLoading = false;
      }
      accepting = false;
      Get.find<RiderMapController>().getPolyline();
      if(type == 'rejected'){
        await rideRepo.ignoreMessage(tripId);
        showCustomSnackBar('trip_is_rejected'.tr, isError: false);
      }else{
        showCustomSnackBar('trip_is_accepted'.tr, isError: false);
        await remainingDistance(tripId);
        getPendingRideRequestList(1);
      }

    }else{
      if(fromList){
        pendingRideRequestModel?.data?[index].isLoading = false;
      }
      accepting = false;
      ApiChecker.checkApi(response);
    }
    if(fromList){
      pendingRideRequestModel?.data?[index].isLoading = false;
    }
    accepting = false;
    update();
    return response;
  }


  String _verificationCode = '';
  String _otp = '';
  String get otp => _otp;
  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    if(_verificationCode.isNotEmpty){
      _otp = _verificationCode;
    }
    update();
  }

  void clearVerificationCode() {
    _verificationCode = '';
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Uint8List? imageFile;

  Future<Response> matchOtp(String? tripId, String? otp) async {
    isLoading = true;
    print("1234===${otp}===${tripId}");
    update();
    if (kDebugMode) {
      print('otp and id ===> ${tripId!}/$otp');
    }
    Response response = await rideRepo.matchOtp(tripId!, otp!);

    print("response===${response.body}");
    if (response.statusCode == 200) {
      clearVerificationCode();
      if(tripDetail!.type! == 'parcel' &&  tripDetail?.parcelInformation?.payer == 'sender'){
        Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
        getFinalFare(tripId).then((value) {
          if(value.statusCode == 200){
            Get.to(()=> const PaymentReceivedScreen(fromParcel: true,));
          }
        });
      }else{
        remainingDistance(tripDetail!.id!);
        getRideDetails(tripDetail!.id!);
        Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
      }
      showCustomSnackBar('otp_verified_successfully'.tr, isError: false);
      isLoading = false;
      imageFile = await Get.find<RiderMapController>().mapController!.takeSnapshot();
      if(imageFile!= null)
      {
        uploadScreenShots(tripDetail!.id!, XFile.fromData(imageFile!));
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  String myDriveMode = '';
  RemainingDistanceModel? matchedMode;
  List<RemainingDistanceModel>? remainingDistanceItem = [];
  Future<Response> remainingDistance(String tripId) async {
    myDriveMode = Get.find<ProfileController>().profileInfo!.vehicle!.category!.type!;
    isLoading = true;
    Response response = await rideRepo.remainDistance(tripId);
    if (response.statusCode == 200) {
      remainingDistanceItem = [];
      response.body.forEach((distance) {
        remainingDistanceItem!.add(RemainingDistanceModel.fromJson(distance));
      });
      if(remainingDistanceItem != null && remainingDistanceItem!.isNotEmpty){
        matchedMode =  remainingDistanceItem![0];
      }

      if(matchedMode != null && (matchedMode!.distance! * 1000) <= 100 && tripDetail != null && tripDetail!.currentStatus == 'pending' ){
        arrivalPickupPoint(tripId);
      }
      if(tripDetail != null && tripDetail!.currentStatus == 'ongoing' && !tripDetail!.isPaused! && matchedMode != null && (matchedMode!.distance! * 1000) <= Get.find<ConfigController>().config!.completionRadius! && matchedMode!.isPicked!){
        arrivalDestination(tripId, "destination");
        getRideDetails(tripId);
        AudioPlayer audio = AudioPlayer();
        audio.play(AssetSource('notification.wav'));

      }

      isLoading = false;
    }else{
      isLoading = false;
    }
    update();
    return response;
  }


  Future<Response> tripStatusUpdate(String status,String id, String message) async {
    isLoading = true;
    update();
    Response response = await rideRepo.tripStatusUpdate(status, id);

    if (response.statusCode == 200) {
      showCustomSnackBar(message.tr, isError: false);
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  PendingRideRequestModel? pendingRideRequestModel;

  Future<Response> getPendingRideRequestList(int offset) async {
    isLoading = true;
    Response response = await rideRepo.getPendingRideRequestList(offset);
    if (response.statusCode == 200) {
      pendingRideRequestModel?.data = [];
      pendingRideRequestModel?.totalSize = 0;
      pendingRideRequestModel?.offset = '1';
      if(response.body['data'] != null && response.body['data'] != ''){
        if(offset == 1 ){
          pendingRideRequestModel = PendingRideRequestModel.fromJson(response.body);
        }else{
          pendingRideRequestModel!.totalSize =  PendingRideRequestModel.fromJson(response.body).totalSize;
          pendingRideRequestModel!.offset =  PendingRideRequestModel.fromJson(response.body).offset;
          pendingRideRequestModel!.data!.addAll(PendingRideRequestModel.fromJson(response.body).data!);
        }
      }

      isLoading = false;
    }
    else{
      pendingRideRequestModel?.data = [];
      pendingRideRequestModel?.totalSize = 0;
      pendingRideRequestModel?.offset = '1';
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  FinalFare? finalFare;
  Future<Response> getFinalFare(String tripId) async {
    isLoading = true;
    update();
    Response response = await rideRepo.getFinalFare(tripId);
    if (response.statusCode == 200 ) {
      Get.find<RiderMapController>().initializeData();
      if(response.body['data'] != null){
        finalFare = FinalFareModel.fromJson(response.body).data!;

      }
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

  void selectDate(String type, BuildContext context){
    showDatePicker(
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



  Future<Response> arrivalPickupPoint(String tripId) async {
    isLoading = true;
    if (kDebugMode) {
      print('details api call-====> $tripId');
    }
    Response response = await rideRepo.arrivalPickupPoint(tripId);
    if (response.statusCode == 200) {
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> arrivalDestination(String tripId, String type) async {
    Response response = await rideRepo.arrivalDestination(tripId, type);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("===Arrived destination aria===");
      }
    }else{

      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> waitingForCustomer (String tripId, String waitingStatus) async {
    isLoading = true;
    Response response = await rideRepo.waitingForCustomer(tripId, waitingStatus);
    if (response.statusCode == 200) {
      getRideDetails(tripId);
      isLoading = false;
      showCustomSnackBar('trip_status_updated_successfully'.tr, isError: false);
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> focusOnBottomSheet(GlobalKey<ExpandableBottomSheetState> key) async {
    if(key.currentState?.expansionStatus == ExpansionStatus.expanded) {
      // ignore: invalid_use_of_protected_member
      key.currentState?.reassemble();
      await Future.delayed(const Duration(milliseconds: 200));
    }
    key.currentState?.expand();
  }

  ParcelListModel? parcelListModel;
  Future<Response> getOngoingParcelList() async {
    isLoading = true;
    Response? response = await rideRepo.getOnGoingParcelList(1);
    if(response.statusCode == 200 ){
      isLoading = false;
      if(response.body['data'] != null){
        parcelListModel = ParcelListModel.fromJson(response.body);
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }

  ParcelListModel? unpaidParcelListModel;
  Future<Response> getUnpaidParcelList() async {
    isLoading = true;
    Response? response = await rideRepo.getUnpaidParcelList(1);
    if(response.statusCode == 200 ){
      isLoading = false;
      if(response.body['data'] != null){
        unpaidParcelListModel = ParcelListModel.fromJson(response.body);
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }

}