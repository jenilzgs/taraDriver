
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/bank_info_edit_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';


class BankInfoView extends StatelessWidget {
  const BankInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'bank_info'.tr, regularAppbar: true,),
        body: GetBuilder<ProfileController>(

            builder: (profileController) {
              String name = 'John Doe';
              String bank = 'MIT Bank USA';
              String branch = 'California';
              String accountNo = 'MIT1234567890';
              return Column(
                children: [
                  GestureDetector(
                   onTap: ()=> Get.to(()=> const BankInfoEditScreen()),
                    child: Padding(
                      padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text('edit_info'.tr, style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
                            color: Get.isDarkMode? Theme.of(context).hintColor: Theme.of(context).primaryColor)),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(Images.editIcon, color: Get.isDarkMode? Theme.of(context).hintColor: Theme.of(context).primaryColor))
                      ],),
                    ),
                  ),
                  Padding(
                    padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Container(width: Get.width,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(width: Get.width/3,
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor.withOpacity(.05),
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100) )
                                ),

                              ),
                            ),
                          ),
                          Positioned(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(width: Get.width/4,
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor.withOpacity(.05),
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100) )
                                ),

                              ),
                            ),
                          ),
                          Column(children: [
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              CardItem(title: 'ac_holder',value: name),
                              Padding(
                                padding:  const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                child: SizedBox(width: 50, child: Image.asset(Images.bankInfo)),
                              )
                            ],),
                            Divider(color: Theme.of(context).cardColor.withOpacity(.5),thickness: 1.5),

                            CardItem(title: 'bank', value: bank),
                            CardItem(title: 'branch', value: branch),
                            CardItem(title: 'account_no' ,value: accountNo),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                          ],),
                        ],
                      ),),
                  ),
                ],
              );
            }
        ));
  }
}

class CardItem extends StatelessWidget {
  final String? title;
  final String? value;
  const CardItem({super.key, this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
      child: Row(
        children: [
          Text('${title!.tr} : ', style: textRegular.copyWith(color:Get.isDarkMode? Theme.of(context).hintColor: Theme.of(context).cardColor)),
          Text(value!, style: textMedium.copyWith(color:Get.isDarkMode? Theme.of(context).hintColor: Theme.of(context).cardColor)),

        ],
      ),
    );
  }
}
