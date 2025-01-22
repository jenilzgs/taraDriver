import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/controller/wallet_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/model/transaction_model.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_divider.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
      child: GetBuilder<WalletController>(
        builder: (walletController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Expanded(child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: Dimensions.iconSizeLarge,
                          child: Image.asset(Images.myEarnIcon)),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(transaction.attribute??'', style: textSemiBold.copyWith(color: Theme.of(context).primaryColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                            child: Text(DateConverter.isoStringToDateTimeString(transaction.createdAt!),
                              style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                          ),
                          //Text('${'trip_id'.tr} : ${transaction.id}', style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),)
                        ],),
                      ),
                    ],
                  )),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSeven),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: transaction.debit!>0?
                          Theme.of(context).colorScheme.error.withOpacity(.15):
                      Theme.of(context).primaryColor.withOpacity(.08)
                    ),
                    child: Text(PriceConverter.convertPrice(context, transaction.debit!>0?transaction.debit!:transaction.credit!),
                      style: textBold.copyWith(
                          color: transaction.debit!>0?
                          Theme.of(context).colorScheme.error:
                          Theme.of(context).primaryColor)))
                ],),
              ),
              CustomDivider(height: .5,color: Theme.of(context).hintColor.withOpacity(.75),)
            ],
          );
        }
      ),
    );
  }
}
