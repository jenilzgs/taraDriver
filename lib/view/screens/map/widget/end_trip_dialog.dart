import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/route_calculation_widget.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/payment_received_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/confirmation_dialog.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class EndTripWidget extends StatelessWidget {
  const EndTripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(
      builder: (rideController) {
        return Column(children: [

          const RouteCalculationWidget(fromEnd: true),

          Center(child: SizedBox(width: Dimensions.iconSizeDoubleExtraLarge,child: Image.asset(Images.reachedFlag))),
           Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
             child: Text.rich(TextSpan(children: [
               TextSpan(text: 'end_this_trip_at'.tr,style: textMedium),
               const TextSpan(text: ' '),
               TextSpan(text: 'your_destination'.tr,style: textMedium.copyWith(color: Theme.of(context).primaryColor))]))),


          Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault),
            child: SizedBox(width: 250,
              child: Row(children: [
                Expanded(child: CustomButton(buttonText: 'continue'.tr,
                    showBorder: true,
                    transparent: true,
                    borderColor: Theme.of(context).primaryColor,
                    radius: Dimensions.paddingSizeSmall,
                    onPressed: (){
                      Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
                    })),

                const SizedBox(width: Dimensions.paddingSizeDefault),
                Expanded(child: CustomButton(buttonText: 'end'.tr,
                    radius: Dimensions.paddingSizeSmall,
                    onPressed: () async{
                      Get.dialog(GetBuilder<RideController>(
                        builder: (rideController) {
                          return ConfirmationDialog(
                            loading: rideController.isLoading,
                            icon: Images.location,
                            description: (rideController.tripDetail?.isReachedDestination ?? false)
                                ? 'are_you_sure_you_want_to_complete_this_trip'.tr
                                : 'are_you_sure_you_want_to_cancel_this_trip'.tr,
                            onYesPressed: () {
                              if(rideController.tripDetail!.isReachedDestination! && rideController.tripDetail!.type == "ride_request"){
                                rideController.tripStatusUpdate('completed', rideController.tripDetail!.id!, "trip_completed_successfully").then((value) async {
                                  if(value.statusCode == 200){
                                    if(rideController.tripDetail!.type == "ride_request"){
                                      rideController.getRideDetails(rideController.tripDetail!.id!);
                                      rideController.getFinalFare(rideController.tripDetail!.id!).then((value){
                                        if(value.statusCode == 200){
                                          Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                                          Get.off(()=> const PaymentReceivedScreen());
                                        }
                                      });
                                    }
                                  }});
                              }
                              else if(!rideController.tripDetail!.isReachedDestination! && rideController.tripDetail!.type == "ride_request"){
                                rideController.tripStatusUpdate('cancelled', rideController.tripDetail!.id!, "trip_cancelled_successfully").then((value) async {
                                  if(value.statusCode == 200){
                                    Get.offAll(()=> const DashboardScreen());
                                  }});
                              }
                              else{
                                if(Get.find<RideController>().matchedMode != null && (Get.find<RideController>().matchedMode!.distance! * 1000) <= Get.find<ConfigController>().config!.completionRadius!){
                                  rideController.tripStatusUpdate('completed', rideController.tripDetail!.id!, "trip_completed_successfully").then((value) async {
                                    Get.find<RiderMapController>().setRideCurrentState(RideState.initial);

                                    Get.find<RideController>().getOngoingParcelList().then((value) {
                                      if(rideController.tripDetail!.parcelInformation!.payer == "sender"){
                                        Get.offAll(()=> const DashboardScreen());
                                      }else{

                                        rideController.getFinalFare(rideController.tripDetail!.id!).then((value){
                                          if(value.statusCode == 200){
                                            Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                                            Get.off(()=> const PaymentReceivedScreen(fromParcel: true));}});}});


                                  });
                                }else{
                                  showCustomSnackBar("you_are_not_reached_destination".tr,);
                                }


                              }
                            },
                          );
                        }
                      ), barrierDismissible: false);
                    })),
              ],),
            ),
          ),
        ],);
      }
    );
  }
}
