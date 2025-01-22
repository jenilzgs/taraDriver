import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/profile/widget/loyalty_point_converted_successfully_dialog.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/controller/wallet_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';


class ConvertPointToWalletMoney extends StatefulWidget {
  const ConvertPointToWalletMoney({super.key});

  @override
  State<ConvertPointToWalletMoney> createState() => _ConvertPointToWalletMoneyState();
}

class _ConvertPointToWalletMoneyState extends State<ConvertPointToWalletMoney> {
  TextEditingController inputController = TextEditingController();
  FocusNode inputNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'convert_point'.tr,regularAppbar: true,),
      body: GetBuilder<WalletController>(
        builder: (walletController) {
          return Column(crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.15), blurRadius: 1, spreadRadius: 1, offset: const Offset(0,0))]
              ),
                child: Column(
                children: [
                  Text('convert_point_to_wallet_money'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor),),
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                    child: Text('${'conversion_rate_is'.tr} : ${Get.find<ConfigController>().config!.conversionRate!}', style: textMedium.copyWith(color: Theme.of(context).hintColor),),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: SizedBox(height: 50,child:
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: inputController,
                      focusNode: inputNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'enter_point'.tr,
                        hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.5)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:  BorderSide(width: 0.5,
                              color: Theme.of(context).hintColor.withOpacity(0.5)),
                        ),


                      ),

                    ),),
                  ),

                  walletController.isLoading?  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,),
                    ],
                  ):
                  CustomButton(buttonText: 'convert_point'.tr, onPressed: (){
                    String point = inputController.text.trim();
                    if(point.isEmpty){
                      showCustomSnackBar('please_input_point'.tr);
                    }else if(double.parse(point)< Get.find<ConfigController>().config!.conversionRate!){
                      showCustomSnackBar('${'minimum_conversion_point'.tr}: ${Get.find<ConfigController>().config!.conversionRate!}');
                    }else{
                      walletController.convertPoint(point).then((value) {
                        if(value.statusCode == 200){
                          showDialog(context: context, builder: (_)=> const LoyaltyPointConvertedSuccessfullyDialog());
                        }
                      });
                    }



                  },)
                ],
              ),),
            )
          ],);
        }
      ),
    );
  }
}
