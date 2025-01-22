import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/widget/edit_profile.dart';
import 'package:ride_sharing_user_app/view/screens/profile/widget/profile_item.dart';
import 'package:ride_sharing_user_app/view/screens/profile/widget/profile_type_button_widget.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';


class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProfileController>(
        builder: (profileController) {
          return Stack(children: [
              Column(children: [

                  CustomAppBar(title: 'profile'.tr, showBackButton: true, onTap: () => Get.find<ProfileController>().toggleDrawer()),

                  const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
                  Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0),
                      child: SingleChildScrollView(
                        child: Column(children:  [
                          Container(
                              decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).hintColor.withOpacity(.25),width: .5),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                            child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              child:  CustomImage(
                              width: 80,height: 80,
                              image: profileController.profileTypeIndex == 0?
                              '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage}/${profileController.profileInfo?.profileImage!}':
                              profileController.profileInfo!.vehicle != null?'${Get.find<ConfigController>().config!.imageBaseUrl!.vehicleModel}/'
                                  '${profileController.profileInfo!.vehicle!.model!.image}' : ''))),



                          const SizedBox(height : Dimensions.paddingSizeDefault),
                          InkWell(highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: ()=> Get.to(()=>  ProfileEditScreen(profileInfo: profileController.profileInfo!)),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Expanded(
                                  child: Text('${profileController.profileInfo?.firstName!}  ${profileController.profileInfo?.lastName!}',
                                    maxLines: 1,overflow: TextOverflow.ellipsis,
                                    style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),
                                if(profileController.profileTypeIndex == 0)
                                SizedBox(width: Dimensions.iconSizeMedium, child: Image.asset(Images.editIcon)),
                                const SizedBox(width: Dimensions.paddingSizeSmall)])),


                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                              Text('${'your_ratting'.tr} : ${profileController.profileInfo!.avgRatting.toString()} '),
                              const Icon(Icons.star_rounded, color: Colors.orange,size: Dimensions.iconSizeSmall)],),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          profileController.profileTypeIndex == 0?
                          Column(children:  [

                             ProfileItem(title: 'my_level',value: profileController.profileInfo?.level?.name??'',isLevel: true,),
                             ProfileItem(title: 'contact',value: profileController.profileInfo!.phone!),
                             ProfileItem(title: 'mail_address',value: profileController.profileInfo!.email!),],):


                          profileController.profileInfo!.vehicle != null?
                          Column(children:  [
                            ProfileItem(title: 'vehicle', value: profileController.profileInfo!.vehicle!.category!.type!.tr),
                            ProfileItem(title: 'vehicle_brand', value: profileController.profileInfo!.vehicle!.brand!.name!),
                            ProfileItem(title: 'vehicle_model', value: profileController.profileInfo!.vehicle!.model!.name!),
                            ProfileItem(title: 'vin', value: profileController.profileInfo!.vehicle!.vinNumber!),
                            ProfileItem(title: 'number_plate', value: profileController.profileInfo!.vehicle!.licencePlateNumber!)]):const SizedBox()
                        ],),
                      ),
                    ),
                  )


                ],
              ),
              Positioned( top: Dimensions.topSpace,left: Dimensions.paddingSizeSmall,
                child: SizedBox(height: Get.find<LocalizationController>().isLtr? 45 : 50,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: profileController.profileType.length,
                      itemBuilder: (context, index){
                        return SizedBox(width: Get.width/2.1,
                            child: ProfileTypeButtonWidget(profileTypeName : profileController.profileType[index], index: index));
                      }),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}



