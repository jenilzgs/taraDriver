import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';

class ProfileLevelWidget extends StatelessWidget {
  const ProfileLevelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 100,
              Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
          child: Row(children:  [
            SizedBox(child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              child: CustomImage(
                width: 40,height: 40,
                image: '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage}/${profileController.profileInfo?.profileImage??""}',

              ),
            ),),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('${profileController.profileInfo?.firstName}  ${profileController.profileInfo?.lastName}', style: textBold.copyWith(color: Colors.white,
                    fontSize: Dimensions.fontSizeLarge),maxLines: 1,overflow: TextOverflow.ellipsis,),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Container(decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(.10),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Text('${'level'.tr} ${(profileController.profileInfo != null && profileController.profileInfo!.level != null)?profileController.profileInfo!.level!.sequence!: 0 }', style: textRegular.copyWith(color: Colors.white),),),)],),),


            GestureDetector(onTap: ()=> Get.find<ProfileController>().toggleDrawer(),
                child: const SizedBox(child: Icon(CupertinoIcons.clear, color: Colors.white),))


          ],),
        );
      }
    );
  }
}
