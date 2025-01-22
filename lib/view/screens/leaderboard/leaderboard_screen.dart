import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/leaderboard/controller/leader_board_controller.dart';
import 'package:ride_sharing_user_app/view/screens/leaderboard/widget/leader_board_card_widget.dart';
import 'package:ride_sharing_user_app/view/screens/leaderboard/widget/today_leaderboard_status_widget.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widget/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {


  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    Get.find<LeaderBoardController>().getLeaderboardList(1);
    Get.find<LeaderBoardController>().getDailyActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LeaderBoardController>(
        builder: (leaderboardController) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomAppBar(title: 'leader_board'.tr, showBackButton: true,),

            const TodayLeaderBoardStatusWidget(),

            Expanded(child: Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: SingleChildScrollView(
                  child: GetBuilder<LeaderBoardController>(
                    builder: (leaderboardController) {
                      return leaderboardController.leaderBoardModel != null?(leaderboardController.leaderBoardModel!.data != null && leaderboardController.leaderBoardModel!.data!.isNotEmpty)?
                        Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                          Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center,children: [


                            if(leaderboardController.leaderBoardModel!.data!.length>1)
                            Expanded(child: LeaderboardStageItem(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                index: 2,
                                profile: leaderboardController.leaderBoardModel!.data![1].driver?.profileImage??'',
                                name: '${leaderboardController.leaderBoardModel!.data![1].driver?.firstName??''} ${leaderboardController.leaderBoardModel!.data![1].driver?.lastName??''}',
                                tripCount: leaderboardController.leaderBoardModel!.data![1].totalRecords??0)),


                            if(leaderboardController.leaderBoardModel!.data!.isNotEmpty)
                            Expanded(child: LeaderboardStageItem(
                                color: Theme.of(context).primaryColor,
                                index: 1,
                                profile: leaderboardController.leaderBoardModel!.data![0].driver!.profileImage!,
                                name: '${leaderboardController.leaderBoardModel!.data![0].driver!.firstName!} ${leaderboardController.leaderBoardModel!.data![0].driver!.lastName!}',
                                tripCount: leaderboardController.leaderBoardModel!.data![0].totalRecords!)),


                            if(leaderboardController.leaderBoardModel!.data!.length>2)
                            Expanded(child: LeaderboardStageItem(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                                index: 3,
                                profile: leaderboardController.leaderBoardModel!.data![2].driver!.profileImage!,
                                name: '${leaderboardController.leaderBoardModel!.data![2].driver!.firstName!} ${leaderboardController.leaderBoardModel!.data![1].driver?.lastName??''}',
                                tripCount: leaderboardController.leaderBoardModel!.data![2].totalRecords!))],),


                          if(leaderboardController.leaderBoardModel !=null && leaderboardController.leaderBoardModel!.data != null && leaderboardController.leaderBoardModel!.data!.length>3)
                         Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraLarge,
                             Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
                          child: Text('on_the_serial'.tr, style: textSemiBold)),
                          leaderboardController.leaderBoardModel != null ? leaderboardController.leaderBoardModel!.data != null?
                          leaderboardController.leaderBoardModel!.data!.length>3?

                          PaginatedListView(
                            scrollController: scrollController,
                            totalSize: leaderboardController.leaderBoardModel!.totalSize,
                            offset: (leaderboardController.leaderBoardModel != null && leaderboardController.leaderBoardModel!.offset != null) ?
                            int.parse(leaderboardController.leaderBoardModel!.offset.toString()) : null,
                            onPaginate: (int? offset) async {
                              await leaderboardController.getLeaderboardList(offset!);
                            },

                            itemView: ListView.builder(
                              itemCount: leaderboardController.leaderBoardModel!.data!.length - 3,
                              padding: const EdgeInsets.all(0),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return LeaderBoardCard(index: index+3,leaderBoard : leaderboardController.leaderBoardModel!.data![index+3]);
                              },
                            ),
                          ): const SizedBox() : SizedBox(height: Get.height,child: const NotificationShimmer()):
                          SizedBox(height: Get.height,child: const NotificationShimmer()),
                      ],): Padding(padding: EdgeInsets.only(top: Get.height/5), child: const NoDataScreen(),): const NotificationShimmer();
                    }
                  ),
                ),
              ),
            )
          ],);
        }
      ),
    );
  }
}


class LeaderboardStageItem extends StatelessWidget {
  final Color color;
  final int index;
  final String name;
  final int tripCount;
  final bool isFirst;
  final bool isSecond;
  final String profile;
  const LeaderboardStageItem({super.key,
    required this.color,
    required this.index,
    required this.name,
    required this.tripCount,
     this.isFirst = false,
    this.isSecond = false, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(children: [
          Text(tripCount.toString().padLeft(2, '0'),
            style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                color: index ==3? Theme.of(context).colorScheme.tertiaryContainer: color),),


          Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeSmall),
            child: Text('trips'.tr,style: textMedium.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                color: index ==3? Theme.of(context).colorScheme.tertiaryContainer: color))),

          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            child: ClipRRect(borderRadius: BorderRadius.circular(100),
                child: CustomImage(image: '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage!}/$profile', width: 50,height: 50,))),

          Container(width: 100, decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(Dimensions.paddingSizeSeven)),

            child: Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                vertical: index == 1? Dimensions.paddingSizeDefault :Dimensions.paddingSizeSmall),
              child: Column(children: [
                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                      color: Colors.white, boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25), blurRadius: 1, spreadRadius: 1, offset: const Offset(1,3))]),
                    width: index == 1? 40 : index == 3? 25 : 30, height:  index == 1? 40 : index == 3? 25 : 30,
                    child: Center(child: Text(index.toString(),
                      style: textBold.copyWith(fontSize: index == 1? Dimensions.fontSizeExtraLarge:index == 3? 10 : Dimensions.fontSizeDefault,
                          color:  index == 3? Theme.of(context).colorScheme.secondaryContainer : color),)),
                  ),
                Padding(padding: EdgeInsets.only(top: index == 1? Dimensions.paddingSizeDefault :index == 3? 0: Dimensions.paddingSizeExtraSmall),
                  child: Text(name.toString(), maxLines: 2, style: textSemiBold.copyWith(color: index == 3? Theme.of(context).colorScheme.tertiaryContainer : Colors.white),),)]),
            ),
          ),
        ],
      ),
    );
  }
}
