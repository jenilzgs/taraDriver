import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/customer_info_widget.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/route_widget.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/trip_details_model.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/payment_received_screen.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/review_this_customer_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/confirmation_dialog.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class ParcelRequestCardWidget extends StatelessWidget {
  final TripDetail rideRequest;
  final String? pickupTime;
  final int? index;
  const ParcelRequestCardWidget({super.key, required this.rideRequest,  this.pickupTime, this.index});

  @override
  Widget build(BuildContext context) {

    String firstRoute = '';
    String secondRoute = '';
    List<dynamic> extraRoute = [];
    if(rideRequest.intermediateAddresses != null && rideRequest.intermediateAddresses != '[[, ]]'){
      extraRoute = jsonDecode(rideRequest.intermediateAddresses!);
      if(extraRoute.isNotEmpty){
        firstRoute = extraRoute[0];
      }
      if(extraRoute.isNotEmpty && extraRoute.length>1){
        secondRoute = extraRoute[1];
      }
    }

    return
    GetBuilder<RideController>(
        builder: (rideController) {
          return InkWell(
            onTap: (){
              Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
              Get.find<RideController>().getRideDetails(rideRequest.id!).then((value){
                if(value.statusCode == 200){
                  Get.find<RideController>().updateRoute(false, notify: true);
                  Get.to(() => const MapScreen(fromScreen: 'splash'));
                }
              });

            },
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
              child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(color: Theme.of(Get.context!).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                    border: Border.all(color: Theme.of(Get.context!).primaryColor,width: .35),
                    boxShadow:[BoxShadow(color: Theme.of(Get.context!).primaryColor.withOpacity(.1), blurRadius: 1, spreadRadius: 1, offset: const Offset(0,0))]),
                child: Column(children: [


                  Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('trip_type'.tr, style: textRegular.copyWith(color: Theme.of(Get.context!).primaryColor),),

                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                            child: Text(rideRequest.type!.tr, style: textRegular.copyWith(color: Theme.of(Get.context!).cardColor)))])),

                  RouteWidget(fromCard: true, pickupAddress: rideRequest.pickupAddress!,
                      destinationAddress: rideRequest.destinationAddress!,
                      extraOne: firstRoute, extraTwo: secondRoute, entrance: rideRequest.entrance??''),


                  if(rideRequest.customer != null)
                    CustomerInfoWidget(fromTripDetails: false,
                        customer: rideRequest.customer!, fare: rideRequest.estimatedFare!,
                        customerRating: rideRequest.customerAvgRating!),

                  Get.find<RideController>().matchedMode != null?
                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Row(children: [
                        Icon(Icons.arrow_forward_outlined, color: Theme.of(Get.context!).primaryColor,size: Dimensions.iconSizeMedium),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        Text('${Get.find<RideController>().matchedMode!.duration!} ${'pickup_time'.tr}',
                            style: textRegular.copyWith(color: Theme.of(Get.context!).primaryColor)),
                      ])):const SizedBox(),

                  Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault),
                    child: SizedBox(width: 250,
                      child: Row(children: [

                        Expanded(child: CustomButton(buttonText: 'complete'.tr,
                            radius: Dimensions.paddingSizeSmall,
                            onPressed: () async{
                              if(rideRequest.paymentStatus == 'paid'){
                                Get.dialog(ConfirmationDialog(
                                  icon: Images.logo,
                                  description: 'are_you_sure'.tr,
                                  onYesPressed: () {
                                    if(Get.find<RideController>().matchedMode != null && (Get.find<RideController>().matchedMode!.distance! * 1000) <= Get.find<ConfigController>().config!.completionRadius!){
                                      Get.find<RideController>().tripStatusUpdate('completed', rideRequest.id!, "trip_completed_successfully").then((value) async {
                                        if(value.statusCode == 200){
                                          if(Get.find<ConfigController>().config!.reviewStatus!){
                                            Get.offAll(()=> ReviewThisCustomerScreen(tripId: rideRequest.id!));
                                          }else{
                                            Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                                            Get.off(()=> const DashboardScreen());
                                          }
                                        }
                                      });
                                    }else{
                                      Get.back();
                                      showCustomSnackBar("you_are_not_reached_destination".tr,);
                                    }
                                  },
                                ), barrierDismissible: false);
                              }else{
                                if(rideRequest.parcelInformation!.payer == 'sender'){
                                  rideController.tripStatusUpdate('completed', rideRequest.id!, "trip_completed_successfully").then((value) async {
                                    rideController.getFinalFare(rideRequest.id!).then((value) {
                                      if(value.statusCode == 200){
                                        if(Get.find<ConfigController>().config!.reviewStatus!){
                                          Get.offAll(()=>  ReviewThisCustomerScreen(tripId: rideController.tripDetail!.id!));
                                        }else{
                                          Get.offAll(()=> const DashboardScreen());
                                        }
                                      }
                                    });
                                  });
                                }
                                else{
                                  if(Get.find<RideController>().matchedMode != null && (Get.find<RideController>().matchedMode!.distance! * 1000) <= Get.find<ConfigController>().config!.completionRadius!){
                                    rideController.tripStatusUpdate('completed', rideRequest.id!, "trip_completed_successfully").then((value) async {
                                      if(value.statusCode == 200){
                                        Get.find<RideController>().getFinalFare(rideRequest.id!).then((value){if(value.statusCode == 200){
                                          Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                                          Get.to(()=> const PaymentReceivedScreen());
                                        }});
                                      }
                                    });
                                  }else{
                                    showCustomSnackBar("you_are_not_reached_destination".tr,);
                                  }

                                }
                              }

                            })),
                      ],),
                    ),
                  )
                ],),),
            ),
          );
        }
    );
  }
}

