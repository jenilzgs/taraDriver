import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/forgot_password/verification_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'forget_password'.tr,showBackButton: true, regularAppbar: true,),
      body: GetBuilder<AuthController>(builder: (authController){
        return SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

                const SizedBox(height: Dimensions.orderStatusIconHeight),
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [


                    Center(child: Image.asset(Images.forgotPasswordLogo, width: 150,)),
                    const SizedBox(height: Dimensions.paddingSizeLarge,),
                  ],
                ),

                Row(children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Text('forgot_password'.tr,
                      style: textBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeExtraLarge,)),
                    Text('enter_your_verified_phone_number'.tr,style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                    const SizedBox(height: Dimensions.paddingSizeLarge,)])]),

              CustomTextField(
                hintText: 'phone'.tr,
                inputType: TextInputType.number,
                countryDialCode: authController.countryDialCode,
                controller: phoneController,
                onCountryChanged: (CountryCode countryCode){
                  authController.countryDialCode = countryCode.dialCode!;
                  authController.setCountryCode(countryCode.dialCode!);
                  },
              ),

              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),


                authController.isLoading?  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,),):
                CustomButton(buttonText: 'send_otp'.tr,
                  onPressed: (){
                    String phoneNumber = phoneController.text;
                    if(phoneNumber.isEmpty){
                      showCustomSnackBar('phone_is_required'.tr);
                    }else{
                      authController.sendOtp(countryCode: authController.countryDialCode, phone: phoneNumber).then((value){
                        if(value.statusCode == 200){
                          Get.to(()=> VerificationScreen(countryCode: authController.countryDialCode, number: phoneNumber, from: 'forget'));
                        }
                      });
                    }
                  }, radius: 50),
              ],
            ),
          ),
        );
      }),
    );
  }
}
