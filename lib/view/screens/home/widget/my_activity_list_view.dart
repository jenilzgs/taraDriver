

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/activity_card_widget.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_title.dart';

class MyActivityListView extends StatelessWidget {
  const MyActivityListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTitle(title: 'my_activity'),
        GetBuilder<ProfileController>(
            builder: (profileController) {
              int activeSec = 0, offlineSec = 0, drivingSec = 0, idleSec = 0;
              if(profileController.profileInfo != null && profileController.profileInfo!.timeTrack != null){
                 activeSec = profileController.profileInfo!.timeTrack!.totalOnline!.floor();
                 drivingSec = profileController.profileInfo!.timeTrack!.totalDriving!.floor();
                 idleSec = profileController.profileInfo!.timeTrack!.totalIdle!.floor();
                 offlineSec = profileController.profileInfo!.timeTrack!.totalOffline!.floor();
              }
              return profileController.profileInfo != null?
              SizedBox(height: Get.find<LocalizationController>().isLtr? 80 : 85,
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  children:  [
                    MyActivityCard(title: 'active',icon: Images.activeHourIcon, index: 0,value: activeSec, color: Theme.of(Get.context!).colorScheme.tertiary),
                    MyActivityCard(title: 'on_driving',icon: Images.onDrivingHourIcon, index: 0,value: drivingSec, color: Theme.of(Get.context!).colorScheme.secondary,),
                    MyActivityCard(title: 'idle_time',icon: Images.idleHourIcon, index: 0,value: idleSec, color: Theme.of(Get.context!).colorScheme.tertiaryContainer),
                    MyActivityCard(title: 'offline',icon: Images.offlineHourIcon, index: 0,value: offlineSec, color :Theme.of(Get.context!).colorScheme.secondaryContainer),
                  ])):const SizedBox();
            }
        ),
      ],
    );
  }
}
