import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/auth/sign_in_screen.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_loader.dart';


class AccessLocationScreen extends StatelessWidget {
  const AccessLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(canPop: false,
        onPopInvoked: (val) async {
          Get.find<BottomMenuController>().exitApp();
          return;
        },
        child: Center(
         child: GetBuilder<LocationController>(builder: (locationController) {
           return Column(children: [
             Expanded(child: SizedBox(width:Dimensions.webMaxWidth,
               child: Center(child: Center(child: SizedBox(width: 700,
                   child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Image.asset(Images.mapLocationIcon, height: 240),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text('find_customer_near_you'.tr, textAlign: TextAlign.center,
                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                            color:Get.isDarkMode ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor),),

                      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          child: Text('please_select_you_location_to_start_finding_available_customer_near_you'.tr,
                              textAlign: TextAlign.center, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  color:Get.isDarkMode ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor))),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          const BottomButton()])))))),
           ],
           );
         }
         ),
        ),
      )
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: MediaQuery.of(context).size.width-40 ,
        child: Column(children: [
          CustomButton(buttonText: 'use_current_location'.tr,
            fontSize: Dimensions.fontSizeSmall,
            onPressed: () async {
              Get.find<LocationController>().checkPermission(() async {
                Get.dialog(const CustomLoader(), barrierDismissible: false);
                 await Get.find<LocationController>().getCurrentLocation().then((value){
                   if(Get.find<AuthController>().isLoggedIn()){
                     Get.offAll(()=> const DashboardScreen());
                   }else{
                     Get.offAll(()=> const SignInScreen());
                   }
                 });
              });
            }, icon: Icons.my_location,
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ])));
  }
}

