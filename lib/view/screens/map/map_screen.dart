import 'dart:async';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/custom_icon_card.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/driver_header_info_widget.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/expendale_bottom_sheet.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/otp_verification_widget.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';

import 'package:ride_sharing_user_app/view/screens/ride/ride_request_list_screen.dart';


class MapScreen extends StatefulWidget {
  final String fromScreen;
  const MapScreen({super.key,  this.fromScreen = 'home'});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;


  @override
  void initState() {
    super.initState();
    // MatchOtp();

    Get.find<RideController>().updateRoute(false, notify: false);
    Get.find<RiderMapController>().setSheetHeight(270, false);
    Get.find<RideController>().getPendingRideRequestList(1);

    if(Get.find<RideController>().ongoingTrip != null
        && Get.find<RideController>().ongoingTrip!.isNotEmpty
        && (Get.find<RideController>().ongoingTrip![0].currentStatus == 'ongoing'
            || Get.find<RideController>().ongoingTrip![0].currentStatus == 'accepted'
            || (Get.find<RideController>().ongoingTrip![0].currentStatus =='completed'
                && Get.find<RideController>().ongoingTrip![0].paymentStatus == 'unpaid'))  ){
      Get.find<RideController>().getCurrentRideStatus(froDetails: true);
    }
    getCurrentLocation();

  }


  // MatchOtp() async {
  //   print("hello");
  //   await Get.find<RideController>().matchOtp("","1234");
  // }


  @override
  void dispose() {
    _mapController?.dispose();
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    super.dispose();
  }


  StreamSubscription? _locationSubscription;
  Marker? marker;
  GoogleMapController? _controller;


  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(Images.carTop);
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(Position? newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData!.latitude, newLocalData.longitude);
    setState(() {
      marker = Marker(
          markerId: const MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await Geolocator.getCurrentPosition();
      updateMarkerAndCircle(location, imageData);
      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }


      _locationSubscription = Geolocator.getPositionStream().listen((newLocalData) {
        if (_controller != null) {
          _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 16)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      body: GetBuilder<RiderMapController>(builder: (riderController) {
        return GetBuilder<RideController>(
          builder: (rideController) {
            return ExpandableBottomSheet(
              background: GetBuilder<RideController>(
                  builder: (rideController) {

                    return Stack(children: [
                      Padding(padding: EdgeInsets.only(bottom: riderController.sheetHeight - 20),
                        child: GoogleMap(mapType: MapType.terrain,
                          initialCameraPosition:  CameraPosition(
                              target:  (rideController.tripDetail != null && rideController.tripDetail!.pickupCoordinates != null)?
                              LatLng(rideController.tripDetail!.pickupCoordinates!.coordinates![1],
                                  rideController.tripDetail!.pickupCoordinates!.coordinates![0]):
                              Get.find<LocationController>().initialPosition,
                              zoom: 16),

                          onMapCreated: (GoogleMapController controller) async {
                            riderController.mapController = controller;
                            _mapController = controller;
                            riderController.getPolyline();
                            _mapController!.setMapStyle(
                              Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                            );
                          },
                          onCameraMove: (CameraPosition cameraPosition) {
                          },
                          onCameraIdle: () {

                          },
                          minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                          markers: Set<Marker>.of(riderController.markers),
                          polylines: Set<Polyline>.of(riderController.polylines.values),
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          padding: EdgeInsets.only(top: Get.height-400),
                          mapToolbarEnabled: true,
                        ),
                      ),

                      const DriverHeaderInfoWidget(),

                      Positioned(bottom: 300,right: 0,
                        child: Align(alignment: Alignment.bottomRight,
                          child: GetBuilder<LocationController>(
                              builder: (locationController) {
                                return CustomIconCard(title: '', index: 5,icon: Images.currentLocation,
                                    onTap: () async {
                                      await locationController.getCurrentLocation(mapController: _mapController);
                                      await _mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: Get.find<LocationController>().initialPosition, zoom: 16)));
                                    });
                              }
                          ),
                        ),
                      ),

                      Positioned(child: Align(alignment: Alignment.centerLeft,
                          child: GestureDetector(onTap: ()=> Get.off(()=> const DashboardScreen()),
                              onHorizontalDragEnd: (DragEndDetails details){
                                _onHorizontalDrag(details);
                                Get.off(()=> const DashboardScreen());},

                              child: SizedBox(width: Dimensions.iconSizeExtraLarge,
                                  child: Image.asset( Images.mapToHomeIcon, ))))),


                      // if(riderController.currentRideState == RideState.initial)
                      //   Positioned(top: 0,bottom: 200,left: 0,right: 0,
                      //       child: Align(alignment: Alignment.center,child: SizedBox(width: Get.width/2,
                      //         child: Image.asset(Images.directionIconMap),),)),


                      if(riderController.currentRideState == RideState.accepted)
                       Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
                        child:  const OtpVerificationWidget()),
                    ],
                    );
                  }
              ),


              persistentHeader: SizedBox(height: 50,
                child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Center(child: GetBuilder<RideController>(
                        builder: (rideController) {
                          return InkWell(onTap: () => Get.to(()=> const RideRequestScreen()),
                            child: Container(decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge)),
                                child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.min, children: [
                                    SizedBox(height: Dimensions.iconSizeSmall,
                                        child: Image.asset(Images.reqListIcon)),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                    Text('${rideController.pendingRideRequestModel?.totalSize??0} ${'more_request'.tr}',
                                        style: textRegular.copyWith(color: Colors.white))],)),));}))])),

              persistentContentHeight: riderController.sheetHeight,

              expandableContent: Builder(
                builder: (context) {
                  return const RiderBottomSheet();
                }
              ),

            );
          }
        );
      }
      ),
    );
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if(details.primaryVelocity == 0) return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity!.compareTo(0) == -1) {

    } else {

    }
  }

}