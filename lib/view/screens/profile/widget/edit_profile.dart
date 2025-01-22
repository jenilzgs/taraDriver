import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/auth/widgets/text_field_title.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/model/profile_model.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_text_field.dart';



class ProfileEditScreen extends StatefulWidget {
  final ProfileInfo profileInfo;
  const ProfileEditScreen({super.key, required this.profileInfo});

  @override
  ProfileEditScreenState createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<ProfileEditScreen>  with TickerProviderStateMixin {
  String countryDialCode = CountryCode.fromCountryCode("BD").dialCode!;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  @override
  void initState() {

    firstNameController.text = widget.profileInfo.firstName!;
    lastNameController.text = widget.profileInfo.lastName!;
    emailController.text = widget.profileInfo.email!;
    phoneController.text = widget.profileInfo.phone!;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'edit_profile'.tr,regularAppbar : true),
      body: GetBuilder<ProfileController>(builder: (profileController){
        return GetBuilder<AuthController>(
          builder: (authController) {
            return SingleChildScrollView(
              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

                    InkWell(onTap: ()=> authController.pickImage(false, true),
                      child: Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                        child: Container(height: 80, width: Get.width,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
                          child: Center(child: Stack(alignment: AlignmentDirectional.center,
                              clipBehavior: Clip.none, children: [
                                authController.pickedProfileFile==null?
                                ClipRRect(borderRadius: BorderRadius.circular(50),
                                  child: CustomImage(image: '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage}/${widget.profileInfo.profileImage??''}',
                                    height: 76, width: 76, placeholder: Images.personPlaceholder)) :
                                CircleAvatar(radius: 40, backgroundImage:FileImage(File(authController.pickedProfileFile!.path))),


                                Positioned(right: 5, bottom: -3,
                                    child: Container(decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                                      padding: const EdgeInsets.all(5),
                                      child: const Icon(Icons.camera_enhance_rounded, color: Colors.white,size: 13)))]))))),

                    Row(children: [Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          TextFieldTitle(title: 'first_name'.tr,),
                          CustomTextField(
                            hintText: 'first_name'.tr,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            prefixIcon: Images.person,
                            controller: firstNameController,
                            focusNode: firstNameFocus,
                            nextFocus: lastNameFocus,
                            inputAction: TextInputAction.next,
                          )],
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault,),


                      Expanded(child:  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          TextFieldTitle(title: 'last_name'.tr,),
                          CustomTextField(
                            hintText: 'last_name'.tr,
                            inputType: TextInputType.name,
                            prefixIcon: Images.person,
                            controller: lastNameController,
                            focusNode: lastNameFocus,
                            nextFocus: emailFocus,
                            inputAction: TextInputAction.next)]))]),


                    TextFieldTitle(title: 'phone'.tr,),
                    CustomTextField(
                      borderRadius: 50,
                      hintText: 'phone',
                      isEnabled: false,
                      showCountryCode: false,
                      inputType: TextInputType.number,
                      countryDialCode: countryDialCode,
                      controller: phoneController,
                      onCountryChanged: (CountryCode countryCode){
                        countryDialCode = countryCode.dialCode!;}),


                    TextFieldTitle(title: 'email'.tr,),
                    CustomTextField(
                      hintText: 'email'.tr,
                      inputType: TextInputType.emailAddress,
                      prefixIcon: Images.email,
                      controller: emailController,
                      focusNode: emailFocus,
                      inputAction: TextInputAction.done),


                    SizedBox(height: Dimensions.paddingSizeOverLarge),
                    Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Row(children: [
                        Expanded(child: CustomButton(
                            backgroundColor: Theme.of(context).colorScheme.error,
                            borderColor: Theme.of(context).colorScheme.error,
                            showBorder: true,
                            buttonText: 'cancel'.tr,
                            onPressed: (){
                              Get.back();
                            },
                            radius: 5,
                            borderWidth: .5,
                          ),
                        ),


                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        Expanded(
                          child: CustomButton(buttonText: 'save'.tr,
                            onPressed: (){
                              String email = emailController.text;
                              String fName = firstNameController.text;
                              String lName = lastNameController.text;
                              if(fName.isEmpty){
                                showCustomSnackBar('first_name_is_required'.tr);
                              }else if(lName.isEmpty){
                                showCustomSnackBar('last_name_is_required'.tr);
                              }
                              else if(fName == widget.profileInfo.firstName && lName == widget.profileInfo.lastName && email == widget.profileInfo.email){
                                showCustomSnackBar('please_change_something_to_update'.tr);
                              }else{
                                profileController.updateProfile(fName, lName, email);
                              }
                            }, radius: 5))])),
                    const SizedBox(height: Dimensions.paddingSizeDefault,),
                  ],
                ),
              ),
            );
          }
        );
      }),
    );
  }
}
