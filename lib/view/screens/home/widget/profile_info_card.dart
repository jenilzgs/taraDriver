import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_loader.dart';

class ProfileStatusCard extends StatelessWidget {
  final ProfileController profileController;
  const ProfileStatusCard({super.key, required this.profileController});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
          border: Border.all(width: .5, color: Theme.of(context).primaryColor)),
        child:profileController.profileInfo != null && profileController.profileInfo!.firstName != null?


        Padding(padding: const EdgeInsets.all(Dimensions.paddingSize),
          child: Row(children:  [
            SizedBox(child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              child: CustomImage(width: 40,height: 40,
                image: '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage}/${profileController.profileInfo!.profileImage}'))),
            const SizedBox(width: Dimensions.paddingSizeDefault),


            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('${profileController.profileInfo!.firstName!}  ${profileController.profileInfo!.lastName!}',
                  maxLines: 1,overflow: TextOverflow.ellipsis,
                  style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                Container(decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.10),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                  child: Padding(padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Text('${'level'.tr} ${profileController.profileInfo!.level != null?profileController.profileInfo!.level!.sequence!: 0 }',
                      style: textRegular.copyWith(color: Theme.of(context).primaryColor))))])),


            FlutterSwitch(
              width: 95.0,
              height: 30.0,
              valueFontSize: 14.0,
              toggleSize: 28.0,
              value: profileController.isOnline == "1",
              borderRadius: 30.0,
              padding: 3,
              activeColor: Theme.of(context).primaryColor.withOpacity(.1),
              toggleBorder: Border.all(width: 5, color: Colors.white.withOpacity(.75)),
              activeText: 'online'.tr,
              inactiveText: 'offline'.tr,
              activeTextColor: Theme.of(context).primaryColor,
              showOnOff: true,
              activeTextFontWeight: FontWeight.w700,
              toggleColor: Colors.green,
              onToggle: (val) {
                Get.find<LocationController>().checkPermission(() async {
                  Get.dialog(const CustomLoader(), barrierDismissible: false);
                  await profileController.profileOnlineOffline(val).then((value){
                    if(value.statusCode == 200){
                      Get.back();
                    }
                  });
                });},)])):const SizedBox(),
      ),
    );
  }
}
