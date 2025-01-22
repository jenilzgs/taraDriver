import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/route_widget.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/controller/trip_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/sub_total_header.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/payment_item_info.dart';

class PaymentReceivedScreen extends StatelessWidget {
  final bool fromParcel;
  const PaymentReceivedScreen({super.key,  this.fromParcel = false});

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      onPopInvoked: (val) async {
        Get.offAll(()=> const DashboardScreen());
        return;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: GetBuilder<RideController>(
            builder: (finalFareController) {
              double finalPrice = 0;
              if(finalFareController.finalFare != null ){
                finalPrice = finalFareController.finalFare!.paidFare!;

              }

              String firstRoute = '';
              String secondRoute = '';
              List<dynamic> extraRoute = [];
              if(finalFareController.finalFare != null){
                if(finalFareController.finalFare!.intermediateAddresses != null && finalFareController.finalFare!.intermediateAddresses != '[[, ]]'){
                  extraRoute = jsonDecode(finalFareController.finalFare!.intermediateAddresses!);

                  if(extraRoute.isNotEmpty){
                    firstRoute = extraRoute[0];
                  }
                  if(extraRoute.isNotEmpty && extraRoute.length>1){
                    secondRoute = extraRoute[1];
                  }

                }
              }

              return (finalFareController.finalFare != null )?
              Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                CustomAppBar(title: 'sub_total'.tr, showBackButton: true, onBackPressed: ()=> Get.offAll(()=> const DashboardScreen())),
                SubTotalHeaderTitle(title: 'total_trip_cost'.tr,
                  color: Theme.of(context).textTheme.displayLarge!.color,
                  amount: finalPrice),

                if(!fromParcel)
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    SummeryItem(title: '${finalFareController.finalFare!.actualTime} ${'minute'.tr}',subTitle: 'time'.tr,),
                    SummeryItem(title: '${finalFareController.finalFare!.actualDistance} km',subTitle: 'distance'.tr,),

                  ],),
                ),


                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                  child: Text('trip_details'.tr)),
                 Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: RouteWidget(
                      pickupAddress: '${finalFareController.finalFare!.pickupAddress}',
                    destinationAddress: '${finalFareController.finalFare!.destinationAddress}',
                    extraOne: firstRoute,
                    extraTwo: secondRoute,
                    entrance: finalFareController.finalFare?.entrance??'',


                  )),

                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0),
                    decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                      Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                        child: Text('payment_details'.tr,style: textSemiBold.copyWith(color: Theme.of(context).primaryColor))),
                      PaymentItemInfo(icon: Images.farePrice,title: 'fare_price'.tr,amount: finalFareController.finalFare?.distanceWiseFare??0),
                      if(!fromParcel)
                        PaymentItemInfo(icon: Images.idleHourIcon,title: 'cancellation_price'.tr,amount: finalFareController.finalFare?.cancellationFee??0),
                      if(!fromParcel)
                        PaymentItemInfo(icon: Images.idleHourIcon,title: 'idle_price'.tr,amount: finalFareController.finalFare?.idleFee??0),
                      if(!fromParcel)
                        PaymentItemInfo(icon: Images.waitingPrice,title: 'delay_price'.tr,amount: finalFareController.finalFare?.delayFee??0),
                      PaymentItemInfo(icon: Images.coupon, title: 'coupon'.tr, amount: finalFareController.finalFare?.couponAmount??0),
                     PaymentItemInfo(icon: Images.farePrice,title: 'vat_tax'.tr,amount: finalFareController.finalFare?.vatTax??0),
                      PaymentItemInfo(title: 'sub_total'.tr,amount: finalFareController.finalFare?.paidFare??0, isSubTotal: true,),
                  ],),),
                )

              ],):const SizedBox();
            }
          ),
        ),
        bottomNavigationBar: GetBuilder<RideController>(
          builder: (finalFareController) {
            return GetBuilder<TripController>(
              builder: (tripController) {
                return Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,Dimensions.paddingSizeLarge),
                  height: 90,
                  child: tripController.isLoading?  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)):
                  CustomButton(buttonText: 'payment_received'.tr,
                  onPressed: ()=> tripController.paymentSubmit(finalFareController.finalFare!.id!, 'cash', fromSenderPayment: fromParcel),),
                );
              }
            );
          }
        ),
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
      Icon(Icons.check_circle,size: Dimensions.iconSizeSmall, color: Theme.of(context).primaryColor),
      Text(title, style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
      Text(subTitle, style: textRegular.copyWith(color: Theme.of(context).hintColor)),

    ],);
  }
}


