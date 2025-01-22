import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/vehicle_add_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class AddYourVehicle extends StatelessWidget {
  const AddYourVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        child: Text('vehicle_information'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor,
            fontSize: Dimensions.fontSizeLarge))),


      Text('no_vehicle_information_added_yet'.tr,
        style: textRegular.copyWith(color: Theme.of(context).hintColor),),

      Image.asset(Images.reward1),
      Padding(padding: EdgeInsets.all(Dimensions.paddingSizeOver),
        child: CustomButton(buttonText: 'add_vehicle_information'.tr,
            onPressed: ()=> Get.to(()=> const VehicleAddScreen())))
    ],);
  }
}
