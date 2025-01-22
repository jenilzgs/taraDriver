import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/add_vehicle_design.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/custom_menu/custom_menu_button.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/custom_menu/custom_menu_widget.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/last_trip_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/my_activity_list_view.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/ongoing_parcel_list_view.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/ongoing_ride_card.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/profile_info_card.dart';
import 'package:ride_sharing_user_app/view/screens/home/widget/vehicle_pending.dart';
import 'package:ride_sharing_user_app/view/screens/map/map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/widget/profile_menu_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_delegate.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_drawer.dart';


class HomeMenu extends GetView<ProfileController> {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: const ProfileMenuScreen(),
        mainScreen: const HomeScreen(),
        borderRadius: 24.0,
        isRtl: !Get.find<LocalizationController>().isLtr,
        angle: -5.0,
        menuBackgroundColor: Theme.of(context).primaryColor,
        slideWidth: MediaQuery.of(context).size.width * 0.85,
        mainScreenScale: .4,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool clickedMenu = false;
  @override
  void initState() {
    Get.find<ProfileController>().getCategoryList(1);
    Get.find<ProfileController>().getDailyLog();
    Get.find<RideController>().getOngoingParcelList();
    Get.find<RideController>().getLastTrip();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: () async{
        Get.find<ProfileController>().getProfileInfo();
      },
      child: Scaffold(
        body: Stack(children: [
            CustomScrollView(slivers: [

              SliverPersistentHeader(delegate: SliverDelegate(child: Column(children: [
                CustomAppBar(title: 'dashboard'.tr, showBackButton: false, onTap: (){
                  Get.find<ProfileController>().toggleDrawer();})]), height: 120), pinned: true,),


              SliverToBoxAdapter(child: GetBuilder<ProfileController>(
                  builder: (profileController) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children:  [
                      const SizedBox(height: 60.0),


                      if(profileController.profileInfo?.vehicle != null && profileController.profileInfo?.vehicleStatus != 0  && profileController.profileInfo?.vehicleStatus != 1)
                        GetBuilder<RideController>(
                          builder: (rideController) {
                            return  rideController.getResult? const LastTripShimmer(): const OngoingRideCard();}),


                      if(profileController.profileInfo?.vehicle == null && profileController.profileInfo?.vehicleStatus == 0)
                        const AddYourVehicle(),

                      if(profileController.profileInfo?.vehicle != null && profileController.profileInfo?.vehicleStatus == 1)
                        VehiclePendingWidget(icon: Images.reward1,
                            description: 'create_account_approve_description_vehicle'.tr,
                            title: 'registration_not_approve_yet_vehicle'.tr),


                      if(Get.find<ProfileController>().profileInfo?.vehicle != null)
                        const MyActivityListView(),
                      const SizedBox(height: 100,),
                    ],
                    );
                  }),
                )
              ],
            ),

            Positioned(top: 90,left: 0,right: 0,
              child: GetBuilder<ProfileController>(builder: (profileController) {
                return ProfileStatusCard(profileController: profileController,);})),

          Positioned(child: Align(alignment: Alignment.centerRight,
              child: GestureDetector(onTap: (){
                Get.find<RideController>().updateRoute(false, notify: true);
                Get.to(()=> const MapScreen());
                },
                  onHorizontalDragEnd: (DragEndDetails details){
                    _onHorizontalDrag(details);
                    Get.find<RideController>().updateRoute(false, notify: true);
                    Get.to(()=> const MapScreen());
                  },

                  child: Stack(children: [
                    SizedBox(width: Dimensions.iconSizeExtraLarge,
                        child: Image.asset(Images.homeToMapIcon, color: Theme.of(context).cardColor)),
                    Positioned(top: 0, bottom: 0, left: 5, right: 5, child: SizedBox(width: 15,child: Image.asset(Images.map)))])))),
          ],
        ),

        floatingActionButton: GetBuilder<RideController>(
          builder: (rideController) {
            int ridingCount = (rideController.ongoingTrip == null || rideController.ongoingTrip!.isEmpty)? 0 : ( rideController.ongoingTrip![0].currentStatus == 'ongoing' || rideController.ongoingTrip![0].currentStatus == 'accepted' || (rideController.ongoingTrip![0].currentStatus =='completed' && rideController.ongoingTrip![0].paymentStatus == 'unpaid') && rideController.ongoingTrip![0].type != 'parcel')? 1:0;
            int parcelCount = rideController.parcelListModel?.totalSize??0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: CustomMenuButton(
                openForegroundColor: Colors.white,
                closedBackgroundColor: Theme.of(context).primaryColor,
                openBackgroundColor: Theme.of(context).primaryColorDark,
                labelsBackgroundColor: Theme.of(context).cardColor,
                speedDialChildren: <CustomMenuWidget>[
                  CustomMenuWidget(
                    child: const Icon(Icons.directions_run),
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    label: 'ongoing_ride'.tr,
                    onPressed: () {
                      if(rideController.ongoingTrip![0].currentStatus == 'ongoing' || rideController.ongoingTrip![0].currentStatus == 'accepted' || (rideController.ongoingTrip![0].currentStatus =='completed' && rideController.ongoingTrip![0].paymentStatus == 'unpaid') || (rideController.ongoingTrip![0].paidFare != "0" && rideController.ongoingTrip![0].paymentStatus == 'unpaid')  ){
                        Get.find<RideController>().getCurrentRideStatus(froDetails: true);
                      }else{
                        showCustomSnackBar('no_trip_available'.tr);
                      }
                      },
                    closeSpeedDialOnPressed: false,
                  ),
                  CustomMenuWidget(
                    child: Text('${rideController.parcelListModel?.totalSize}'),
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    label: 'parcel_delivery'.tr,
                    onPressed: () {
                      if(rideController.parcelListModel != null && rideController.parcelListModel!.data != null && rideController.parcelListModel!.data!.isNotEmpty){
                        Get.to(()=>  OngoingParcelListView(title: 'ongoing_parcel_list', parcelListModel: rideController.parcelListModel!));

                      }else{
                        showCustomSnackBar('no_parcel_available'.tr);
                      }
                    },
                    closeSpeedDialOnPressed: false,
                  ),

                ],
                child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Badge(label: Text('${ridingCount + parcelCount}'),child: Image.asset(Images.ongoing)),
                )),);
          }
        )
      ),
    );
  }
  void _onHorizontalDrag(DragEndDetails details) {
    if(details.primaryVelocity == 0) return;

    if (details.primaryVelocity!.compareTo(0) == -1) {
      debugPrint('dragged from left');
    } else {
      debugPrint('dragged from right');
    }
  }

}





