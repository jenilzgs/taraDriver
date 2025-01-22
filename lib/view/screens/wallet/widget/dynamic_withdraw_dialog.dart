import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/toaster.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/controller/wallet_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/model/withdraw_model.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_text_field.dart';


class DynamicWithdrawRequest extends StatefulWidget {
   const DynamicWithdrawRequest({super.key});

  @override
  DynamicWithdrawRequestState createState() => DynamicWithdrawRequestState();
}

class DynamicWithdrawRequestState extends State<DynamicWithdrawRequest> {

  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    if(Get.find<WalletController>().selectedMethod!=null){
      Get.find<WalletController>().setMethodTypeIndex(Get.find<WalletController>().selectedMethod!, notify: false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: GetBuilder<WalletController>(
        builder: (walletController) {
          return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
            child: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(topLeft:  Radius.circular(25), topRight: Radius.circular(25))),
              child: Container(width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        }, child: const Icon(Icons.keyboard_arrow_down)),


                    const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                    GetBuilder<WalletController>(
                        builder: ( withdraw) {
                          return Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault,
                              horizontal: Dimensions.paddingSizeSmall,),
                            child: Column(children: [


                              SizedBox(width: Get.width,
                                  child: DropdownButtonFormField2<Withdraw>(
                                    isExpanded: true,
                                    isDense: true,
                                    decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(vertical: 0),

                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                                    hint: Text(walletController.selectedMethod?.methodName??'select_withdraw_method'.tr, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                                    items: withdraw.methodList.map((item) => DropdownMenuItem<Withdraw>(
                                        value: item, child: Text(item.methodName??'', style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)))).toList(),
                                    onChanged: (value) {
                                      withdraw.setMethodTypeIndex(value!);
                                    },
                                    buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8),),
                                    iconStyleData: IconStyleData(
                                        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor), iconSize: 24),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),),),
                                    menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)),
                                  )
                              ),


                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              if(withdraw.methodList.isNotEmpty && withdraw.selectedMethod != null &&
                                  withdraw.selectedMethod!.methodFields != null &&
                                  withdraw.inputFieldControllerList.isNotEmpty &&
                                  withdraw.selectedMethod!.methodFields!.isNotEmpty)
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: withdraw.selectedMethod!.methodFields!.length,
                                  itemBuilder: (context, index){

                                    String type = withdraw.selectedMethod!.methodFields![index].inputType!;

                                    return Padding(padding:  const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                      child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          CustomTextField(
                                            prefixIcon: Images.info,
                                            inputType: (type == 'number' || type == "phone") ? TextInputType.number:
                                            TextInputType.text,
                                            controller: withdraw.inputFieldControllerList[index],
                                            hintText: withdraw.selectedMethod!.methodFields![index].placeholder,

                                          ),
                                        ],
                                      ),
                                    );
                                  })
                            ],),
                          );
                        }
                    ),


                    Container(width: MediaQuery.of(context).size.width,
                      padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [
                        Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: Text('withdraw_amount'.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),)),

                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text('\$ ', style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor)),
                            IntrinsicWidth(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: _balanceController,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'enter_amount'.tr,
                                  hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.5)),
                                  enabledBorder: UnderlineInputBorder(borderSide:  BorderSide(width: 0.5, color: Theme.of(context).hintColor.withOpacity(0.0)),),
                                  focusedBorder: UnderlineInputBorder(borderSide:  BorderSide(width: 0.5, color: Theme.of(context).hintColor.withOpacity(0.0)))),),),
                          ],
                        ),
                        Divider(color: Theme.of(context).primaryColor.withOpacity(.25)),

                        Padding(
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault),
                          child: SizedBox(height: 30,
                            child: ListView.builder(itemCount: walletController.suggestedAmount.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (amountContext, index){
                                  return InkWell(
                                    onTap: (){
                                      walletController.setSelectedIndex(index);
                                      _balanceController.text = walletController.suggestedAmount[index].toString();
                                    },
                                    child: Padding(padding:  const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall),
                                      child: Container(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                                            color: index == walletController.selectedIndex? Theme.of(context).primaryColor : Colors.transparent,
                                            border: Border.all(color:Get.isDarkMode? Theme.of(context).hintColor.withOpacity(.5): Theme.of(context).primaryColor.withOpacity(.75))),
                                        child: Center(child: Text(walletController.suggestedAmount[index].toString(),
                                          style: textRegular.copyWith(color:Get.isDarkMode? Theme.of(context).hintColor.withOpacity(.5):index == walletController.selectedIndex? Theme.of(context).cardColor : Theme.of(context).primaryColor),)),),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: Text('remark'.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),)),

                        Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: noteController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'remark_hint'.tr,
                              hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.5)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:  BorderSide(width: 0.5,
                                    color: Theme.of(context).primaryColor.withOpacity(0.25)))),
                          ),),
                      ],),),


                    const SizedBox(height: 35,),

                    !walletController.isLoading?
                    InkWell(onTap: () {

                        bool haveBlankTitle = false;
                        for(int i =0; i< walletController.inputFieldControllerList.length; i++){
                          if(walletController.inputFieldControllerList[i].text.isEmpty && walletController.isRequiredList[i] == 1){
                            haveBlankTitle = true;
                            break;
                          }
                        }
                        if(haveBlankTitle){
                          showCustomToaster('please_fill_all_the_field'.tr);
                        }else{
                          withdrawBalance();
                        }

                      },
                      child: Card(color: Theme.of(context).primaryColor,
                        child: SizedBox(height: 40,
                          child: Center(child: Text('withdraw'.tr, style: textRegular.copyWith(color: Colors.white))))),
                    ): Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );

  }

  void withdrawBalance() async {
    String balance = '0';
    String note = '';
    double bal = 0;
    balance = _balanceController.text.trim();
    note = noteController.text.trim();

    if(balance.isNotEmpty){
       bal = double.parse(balance);
    }
    if (balance.isEmpty) {
      showCustomToaster('enter_balance'.tr);

    }else if(bal > Get.find<ProfileController>().profileInfo!.wallet!.receivableBalance!) {
      showCustomToaster('insufficient_balance'.tr);
    }else if(bal < 1 ) {
      showCustomToaster('minimum_amount'.tr);
    }
    else {
      Get.find<WalletController>().updateBalance(balance, note);

    }
  }
}
