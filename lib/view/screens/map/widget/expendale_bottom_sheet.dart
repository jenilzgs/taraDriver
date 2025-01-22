import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/leaderboard/leaderboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/calculating_sub_total_widget.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/custom_icon_card.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/customer_ride_request_card.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/end_trip_dialog.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/stay_online_widget.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/trip_details_widget.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/ride_request_list_screen.dart';


class RiderBottomSheet extends StatelessWidget {
  const RiderBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderMapController>(
        builder: (riderController) {
          return GetBuilder<RideController>(
              builder: (rideController) {
                return GetBuilder<ProfileController>(
                    builder: (profileController) {
                      return Column(children: [
                        GestureDetector(
                          onTap: (){
                            Get.find<RiderMapController>().setSheetHeight(270, true);
                          },
                          onPanDown: (val){
                            Get.find<RiderMapController>().setSheetHeight(270, true);
                          },
                          child: Container(
                            decoration: BoxDecoration(color: Theme.of(context).cardColor,
                              borderRadius : const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeDefault),
                                  topRight : Radius.circular(Dimensions.paddingSizeDefault)),
                              boxShadow: [BoxShadow(color: Theme.of(context).hintColor, blurRadius: 5, spreadRadius: 1, offset: const Offset(0,2))]),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                                child : Column(mainAxisSize: MainAxisSize.min, children: [
                                  Container(height: 5, width: 30,
                                      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(.25),
                                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall))),


                                  if(riderController.currentRideState == RideState.initial)
                                    const StayOnlineWidget(),


                                  if(riderController.currentRideState == RideState.pending)
                                    GetBuilder<RideController>(
                                      builder: (rideController) {
                                        return  CustomerRideRequestCardWidget(rideRequest: rideController.tripDetail!);}),

                                  if(riderController.currentRideState == RideState.accepted)
                                    const StayOnlineWidget(),

                                  if(riderController.currentRideState == RideState.ongoing)
                                     TripDetailsWidget(tripId: rideController.tripDetail!.id!),

                                  if(riderController.currentRideState == RideState.end)
                                    const EndTripWidget(),

                                  if(riderController.currentRideState == RideState.completed)
                                    const CalculatingSubTotalWidget(),


                                  if(riderController.currentRideState == RideState.initial)
                                    Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:  [
                                          CustomIconCard(title: 'refresh'.tr, index: 0,icon: Images.mIcon3, onTap: ()=> riderController.setRideCurrentState(RideState.initial)),
                                          CustomIconCard(title: 'leader_board'.tr, index: 1,icon: Images.mIcon2, onTap: () => Get.to(()=> const LeaderboardScreen())),
                                          CustomIconCard(title: 'trip_request'.tr, index: 2,icon: Images.mIcon1, onTap: () => Get.to(()=> const RideRequestScreen())),
                                        ])),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                ],
                                )
                            ),
                          ),
                        ),
                      ],
                      );
                    }
                );
              }
          );
        }
    );
  }
}