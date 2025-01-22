import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/auth/widgets/text_field_title.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/model/categoty_model.dart';
import 'package:ride_sharing_user_app/view/screens/profile/model/vehicle_brand_model.dart';
import 'package:ride_sharing_user_app/view/screens/profile/widget/vehicle_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_date_picker.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_text_field.dart';

class VehicleAddScreen extends StatefulWidget {
  const VehicleAddScreen({super.key});

  @override
  State<VehicleAddScreen> createState() => _VehicleAddScreenState();
}

class _VehicleAddScreenState extends State<VehicleAddScreen> {
  TextEditingController licencePlateNumberController = TextEditingController();
  TextEditingController licenceExpiryDateController = TextEditingController();
  TextEditingController vinNumberController = TextEditingController();
  TextEditingController transmissionController = TextEditingController();

  FocusNode licencePlateFocus = FocusNode();
  FocusNode licenceExpiryFocus = FocusNode();
  FocusNode vinNumberFocus = FocusNode();
  FocusNode transmissionFocus = FocusNode();

  PlatformFile? fileNamed;
  File? file;
  int? fileSize;


  @override
  void initState() {
    Get.find<ProfileController>().getVehicleBrandList(1);
    Get.find<ProfileController>().clearVehicleData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'add_vehicle'.tr, regularAppbar: true,),
      body: GetBuilder<ProfileController>(
        builder: (profileController) {
          return SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
                  child: Text('vehicle_information'.tr,
                      style: textMedium.copyWith(color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeLarge))),
                Text('add_vehicle_details'.tr, style: textRegular.copyWith(color: Theme.of(context).hintColor)),


                TextFieldTitle(title: 'vehicle_brand'.tr),

                if(profileController.brandList.isNotEmpty)
                  Container(width: Get.width, padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(color: Theme.of(context).cardColor,
                        border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeOverLarge)),
                    child: DropdownButton(
                      items: profileController.brandList.map((item) {
                        return  DropdownMenuItem<Brand>(
                          value: item,
                          child:  Text(item.name!.tr),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        profileController.setBrandIndex(newVal!, true);
                      },
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: profileController.selectedBrand ?? Brand(id: 'abc', name: 'Select Brand Model'),
                    ),
                  ),

                  if(profileController.modelList.isNotEmpty)
                  TextFieldTitle(title: 'vehicle_model'.tr),

                if(profileController.modelList.isNotEmpty)
                    Container(width: Get.width, padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor,
                          border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeOverLarge)),
                      child: DropdownButton(items: profileController.modelList.map((item) {
                          return  DropdownMenuItem<VehicleModels>(
                            value: item,
                            child:  Text(item.name!.tr),
                          );}).toList(),
                        onChanged: (newVal) {
                          profileController.setModelIndex(newVal!, true);
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: profileController.selectedModel,
                      ),
                    ),


                TextFieldTitle(title: 'vehicle_category'.tr),
                if(profileController.categoryList.isNotEmpty)
                    Container(width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor,
                          border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeOverLarge)),
                      child: DropdownButton(
                        items: profileController.categoryList.map((item) {
                          return  DropdownMenuItem<Category>(
                            value: item,
                            child:  Text(item.name!.tr),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          profileController.setCategoryIndex(newVal!, true);
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: profileController.selectedCategory,
                      ),
                    ),


                TextFieldTitle(title: 'licence_plate_number'.tr,),
                CustomTextField(
                  hintText: 'EX: DB-3212',
                  capitalization: TextCapitalization.words,
                  inputType: TextInputType.name,
                  prefixIcon: Images.licenceCard,
                  controller: licencePlateNumberController,
                  focusNode: licencePlateFocus,
                  nextFocus: licenceExpiryFocus,
                  inputAction: TextInputAction.next),


                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  CustomDatePicker(
                    title: 'licence_expire_date'.tr,
                    text: profileController.startDate != null ?
                    profileController.dateFormat.format(profileController.startDate!).toString() : 'dd-mm-yyyy',
                    image: Images.calender,
                    requiredField: true,
                    selectDate: () => profileController.selectDate("start", context)),


                TextFieldTitle(title: 'vin_number'.tr,),
                CustomTextField(
                  hintText: 'EX: 1HGBH41JXMN109186',
                  capitalization: TextCapitalization.words,
                  inputType: TextInputType.name,
                  prefixIcon: Images.licenceCard,
                  controller: vinNumberController,
                  focusNode: vinNumberFocus,
                  nextFocus: transmissionFocus,
                  inputAction: TextInputAction.next),


                TextFieldTitle(title: 'transmission'.tr,),
                CustomTextField(
                  hintText: 'EX: AMT',
                  capitalization: TextCapitalization.words,
                  inputType: TextInputType.name,
                  prefixIcon: Images.licenceCard,
                  controller: transmissionController,
                  focusNode: transmissionFocus,
                  inputAction: TextInputAction.done),


                  TextFieldTitle(title: 'fuel_type'.tr,),
                  Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(color: Theme.of(context).cardColor,
                      border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge)),
                    child: DropdownButton<String>(
                      value: profileController.selectedFuelType,
                      items: profileController.fuelType.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.tr),
                        );
                      }).toList(),
                      onChanged: (value) {
                        profileController.setFuelType(value!, true);
                      },
                      isExpanded: true,
                      underline: const SizedBox())),


                  Padding(padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault, 0, 0),
                    child: DottedBorder(
                      dashPattern: const [4,5],
                      borderType: BorderType.RRect,
                      color: Theme.of(context).hintColor,
                      radius: const Radius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                        ),
                        child: InkWell(onTap: ()async{
                            profileController.pickOtherFile(false);
                          },
                          child: Builder(
                              builder: (context) {
                                return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    SizedBox(width: 50,child: Image.asset(Images.upload)),
                                    Text('upload_documents'.tr),
                                    profileController.selectedFileForImport !=null ?
                                    Text(fileNamed != null? fileNamed!.name:'',maxLines: 2,overflow: TextOverflow.ellipsis):
                                    Text('upload_file'.tr, style: textRegular.copyWith()),
                                  ],);
                              }
                          ),
                        ),
                      ),
                    ),
                  ),


                  if(profileController.listOfDocuments.isNotEmpty)
                    ListView.builder(
                      itemCount: profileController.listOfDocuments.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                        return InkWell(onTap: ()=> profileController.removeFile(index),
                          child: Padding(padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault, 0, 0),
                            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
                                color: Theme.of(context).cardColor,
                                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25),spreadRadius: 1, blurRadius: 1, offset: const Offset(0,1))]),
                              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                child: Row(children: [
                                  SizedBox(width: Dimensions.iconSizeMedium,child: Image.asset(Images.clip)),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                  Expanded(child: Text(profileController.listOfDocuments[index].files.first.name, maxLines: 1,overflow: TextOverflow.ellipsis)),
                                  const Icon(Icons.clear, color: Colors.red,size: 20,)
                                ]))),
                          ),
                        );
                        }),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge)
              ],),
            ),
          );
        }
      ),
      bottomNavigationBar: GetBuilder<ProfileController>(
        builder: (profileController) {
          return Container(height: 70,
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25), spreadRadius: 1, blurRadius: 1, offset: const Offset(1,1))]),
            child: profileController.creating?
                 Row(mainAxisAlignment: MainAxisAlignment.center,children: [SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)],) :
            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: CustomButton(buttonText: 'submit'.tr, onPressed: (){
                String brandId = profileController.selectedBrand!.id!;
                String modelId = profileController.selectedModel.id!;
                String categoryId = profileController.selectedCategory.id!;
                String licencePlateNumber = licencePlateNumberController.text.trim();
                String expireDate = profileController.dateFormat.format(profileController.startDate??DateTime.now()).toString();
                String vinNumber = vinNumberController.text.trim();
                String transmission = transmissionController.text.trim();
                String fuelType = profileController.selectedFuelType;
                if(profileController.selectedBrand!.id == 'abc'){
                  showCustomSnackBar('select_vehicle_brand'.tr);
                }else if(profileController.selectedModel.id == 'abc'){
                  showCustomSnackBar('select_vehicle_model'.tr);
                }else if(profileController.selectedCategory.id == 'abc'){
                  showCustomSnackBar('select_vehicle_category'.tr);
                }
                else if(licencePlateNumber.isEmpty){
                  showCustomSnackBar('licence_plate_number_is_required'.tr);
                }else if(expireDate.isEmpty){
                  showCustomSnackBar('expire_date_is_required'.tr);
                }else if(vinNumber.isEmpty){
                  showCustomSnackBar('vin_number_is_required'.tr);
                }else if(transmission.isEmpty){
                  showCustomSnackBar('transmission_is_required'.tr);
                }else if(fuelType == 'Select Fuel type'){
                  showCustomSnackBar('fuel_type_is_required'.tr);
                }else{
                  VehicleBody body = VehicleBody(
                    brandId: brandId,
                    modelId: modelId,
                    categoryId: categoryId,
                    licencePlateNumber: licencePlateNumber,
                    licenceExpireDate: expireDate,
                    vinNumber: vinNumber,
                    transmission: transmission,
                    fuelType: fuelType,
                    driverId: profileController.profileInfo!.id??"123456789",
                    ownership: 'driver');
                  profileController.addNewVehicle(body);
                }
              }),
            ));
        }
      ),
    );
  }
}
