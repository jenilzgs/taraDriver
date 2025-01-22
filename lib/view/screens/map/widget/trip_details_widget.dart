import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/chat/controller/chat_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/customer_info_widget.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/route_calculation_widget.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/route_widget.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/user_details_widget.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/payment_received_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_swipable_button/swipeable_button_view.dart';
import 'package:ride_sharing_user_app/view/widgets/payment_item_info.dart';


class TripDetailsWidget extends StatefulWidget {
  final String tripId;
  const TripDetailsWidget({super.key, required this.tripId});

  @override
  State<TripDetailsWidget> createState() => _TripDetailsWidgetState();
}

class _TripDetailsWidgetState extends State<TripDetailsWidget> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(
        builder: (riderController) {
          String firstRoute = '';
          String secondRoute = '';
          List<dynamic> extraRoute = [];
          if(riderController.tripDetail != null){
            if(riderController.tripDetail!.intermediateAddresses != null && riderController.tripDetail!.intermediateAddresses != '[[, ]]'){
              extraRoute = jsonDecode(riderController.tripDetail!.intermediateAddresses!);
              if(extraRoute.isNotEmpty){
                firstRoute = extraRoute[0];
              }
              if(extraRoute.isNotEmpty && extraRoute.length>1){
                secondRoute = extraRoute[1];
              }
            }
          }

          return riderController.tripDetail != null?
          GetBuilder<RiderMapController>(
            builder: (riderMapController) {
              return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:  [

                  const RouteCalculationWidget(),

                  Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Text('trip_details'.tr, style: textSemiBold.copyWith(color: Theme.of(context).primaryColor))),
                   Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: RouteWidget(
                        pickupAddress: riderController.tripDetail!.pickupAddress!,
                        destinationAddress: riderController.tripDetail!.destinationAddress!,
                      extraOne: firstRoute,
                      extraTwo: secondRoute,
                      entrance: riderController.tripDetail?.entrance??'')),


                  Center(child: Container(width: Get.width,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        border: Border.all(width: .75, color: Theme.of(context).primaryColor)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [


                        InkWell(onTap : () => Get.find<ChatController>().createChannel(riderController.tripDetail!.customer!.id!),
                          child: Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                            child: SizedBox(width: Dimensions.iconSizeLarge,child: Image.asset(Images.customerMessage)))),

                        Container(width: 1,height: 25,color: Theme.of(context).primaryColor),
                        InkWell(onTap: ()=> Get.find<ConfigController>().sendMailOrCall("tel:${riderController.tripDetail!.customer!.phone}", false),
                          child: Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                            child: SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(Images.customerCall))))]))),



                  Padding(padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault),
                    child: Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0),
                      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: .25),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                        PaymentItemInfo(icon: Images.farePrice, title: 'fare_price'.tr,amount: double.parse(riderController.tripDetail!.estimatedFare!),
                            isFromTripDetails: true),
                        PaymentItemInfo(icon: Images.paymentTypeIcon, title: 'payment'.tr,amount: 234, paymentType: riderController.tripDetail!.paymentMethod!.tr),]))),


                  if(riderController.tripDetail!.note != null)
                  Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    child: Text('note'.tr, style: textRegular.copyWith(color: Theme.of(context).primaryColor))),

                  if(riderController.tripDetail!.note != null)
                  Text(riderController.tripDetail!.note!, style: textRegular.copyWith(color: Theme.of(context).hintColor),),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  if(riderController.tripDetail!.type == 'ride_request')
                   CustomerInfoWidget(fromTripDetails: true, customer: riderController.tripDetail!.customer,
                       customerRating: riderController.tripDetail!.customerAvgRating),

                  if(riderController.tripDetail != null && riderController.tripDetail!.type == 'parcel' && riderController.tripDetail!.parcelUserInfo != null)
                    Container(width: Get.width,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.fontSizeExtraSmall),
                        color: Theme.of(context).primaryColor),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${'who_will_pay'.tr}?', style: textRegular.copyWith(color: Colors.white),),
                            Text(riderController.tripDetail!.parcelInformation!.payer!.tr, style: textMedium.copyWith(color: Colors.white))])),


                  if(riderController.tripDetail != null && riderController.tripDetail!.type == 'parcel' && riderController.tripDetail!.parcelUserInfo != null)
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: riderController.tripDetail!.parcelUserInfo!.length,
                      itemBuilder: (context, index){
                      return UserDetailsWidget(name: riderController.tripDetail?.parcelUserInfo![index].name??'',
                          contactNumber: riderController.tripDetail?.parcelUserInfo![index].contactNumber??'',
                          type: riderController.tripDetail?.parcelUserInfo![index].userType??'');}),
                  (riderController.tripDetail!.isPaused!)? const SizedBox():

                  (!riderController.tripDetail!.isPaused! && riderController.tripDetail!.type == "ride_request")?
                  Center(child: SwipeableButtonView(
                      buttonText: (riderController.tripDetail!.isReachedDestination!)? "complete".tr : 'cancel'.tr,
                      buttonWidget: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                      activeColor: Theme.of(context).primaryColor,
                      isFinished: isFinished,
                      onWaitingProcess: () {
                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            isFinished = true;
                          });
                        });
                      },
                      onFinish: () async {
                        Get.find<RideController>().remainingDistance(riderController.tripDetail!.id!);
                        Get.find<RiderMapController>().setRideCurrentState(RideState.end);
                        setState(() {
                          isFinished = false;
                        });
                      },
                    ),
                  ):

                  Center(child: SwipeableButtonView(
                      buttonText: 'complete'.tr,
                      buttonWidget: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                      activeColor: Theme.of(context).primaryColor,
                      isFinished: isFinished,
                      onWaitingProcess: () {
                        setState(() {
                          isFinished = true;
                        });
                      },
                      onFinish: () async {
                        if(riderController.tripDetail!.parcelInformation!.payer == 'sender' && riderController.tripDetail!.paymentStatus == 'unpaid'){
                          riderController.getFinalFare(riderController.tripDetail!.id!).then((value) {
                            if(value.statusCode == 200){
                              Get.to(()=> const PaymentReceivedScreen(fromParcel: true,));
                            }
                          });
                        }

                        else{
                          Get.find<RideController>().remainingDistance(riderController.tripDetail!.id!);
                          Get.find<RiderMapController>().setRideCurrentState(RideState.end);
                        }
                        setState(() {
                          isFinished = false;
                        });
                      },
                    ),
                  )
                ],),
              );
            }
          ): const SizedBox();
        }
    );
  }
}
