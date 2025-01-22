import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widget/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/review/controller/review_controller.dart';
import 'package:ride_sharing_user_app/view/screens/review/widget/review_card.dart';
import 'package:ride_sharing_user_app/view/screens/review/widget/review_type_button_widget.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.find<ReviewController>().getReviewList(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ReviewController>(
        builder: (reviewController) {
          return Stack(
            children: [
              Column(children: [
                CustomAppBar(title: 'reviews'.tr),

                const SizedBox(height: Dimensions.topBelowSpace),

                Expanded(child: reviewController.reviewModel != null ? (reviewController.reviewModel!.data != null && reviewController.reviewModel!.data!.isNotEmpty) ?
                  SingleChildScrollView(
                    controller: scrollController,
                    child: PaginatedListView(
                      scrollController: scrollController,
                      totalSize: reviewController.reviewModel!.totalSize,
                      offset: (reviewController.reviewModel != null && reviewController.reviewModel!.offset != null) ? int.parse(reviewController.reviewModel!.offset.toString()) : null,
                      onPaginate: (int? offset) async {
                        if (kDebugMode) {
                          print('==========offset========>$offset');
                        }
                        await reviewController.getReviewList(offset);
                      },

                      itemView: ListView.builder(
                        itemCount: reviewController.reviewModel!.data!.length,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ReviewCard(review: reviewController.reviewModel!.data![index], index: index);
                        },
                      ),
                    ),
                  ): NoDataScreen(title: 'no_review_found'.tr) : const NotificationShimmer(),
                ),
              ],),
              Positioned( top: Dimensions.topSpace,left: Dimensions.paddingSizeSmall,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(height: Dimensions.headerCardHeight,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: reviewController.reviewTypeList.length,
                          itemBuilder: (context, index){
                            return SizedBox(width : Get.width/2.1, child: ReviewTypeButtonWidget(reviewType : reviewController.reviewTypeList[index], index: index));
                          }),
                      ),
                    ],
                  ))
            ],
          );
        }
      ),
    );
  }
}
