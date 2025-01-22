import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';

class StayOnlineWidget extends StatelessWidget {
  const StayOnlineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        bool isOnline = profileController.profileInfo!.details!.isOnline! == "1";
        return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: 50),
          child: Column(children: [

            SizedBox(width: isOnline?  Dimensions.iconSizeOnline: Dimensions.iconSizeOffline, height: 50,
                child: Image.asset(isOnline? Images.wifi : Images.offlineMode, color: Get.isDarkMode?Colors.white:Theme.of(context).primaryColor)),

            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall),
              child: Text(isOnline? 'stay_online'.tr : "you_are_in_offline_mode".tr,
                  style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge))),

            Text(isOnline? 'customer_are_surrounding_you'.tr:"stay_online_mode_to_get_more_ride".tr,
                style: textMedium.copyWith()),

          ]),
        );
      }
    );
  }
}


