import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/notification/controller/notification_controller.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widget/notification_card.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widget/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/widget/profile_menu_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_drawer.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';


class NotificationMenu extends GetView<ProfileController> {
  const NotificationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: const ProfileMenuScreen(),
        mainScreen: const NotificationScreen(),
        borderRadius: 24.0,
        angle: -5.0,
        isRtl: !Get.find<LocalizationController>().isLtr,
        menuBackgroundColor: Theme.of(context).primaryColor,
        slideWidth: MediaQuery.of(context).size.width * 0.85,
        mainScreenScale: .4,
      ),
    );
  }
}



class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Get.find<NotificationController>().getNotificationList(1);
    return Scaffold(
      body: GetBuilder<NotificationController>(
        builder: (notificationController) {
          return Stack(children: [
              Column(children: [
                CustomAppBar(title: 'my_notification'.tr,regularAppbar: true, showBackButton: false,  onTap: (){
                  Get.find<ProfileController>().toggleDrawer();}),

                const SizedBox(height: Dimensions.paddingSizeSmall,),
                Expanded(child: GetBuilder<NotificationController>(
                      builder: (notificationController) {
                        return notificationController.notificationModel != null ? (notificationController.notificationModel!.data != null && notificationController.notificationModel!.data!.isNotEmpty) ?
                        SingleChildScrollView(
                          controller: scrollController,
                          child: PaginatedListView(
                            scrollController: scrollController,
                            totalSize: notificationController.notificationModel!.totalSize,
                            offset: (notificationController.notificationModel != null && notificationController.notificationModel!.offset != null) ? int.parse(notificationController.notificationModel!.offset.toString()) : null,
                            onPaginate: (int? offset) async {
                              await notificationController.getNotificationList(offset!);
                            },

                            itemView: Padding(padding: const EdgeInsets.only(bottom: 70),
                              child: ListView.builder(
                                itemCount: notificationController.notificationModel!.data!.length,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return NotificationCard(notification: notificationController.notificationModel!.data![index]);}))),
                        ): NoDataScreen(title: 'no_notification_found'.tr) : const NotificationShimmer() ;
                      }
                  ),
                ),
              ],),
            ],
          );
        }
      ),
    );
  }
}
