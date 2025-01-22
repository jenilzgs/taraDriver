import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/customer_ride_request_card.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';

class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({super.key});

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  @override
  void initState() {
    Get.find<RideController>().getPendingRideRequestList(1);
    super.initState();
  }
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'trip_request'.tr, regularAppbar: true,),
      body: RefreshIndicator (
        onRefresh: () async{
          Get.find<RideController>().getPendingRideRequestList(1);
        },
        child: GetBuilder<RideController>(
          builder: (rideController) {

            return !rideController.isLoading? (rideController.pendingRideRequestModel!= null && rideController.pendingRideRequestModel!.data != null && rideController.pendingRideRequestModel!.data!.isNotEmpty)?
            SingleChildScrollView(
              controller: scrollController,
              child: PaginatedListView(
                scrollController: scrollController,
                totalSize: rideController.pendingRideRequestModel!.totalSize,
                offset: rideController.pendingRideRequestModel != null && rideController.pendingRideRequestModel!.offset != null? int.parse(rideController.pendingRideRequestModel!.offset.toString()) : 1,
                onPaginate: (int? offset) async {
                  await rideController.getPendingRideRequestList(offset!);
                },

                itemView: ListView.builder(
                  itemCount: rideController.pendingRideRequestModel!.data!.length,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {

                    return CustomerRideRequestCardWidget(rideRequest: rideController.pendingRideRequestModel!.data![index], fromList: true, index: index,);
                  },
                ),
              ),
            ):
            const NoDataScreen():
             Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,));
          }
        ),
      ),

    );
  }
}
