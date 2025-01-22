import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/model/zone_response.dart';
import 'package:ride_sharing_user_app/view/screens/location/repository/location_repo.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/confirmation_dialog.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;



class LocationController extends GetxController implements GetxService {
  final LocationRepo locationRepo;
  LocationController({required this.locationRepo});

  Position _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  String _address = '';
  bool _isLoading = false;
  GoogleMapController? _mapController;
  bool get isLoading => _isLoading;
  Position get position => _position;
  String get address => _address;
  GoogleMapController get mapController => _mapController!;
  LatLng _initialPosition = const LatLng(23.83721, 90.363715);
  LatLng get initialPosition => _initialPosition;


  StreamSubscription? _locationSubscription;
  Future<Position> getCurrentLocation({bool isAnimate = true, GoogleMapController? mapController, bool callZone = true}) async {
    bool isSuccess = await checkPermission(() {});
    if(isSuccess) {
      try {
        var location = await Geolocator.getCurrentPosition();
        Get.find<RiderMapController>().updateMarkerAndCircle(location);
        if (_locationSubscription != null) {
          _locationSubscription!.cancel();
        }
        Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        _position = newLocalData;
        _initialPosition = LatLng(_position.latitude, _position.longitude);
        if(callZone){
          getZone(_position.latitude.toString(), _position.longitude.toString(), false);
          getAddressFromGeocode(_initialPosition);
        }
        if(Get.find<AuthController>().isLoggedIn()){
          updateLastLocation(location.latitude.toString(), location.longitude.toString());
        }
        _locationSubscription = Geolocator.getPositionStream().listen((newLocalData) {
          if (mapController != null) {
            mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(newLocalData.latitude, newLocalData.longitude),
                tilt: 0,
                zoom: 16)));
            Get.find<RiderMapController>().updateMarkerAndCircle(newLocalData);
          }
        });
        if(isAnimate) {
          _mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _initialPosition, zoom: 16)));
        }
      }catch(e){
        if (kDebugMode) {
          print('');
        }
      }
    }
    return _position;
  }


  String zoneID = '';
  Future<ZoneResponseModel> getZone(String lat, String long, bool markerLoad) async {
    _isLoading = true;
    update();
    ZoneResponseModel responseModel;
    Response response = await locationRepo.getZone(lat, long);
    if(response.statusCode == 200) {
      zoneID = response.body['data']['id'];
      if(Get.find<AuthController>().isLoggedIn()){
        storeLastLocationApi(lat, long, zoneID);
      }
      responseModel = ZoneResponseModel(true, '',zoneID);
      if (kDebugMode) {
        print('Here is your zoneId==> $zoneID');
      }
      if(zoneID != ''){
        setUserZoneId(zoneID);
        Get.find<AuthController>().updateZoneId(zoneID);
      }
    }else {
      responseModel = ZoneResponseModel(false, response.statusText, '');
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future <void> setUserZoneId(String zoneId) async{
    locationRepo.saveUserZoneId(zoneId);
  }


  Future<void> updateLastLocation(String lat, String lng) async {
    final wsUrl = Uri.parse('${Get.find<ConfigController>().config!.webSocketUrl}:${Get.find<ConfigController>().config!.webSocketPort}${AppConstants.updateLastLocationUsingSocket}=${Get.find<ConfigController>().config!.webSocketKey}');
    var channel = WebSocketChannel.connect(wsUrl);
    Stream stream = channel.stream;
    stream.listen((event) {
      Map<String, dynamic> jsonData =
      {"user_id" : "${Get.find<ProfileController>().profileInfo!.id}",
        "type" : "driver",
        "latitude" : lat,
        "longitude" : lng,
        "zone_id" : zoneID};
      channel.sink.add(jsonEncode(jsonData));
      channel.sink.close(status.goingAway);
    },onError: (e){
      storeLastLocationApi(lat, lng, zoneID);
    }, onDone: (() {
    })
    );
    update();
  }


  bool lastLocationLoading = false;
  Future<void> storeLastLocationApi(String lat, String lng, String zoneID) async {
    lastLocationLoading = true;
    update();
    Response response = await locationRepo.storeLastLocationApi(lat,lng, zoneID);
    if(response.statusCode == 200) {
      lastLocationLoading = false;
    }
    update();

  }


  Future<String> getAddressFromGeocode(LatLng latLng) async {
    Response response = await locationRepo.getAddressFromGeocode(latLng);
    if(response.statusCode == 200) {
      _address = response.body['data']['results'][0]['formatted_address'].toString();
    }
    return _address;
  }



  Future<bool> checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    else if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
        || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
      Get.dialog(ConfirmationDialog(description: 'you_have_to_allow'.tr,
          fromOpenLocation: true,
          onYesPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
      }, icon: Images.logo), barrierDismissible: false);
    }else {
      onTap();
      return true;
    }
    return false;
  }


}
