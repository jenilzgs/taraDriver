import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'dart:math' as math;



class OtpVerificationWidget extends StatefulWidget {
  const OtpVerificationWidget({super.key});

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(
      builder: (rideController) {
        return GestureDetector(
          onTap: () async {
            rideController.matchOtp(rideController.tripDetail!.id!, "1234");
            },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('Start The Trip', style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
                ),
                // Text('ask_customer_to_check_the_phone'.tr, style: textRegular.copyWith()),
                // Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                //   child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                //
                //       Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,),
                //         child: PinCodeTextField(
                //           length: 4,
                //           appContext: context,
                //           obscureText: false,
                //           showCursor: true,
                //           keyboardType: TextInputType.number,
                //           animationType: AnimationType.fade,
                //           pinTheme: PinTheme(
                //             shape: PinCodeFieldShape.box,
                //             fieldHeight: 40,
                //             fieldWidth: 40,
                //             borderWidth: 1,
                //             borderRadius: BorderRadius.circular(10),
                //             selectedColor: Theme.of(context).primaryColor,
                //             selectedFillColor: Theme.of(context).primaryColor.withOpacity(.25),
                //             inactiveFillColor: Theme.of(context).disabledColor.withOpacity(.125),
                //             inactiveColor: Theme.of(context).disabledColor.withOpacity(.125),
                //             activeColor: Theme.of(context).primaryColor.withOpacity(.123),
                //               activeFillColor: Theme.of(context).primaryColor.withOpacity(.125)),
                //             animationDuration: const Duration(milliseconds: 300),
                //             backgroundColor: Colors.transparent,
                //             enableActiveFill: true,
                //             onChanged: rideController.updateVerificationCode,
                //             beforeTextPaste: (text) {
                //               return true;}))),
                //
                //
                //       InkWell(onTap: () async {
                //         if(rideController.verificationCode.length == 4){
                //           rideController.matchOtp(rideController.tripDetail!.id!, rideController.verificationCode);
                //         }else{
                //           showCustomSnackBar("pin_code_is_required".tr);}},
                //         child: rideController.isLoading?  const SizedBox(width: 30,height: 30,child: CircularProgressIndicator()):
                //
                //
                //
                //         Padding(padding: const EdgeInsets.fromLTRB( 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
                //           child: SizedBox(width: Dimensions.iconSizeLarge,child: Transform(
                //               alignment: Alignment.center,
                //               transform: Get.find<LocalizationController>().isLtr? Matrix4.rotationY(0):Matrix4.rotationY(math.pi),
                //               child: Image.asset(Images.arrowRight)))),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      }
    );
  }
}
