import 'dart:async';
import 'dart:ui' as ui;
import 'dart:collection';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';


enum RideState{initial, pending, accepted, ongoing, acceptingRider, end, completed, fareCalculating}
class RiderMapController extends GetxController implements GetxService {




  final bool _showCancelTripButton = false;
  bool get showCancelTripButton => _showCancelTripButton;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _checkIsRideAccept = false;
  bool get checkIsRideAccept => _checkIsRideAccept;





  Set<Marker> markers = HashSet<Marker>();
  final List<MarkerData> _customMarkers = [];
  List<MarkerData> get customMarkers => _customMarkers;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  GoogleMapController? mapController;



  bool profileOnline = true;
  void toggleProfileStatus(){
    profileOnline = ! profileOnline;
    update();
  }



  bool clickedAssistant = false;
  void toggleAssistant(){
    clickedAssistant = !clickedAssistant;
    update();
  }


  double panelHeightOpen = 0;


  RideState currentRideState = RideState.initial;
  void setRideCurrentState(RideState newState, {bool notify = true}){
    currentRideState = newState;
    if(currentRideState == RideState.initial){
      initializeData();
    }

    if(notify){
      update();
    }

  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }


  final double _distance = 0;
  double get distance => _distance;
  late Position _position;
  Position get position => _position;
  LatLng _initialPosition = const LatLng(23.83721, 90.363715);
  LatLng get initialPosition => _initialPosition;


  final LatLng _customerPosition = const LatLng(12,12);//Get.find<AuthController>().currentLocation;
  late LatLng _destinationPosition = const LatLng(23.83721, 90.363715);
  LatLng get customerInitialPosition => _customerPosition;
  LatLng get destinationPosition => _destinationPosition;


  @override
  void onInit() {
    initializeData();
    super.onInit();
  }


  void initializeData() {
    Get.find<RideController>().polyline = '';
    markers = {};
    polylines = {};
    _isLoading = false;
  }


  void acceptedRideRequest(){
    _checkIsRideAccept = !_checkIsRideAccept;
  }

  void setMapController(GoogleMapController mapController) {
    mapController = mapController;
  }


  double sheetHeight = 0;
  void setSheetHeight(double height, bool notify){
    sheetHeight = height;
    if(notify){
      update();
    }

  }



  void getPolyline({bool updateLiveLocation = false}) async {
    List<LatLng> polylineCoordinates = [];
    if(Get.find<RideController>().polyline != ''){
      List<PointLatLng> result = polylinePoints.decodePolyline(Get.find<RideController>().polyline);
      if (kDebugMode) {
        print('here is latlng ==> ${result.length},${result[0].latitude}-/${result[result.length-1].latitude},/${result[result.length-1].longitude}');
      }
      if (result.isNotEmpty) {
        for (var point in result) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        _initialPosition = LatLng(result[0].latitude, result[0].longitude);
        _destinationPosition = LatLng(result[result.length-1].latitude, result[result.length-1].longitude);
      }
      _addPolyLine(polylineCoordinates);
      setFromToMarker(_initialPosition, _destinationPosition, updateLiveLocation: updateLiveLocation);
    }
    update();

  }


  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 5,
      color: Theme.of(Get.context!).primaryColor,
    );
    polylines[id] = polyline;
    update();
  }


  LocationData? currentLocation;

  void setFromToMarker(LatLng from, LatLng to, {bool updateLiveLocation = false}) async{
    markers = HashSet();
    Uint8List fromMarker = await convertAssetToUnit8List(Images.fromIcon, width: 125);
    Uint8List toMarker = await convertAssetToUnit8List(Images.targetLocationIcon, width: 75);

    markers.add(Marker(
      markerId: const MarkerId('from'),
      position: from,
      infoWindow:  InfoWindow(
        title:  Get.find<RideController>().tripDetail?.pickupAddress??'',
        snippet: 'pick_up_location'.tr,
      ),
      icon:  BitmapDescriptor.fromBytes(fromMarker),
    ));

    markers.add(Marker(
      markerId: const MarkerId('to'),
      position: to,
      infoWindow:  InfoWindow(
        title:  Get.find<RideController>().tripDetail!.destinationAddress??'',
        snippet: 'destination'.tr,
      ),
      icon:  BitmapDescriptor.fromBytes(toMarker),
    ));

    try {
      LatLngBounds? bounds;
      if(mapController != null) {
        if (from.latitude < to.latitude) {
          bounds = LatLngBounds(southwest: from, northeast: to);
        }else {
          bounds = LatLngBounds(southwest: to, northeast: from);
        }
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude)/2,
        (bounds.northeast.longitude + bounds.southwest.longitude)/2,
      );
      double bearing = Geolocator.bearingBetween(from.latitude, from.longitude, to.latitude, to.longitude);
      mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: bearing, target: centerBounds, zoom: 16,
      )));
      zoomToFit(mapController, bounds, centerBounds, bearing, padding: 0.5);
    }catch(e) {
      // debugPrint('jhkygutyv' + e.toString());
    }

    update();
  }

  void updateMarkerAndCircle(Position? newLocalData) async {
    markers.removeWhere((marker) => marker.markerId.value == "home");
    Uint8List car = await convertAssetToUnit8List(Get.find<ProfileController>().profileInfo?.vehicle?.category?.type == 'car'? Images.catIconTop : Images.bike, width: 75);
    LatLng latlng = LatLng(newLocalData!.latitude, newLocalData.longitude);
    markers.add( Marker(
          markerId: const MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(car)));
    update();
  }


  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds, double bearing, {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while(keepZoomingOut) {

      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if(fits(bounds!, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
          bearing: bearing,
        )));
        break;
      }
      else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }





}