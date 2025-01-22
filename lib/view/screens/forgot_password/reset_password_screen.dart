import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/auth/widgets/text_field_title.dart';
import 'package:ride_sharing_user_app/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_text_field.dart';



class ResetPasswordScreen extends StatefulWidget {
  final bool fromChangePassword;
  final String phoneNumber;
  const ResetPasswordScreen({super.key,  this.fromChangePassword = false, required this.phoneNumber});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode oldPasswordFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      onPopInvoked: (val) async{
        if(widget.fromChangePassword){
          Get.back();
        }else{
          Get.off(()=> const ForgotPasswordScreen());
        }
        return;
      },

      child: Scaffold(
        appBar: CustomAppBar(title: widget.fromChangePassword? 'change_password'.tr : 'reset_password'.tr,
            showBackButton: true, regularAppbar: true,
          onBackPressed: (){
          if(widget.fromChangePassword){
            Get.back();
          }else{
            Get.off(()=> const ForgotPasswordScreen());
          }

          },),
        body: GetBuilder<AuthController>(builder: (authController){
          return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                if(widget.fromChangePassword)
                  TextFieldTitle(title: 'old_password'.tr,),

                if(widget.fromChangePassword)
                  CustomTextField(
                  hintText: 'password_hint'.tr,
                  inputType: TextInputType.text,
                  prefixIcon: Images.password,
                  isPassword: true,
                  controller: oldPasswordController,
                  focusNode: oldPasswordFocus,
                  nextFocus: passwordFocusNode,
                  inputAction: TextInputAction.next),


                TextFieldTitle(title: 'new_password'.tr,),
                CustomTextField(
                  hintText: 'password_hint'.tr,
                  inputType: TextInputType.text,
                  prefixIcon: Images.password,
                  isPassword: true,
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  nextFocus: confirmPasswordFocusNode,
                  inputAction: TextInputAction.next),


                TextFieldTitle(title: 'confirm_new_password'.tr,),
                CustomTextField(
                  hintText: '•••••••••••',
                  inputType: TextInputType.text,
                  prefixIcon: Images.password,
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocusNode,
                  inputAction: TextInputAction.done,
                  isPassword: true),


                const SizedBox(height: Dimensions.paddingSizeDefault * 3),

              authController.isLoading ? Center(child: SpinKitCircle(
                color: Theme.of(context).primaryColor, size: 40.0,
              )): CustomButton(
                  buttonText: widget.fromChangePassword ? 'update'.tr : 'save'.tr,
                  onPressed: (){
                    String oldPassword = oldPasswordController.text;
                    String password = passwordController.text;
                    String confirmPassword = confirmPasswordController.text;
                    if(password.isEmpty){
                      showCustomSnackBar('password_is_required'.tr);
                    }else if(password.length<6){
                      showCustomSnackBar('minimum_password_length_is_8'.tr);
                    }else if(confirmPassword.isEmpty){
                      showCustomSnackBar('confirm_password_is_required'.tr);
                    }else if(password != confirmPassword){
                      showCustomSnackBar('password_is_mismatch'.tr);
                    }else if(oldPassword.isEmpty && widget.fromChangePassword){
                      showCustomSnackBar('previous_password_is_required'.tr);
                    }
                    else{
                      if(widget.fromChangePassword){
                        authController.changePassword(oldPassword, password);
                      }else{
                        authController.resetPassword(widget.phoneNumber, password);
                      }
                    }
                  }, radius: 50),


              ],
            ),
          );
        }),
      ),
    );
  }
}
