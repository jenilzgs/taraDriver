import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/controller/wallet_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/convert_point_to_wallet_money.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/dynamic_withdraw_dialog.dart';

class WalletMoneyAmountWidget extends StatelessWidget {
  final bool isWithDraw;
  const WalletMoneyAmountWidget({super.key,  this.isWithDraw = false});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<WalletController>(
      builder: (walletController) {
        return GetBuilder<ProfileController>(
          builder: (profileController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0, Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault),
              child: InkWell(
                onTap: (){
                  if(walletController.walletTypeIndex == 1){
                    if(Get.find<ConfigController>().config!.conversionStatus!){
                      Get.to(()=>const ConvertPointToWalletMoney());
                    }else{
                      showCustomSnackBar('point_conversion_is_currently_unavailable'.tr);
                    }

                  }else if(walletController.walletTypeIndex == 0){
                     showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context, builder: (_) => const DynamicWithdrawRequest());
                  }
                },
                child: DottedBorder(
                  dashPattern: const [1,1],
                  borderType: BorderType.RRect,
                  color :  Theme.of(context).primaryColor,
                  radius: const Radius.circular(Dimensions.paddingSizeDefault),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isWithDraw?Theme.of(context).colorScheme.errorContainer : null,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          Text( isWithDraw? 'withdrawable'.tr : walletController.walletTypeIndex == 0?
                          'withdrawable_amount'.tr: 'point'.tr,
                            style: textBold.copyWith(color: Theme.of(context).primaryColor.withOpacity(.75), fontSize: Dimensions.fontSizeDefault),),
                          Row(
                            children: [
                              walletController.walletTypeIndex == 0?
                              Text(PriceConverter.convertPrice(context, profileController.profileInfo?.wallet?.receivableBalance??0), style: textBold.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).primaryColor)):

                              Text(profileController.profileInfo?.loyaltyPoint.toString()??'0', style: textBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).primaryColor)),

                              const SizedBox(width: Dimensions.paddingSizeDefault),
                              walletController.walletTypeIndex == 1 ? const SizedBox():
                               Icon(Icons.arrow_forward_ios,size: Dimensions.iconSizeMedium,
                                 color: Theme.of(context).primaryColor,)
                            ],
                          )
                        ],),
                      ),),
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
}
