import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/route_widget.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/payment_received_screen.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/sub_total_header.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_loader.dart';
import 'package:ride_sharing_user_app/view/widgets/payment_item_info.dart';

class TripDetails extends StatefulWidget {
  final String tripId;
  const TripDetails({super.key, required this.tripId});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {

  @override
  void initState() {
    Get.find<RideController>().getRideDetails(widget.tripId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RideController>(
        builder: (rideController) {


          String firstRoute = '';
          String secondRoute = '';
          double finalPrice = 0;
          Duration? tripDuration;
          if(rideController.tripDetail != null){
             finalPrice = double.parse(rideController.tripDetail!.paidFare!);
            if(rideController.tripDetail!.actualTime != null){
              tripDuration =  Duration(minutes: rideController.tripDetail!.actualTime!.ceil());
            }

            List<dynamic> extraRoute = [];
            if(rideController.tripDetail!.intermediateAddresses != null && rideController.tripDetail!.intermediateAddresses != '[[, ]]'){
              extraRoute = jsonDecode(rideController.tripDetail!.intermediateAddresses!);

              if(extraRoute.isNotEmpty){
                firstRoute = extraRoute[0];
              }
              if(extraRoute.isNotEmpty && extraRoute.length>1){
                secondRoute = extraRoute[1];
              }

            }
          }




          return rideController.tripDetail != null?
          SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              CustomAppBar(title: 'trip_details'.tr),
              SubTotalHeaderTitle(title: '${'your_trip_is'.tr} ${rideController.tripDetail!.currentStatus!.tr}',
                color: Theme.of(context).primaryColor,
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  if(rideController.tripDetail!.actualTime != null)
                  SummeryItem(title: '${tripDuration!.inHours}:${tripDuration.inMinutes % 60} hr',subTitle: 'time'.tr,),
                  SummeryItem(title: '${rideController.tripDetail!.actualDistance} km',subTitle: 'distance'.tr,),

                ],),
              ),


              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                child: Text('trip_details'.tr),),
               Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: RouteWidget(pickupAddress: rideController.tripDetail!.pickupAddress!,
                    destinationAddress: rideController.tripDetail!.destinationAddress!,
                  extraOne: firstRoute,extraTwo: secondRoute,entrance: rideController.tripDetail!.entrance,
                ),),

              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor, width: .5),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('payment_details'.tr,style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),),
                          Text(rideController.tripDetail!.paymentMethod!.replaceAll('_', ' ').capitalize!, style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),),
                        ],
                      ),
                    ),

                    PaymentItemInfo(icon: Images.farePrice,title: 'fare_price'.tr,amount: rideController.tripDetail!.distanceWiseFare??0),
                    PaymentItemInfo(icon: Images.idleHourIcon,title: 'idle_price'.tr,amount: rideController.tripDetail!.idleFee??0),
                    PaymentItemInfo(icon: Images.waitingPrice,title: 'delay_price'.tr,amount: rideController.tripDetail!.delayFee??0),
                    PaymentItemInfo(icon: Images.idleHourIcon,title: 'cancellation_price'.tr,amount: rideController.tripDetail!.cancellationFee??0),
                    PaymentItemInfo(icon: Images.coupon, title: 'coupon'.tr, amount: rideController.tripDetail!.couponAmount??0, discount: true,),
                    PaymentItemInfo(icon: Images.farePrice,title: 'tips'.tr,amount: rideController.tripDetail!.tips??0),
                    PaymentItemInfo(icon: Images.farePrice,title: 'vat_tax'.tr,amount: rideController.tripDetail!.vatTax??0),
                    PaymentItemInfo(title: 'sub_total'.tr,amount: finalPrice, isSubTotal: true,),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('payment_status'.tr,style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),),
                        Text(rideController.tripDetail!.paymentStatus!.replaceAll('_', ' ').capitalize!, style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),),

                      ],),
                    ),
                  ],),),
              ),

              if(rideController.tripDetail!.paymentStatus == 'unpaid' && rideController.tripDetail!.paidFare != '0')
              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: CustomButton(buttonText: 'request_for_payment'.tr, onPressed: (){
                  Get.find<RideController>().getFinalFare(rideController.tripDetail!.id!).then((value){if(value.statusCode == 200){
                    Get.to(()=> const PaymentReceivedScreen());
                  }});
                },),
              )

            ],),
          ): const CustomLoader();
        }
      ),
    );
  }
}

class SummeryItem extends StatelessWidget {
  final String title;
  final String subTitle;
  const SummeryItem({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(Icons.check_circle,size: Dimensions.iconSizeSmall, color: Colors.green),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
        child: Text(title, style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
      ),
      Text(subTitle, style: textRegular.copyWith(color: Theme.of(context).hintColor)),

    ],);
  }
}


