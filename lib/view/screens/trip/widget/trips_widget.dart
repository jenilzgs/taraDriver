import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widget/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/trip/controller/trip_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/trip_card.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';
class TripsWidget extends StatefulWidget {
  final ScrollController scrollController;
  final TripController tripController;
  const TripsWidget({super.key, required this.tripController, required this.scrollController});

  @override
  State<TripsWidget> createState() => _TripsWidgetState();
}

class _TripsWidgetState extends State<TripsWidget> {

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: GetBuilder<TripController>(
        builder: (tripController) {
          return SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(mainAxisSize: MainAxisSize.min,children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('your_trip'.tr, style: textSemiBold.copyWith(color: Theme.of(context).textTheme.displayLarge!.color, fontSize: Dimensions.fontSizeExtraLarge),),

                  const Spacer(),



                  SizedBox(width: Dimensions.dropDownWidth,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      isDense: true,
                      decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(vertical: 0),

                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                      hint:  Text(tripController.selectedFilterTypeName.tr, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                      items: tripController.selectedFilterType.map((item) => DropdownMenuItem<String>(
                        value: item, child: Text(item.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)))).toList(),
                      onChanged: (value) {
                        tripController.setFilterTypeName(value!);
                      },
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8),),
                      iconStyleData: IconStyleData(
                        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor), iconSize: 24),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),),),
                      menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)),
                    ),
                  ),

                ],),
              ),

              widget.tripController.tripModel != null ? widget.tripController.tripModel!.data != null? widget.tripController.tripModel!.data!.isNotEmpty?

              Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: PaginatedListView(
                  scrollController: widget.scrollController,
                  totalSize: widget.tripController.tripModel!.totalSize,
                  offset: (widget.tripController.tripModel != null && widget.tripController.tripModel!.offset != null) ? int.parse(widget.tripController.tripModel!.offset.toString()) : 1,
                  onPaginate: (int? offset) async {
                    if (kDebugMode) {
                      print('==========offset========>$offset');
                    }
                    await widget.tripController.getTripList(offset!, '', '', 'ride_request',tripController.selectedFilterTypeName);
                  },

                  itemView: ListView.builder(
                    itemCount: widget.tripController.tripModel!.data!.length,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return TripCard(tripModel : widget.tripController.tripModel!.data![index]);
                    },
                  ),
                ),
              ): Padding(
                padding: EdgeInsets.only(top: Get.height/5),
                child: NoDataScreen(title: 'no_trip_found'.tr),
              ) : SizedBox(height: Get.height,child: const NotificationShimmer()):SizedBox(height: Get.height,child: const NotificationShimmer()),
            ],),
          );
        }
      ),
    );
  }
}
