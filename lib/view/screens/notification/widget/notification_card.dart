import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/notification/model/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final Notifications notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraLarge),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: Dimensions.iconSizeSmall, child: Image.asset(Images.activityIcon)),
          const SizedBox(width: Dimensions.paddingSizeSmall,),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(notification.title!, style: textMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),),
            Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
              child: Text(notification.description!, style: textRegular.copyWith(color: Theme.of(context).textTheme.displayLarge!.color))),
            Text(DateConverter.isoStringToDateTimeString(notification.createdAt!),
              style: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.85), fontSize: Dimensions.fontSizeSmall),),
          ],))
        ],)
      ],),
    );
  }
}
