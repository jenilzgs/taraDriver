import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class NotReviewYet extends StatelessWidget {
  const NotReviewYet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(Images.patience),
        Text('your_customer_not_review_yet'.tr,textAlign: TextAlign.center,style: textRegular.copyWith(color: Theme.of(context).primaryColor),)
      ],
    );
  }
}
