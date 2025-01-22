import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SubTotalHeaderTitle extends StatelessWidget {
  final String title;
  final double? width;
  final Color? color;
  final double? amount;
  const SubTotalHeaderTitle({super.key, required this.title, this.width, this.color, this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Container(width: width ?? Get.width,
        transform: Matrix4.translationValues(0, -30, 0),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
            border: Border.all(width: .5,
                color: Theme.of(context).primaryColor)

        ),
        child: Row(mainAxisAlignment:amount != null? MainAxisAlignment.spaceBetween :MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraLarge),
              child: Text(title,
                style: textBold.copyWith(color: color ?? Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),),
            ),
            if(amount != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraLarge),
              child: Text(PriceConverter.convertPrice(context, amount!),
                style: textBold.copyWith(color: color ?? Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),),
            ),
          ],
        ),
      ),
    );
  }
}
