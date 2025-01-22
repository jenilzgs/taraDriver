import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/trip_details_model.dart';
import 'package:ride_sharing_user_app/view/screens/trip/trip_details.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';

class TripCard extends StatelessWidget {
  final TripDetail tripModel;
  const TripCard({super.key, required this.tripModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Get.to(()=> TripDetails(tripId: tripModel.id!)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
        child: Container(decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.20),blurRadius: 1,spreadRadius: 1,offset: const Offset(1,1))]

        ),child: Column(children: [
          Padding(padding: const EdgeInsets.all(8.0),
            child:tripModel.screenshot != null?
                ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                    child: CustomImage(image: tripModel.screenshot, width: Get.width, height: Get.width/1.5,fit: BoxFit.fitWidth,)):
            Image.asset(Images.mapSample),
          ),
          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                ),
                height: Dimensions.orderStatusIconHeight,width: Dimensions.orderStatusIconHeight,
              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Image.asset(tripModel.vehicleCategory != null?
                tripModel.vehicleCategory!.type == "car"? Images.car : Images.bike:Images.car))),
              const SizedBox(width: Dimensions.paddingSizeDefault,),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text(tripModel.pickupAddress!,style: textMedium,),
                Text(tripModel.destinationAddress!,style: textRegular,),
                Text(DateConverter.isoStringToDateTimeString(tripModel.createdAt!),
                  style: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.85), fontSize: Dimensions.fontSizeSmall),),
                Text('${'total'.tr} ${PriceConverter.convertPrice(context, double.parse(tripModel.paidFare!))}',),
              ],)),

               SizedBox(width: Dimensions.iconSizeSmall, child: Icon(Icons.arrow_forward_ios_rounded,color: Theme.of(context).hintColor.withOpacity(.5)),),
            ],),
          )
        ],),),
      ),
    );
  }
}
