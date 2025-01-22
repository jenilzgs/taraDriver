import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/auth/sign_in_screen.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/view/access_location_screen.dart';
import 'package:ride_sharing_user_app/view/screens/maintainance_mode/maintainance_screen.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  StreamSubscription<ConnectivityResult>? _onConnectivityChanged;

  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();

    bool firstTime = true;
    Connectivity connectivity = Connectivity();
    connectivity.checkConnectivity();
    _onConnectivityChanged = connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        if(!isNotConnected) ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(isNotConnected ? 'no_connection'.tr : 'connected'.tr, textAlign: TextAlign.center)));
        if(!isNotConnected) {
          _route();
        }
      }else {
        firstTime = false;
      }
    });

    Get.find<ConfigController>().initSharedData();
    _route();

  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged?.cancel();
    _animation.isDismissed;
    _animation.removeListener(() { });
    _controller.isDismissed;
    _controller.dispose(); // you
  }
  void _route() async {
    bool isSuccess = await Get.find<ConfigController>().getConfigData();
    if (isSuccess) {
    if(Get.find<ConfigController>().config!.maintenanceMode != null && Get.find<ConfigController>().config!.maintenanceMode!){
      Get.offAll(() => const MaintenanceScreen());
    }else{
      if(Get.find<AuthController>().getZoneId() == ''){
        Get.offAll(()=> const AccessLocationScreen());
      }else{
        Get.find<AuthController>().updateToken();
        Future.delayed(const Duration(milliseconds: 2500), () {
          if(Get.find<AuthController>().isLoggedIn()){
            Get.find<ProfileController>().getProfileInfo().then((value){
              if(value.statusCode ==200){
                Get.find<LocationController>().getCurrentLocation().then((value){
                  Get.offAll(()=> const DashboardScreen());
                });
              }
            });

          }else{
            Get.offAll(()=> const SignInScreen());
          }
        });
      }

    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RideController>(
        builder: (rideController) {
          return GetBuilder<ProfileController>(
            builder: (profileController) {
              return GetBuilder<LocationController>(
                builder: (locationController) {
                  return Stack(children: [
                      Container(decoration: BoxDecoration(color: Theme.of(context).primaryColorDark,),
                        alignment: Alignment.bottomCenter,
                        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children:  [


                          Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                              Container(transform: Matrix4.translationValues(0, 320-(320*double.tryParse(_animation.value.toString())!), 0),
                                child: Column(children: [
                                    Opacity(opacity: _animation.value,
                                      child: Padding(padding: EdgeInsets.only(left: 120-((120*double.tryParse(_animation.value.toString())!))),
                                        child: Image.asset(Images.splashLogo,width: 160))),
                                    const SizedBox(height: 50),
                                    Image.asset(Images.splashBackgroundOne, width: Get.width, height: Get.height/2, fit: BoxFit.cover,),])),


                              Container(transform: Matrix4.translationValues(0, 20, 0),
                                child: Padding(padding:EdgeInsets.symmetric(horizontal:(70*double.tryParse(_animation.value.toString())!)),
                                  child: Image.asset(Images.splashBackgroundTwo, width: Get.size.width)))]),
                        ]),
                      ),

                    if(profileController.isLoading || rideController.isLoading || locationController.lastLocationLoading)
                      Positioned(bottom: -50,left: 0,right: 0,
                          child: Align(alignment: Alignment.bottomCenter,
                          child: Center(child: Lottie.asset(Images.startRide)))),

                    ],

                  );
                }
              );
            }
          );
        }
      ),
    );
  }
}
