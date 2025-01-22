import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/auth/additional_sign_up_screen.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/auth/widgets/text_field_title.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    Get.find<AuthController>().countryDialCode = CountryCode.fromCountryCode(Get.find<ConfigController>().config!.countryCode!).dialCode!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GetBuilder<AuthController>(builder: (authController){
        return Center(child: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.only(top : Dimensions.paddingSizeOver, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                 Column(crossAxisAlignment: CrossAxisAlignment.center,
                   children: [Image.asset(Images.logoWithName, height: 40,),
                     const SizedBox(height: Dimensions.paddingSizeSignUp),
                     Center(child: Image.asset(Images.signUpScreenLogo, width: 150))]),


                  Padding(padding: const EdgeInsets.fromLTRB(0,25,0,10),
                    child: Text('sign_up_as_driver'.tr,
                      style: textBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeExtraLarge))),
                  Text('sign_up_message'.tr,style: textRegular.copyWith(color: Theme.of(context).hintColor),maxLines: 2,),
                  const SizedBox(height: Dimensions.paddingSizeLarge,),

                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        TextFieldTitle(title: 'first_name'.tr,),
                        CustomTextField(
                          hintText: 'first_name'.tr,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          prefixIcon: Images.person,
                          controller: authController.fNameController,
                          focusNode: authController.fNameNode,
                          nextFocus: authController.lNameNode,
                          inputAction: TextInputAction.next)],),),

                    const SizedBox(width: Dimensions.paddingSizeDefault,),
                    Expanded(child:  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        TextFieldTitle(title: 'last_name'.tr,),
                        CustomTextField(
                          hintText: 'last_name'.tr,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          prefixIcon: Images.person,
                          controller: authController.lNameController,
                          focusNode: authController.lNameNode,
                          nextFocus: authController.phoneNode,
                          inputAction: TextInputAction.next)],),)]),

                  TextFieldTitle(title: 'phone'.tr,),
                  CustomTextField(
                    hintText: 'phone'.tr,
                    inputType: TextInputType.number,
                    countryDialCode: authController.countryDialCode,
                    controller: authController.phoneController,
                    focusNode: authController.phoneNode,
                    nextFocus: authController.passwordNode,
                    inputAction: TextInputAction.next,
                    onCountryChanged: (CountryCode countryCode){
                      authController.countryDialCode = countryCode.dialCode!;
                      authController.setCountryCode(countryCode.dialCode!);
                    },
                  ),

                  TextFieldTitle(title: 'password'.tr,),
                   CustomTextField(
                    hintText: 'password_hint'.tr,
                    inputType: TextInputType.text,
                    prefixIcon: Images.password,
                    isPassword: true,
                     controller: authController.passwordController,
                     focusNode: authController.passwordNode,
                     nextFocus: authController.confirmPasswordNode,
                     inputAction: TextInputAction.next),

                  TextFieldTitle(title: 'confirm_password'.tr,),
                   CustomTextField(
                    hintText: '•••••••••••',
                    inputType: TextInputType.text,
                    prefixIcon: Images.password,
                    controller: authController.confirmPasswordController,
                    focusNode: authController.confirmPasswordNode,
                     inputAction: TextInputAction.done,
                     isPassword: true,),

                  const SizedBox(height: Dimensions.paddingSizeDefault*3,),
                  CustomButton(buttonText: 'next'.tr,
                    onPressed: (){
                      String fName = authController.fNameController.text;
                      String lName = authController.lNameController.text;
                      String phone = authController.phoneController.text.trim();
                      String password = authController.passwordController.text;
                      String confirmPassword = authController.confirmPasswordController.text;

                      if(fName.isEmpty){
                        showCustomSnackBar('first_name_is_required'.tr);
                      }else if(lName.isEmpty){
                        showCustomSnackBar('last_name_is_required'.tr);
                      }else if(phone.isEmpty){
                        showCustomSnackBar('phone_is_required'.tr);
                      }else if(!GetUtils.isPhoneNumber(authController.countryDialCode + phone)){
                        showCustomSnackBar('phone_number_is_not_valid'.tr);
                      }else if(password.isEmpty){
                        showCustomSnackBar('password_is_required'.tr);
                      }else if(password.length<8){
                        showCustomSnackBar('minimum_password_length_is_8'.tr);
                      }else if(confirmPassword.isEmpty){
                        showCustomSnackBar('confirm_password_is_required'.tr);
                      }else if(password != confirmPassword){
                        showCustomSnackBar('password_is_mismatch'.tr);
                      }
                      else{
                        Get.to(()=> AdditionalSignUpScreen(countryCode: authController.countryDialCode));
                      }
                    }, radius: 50),


                  const SizedBox(height: Dimensions.paddingSizeDefault,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${'already_have_an_account'.tr} ',
                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge!.color)),

                      TextButton(onPressed: () =>  Get.back(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, minimumSize: const Size(50,30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Text('login'.tr, style: textRegular.copyWith(
                          decoration: TextDecoration.underline, color: Theme.of(context).primaryColor)))],),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
