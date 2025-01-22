import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widget/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/controller/wallet_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/loyalty_point_card.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';

class LoyaltyPointTransactionList extends StatefulWidget {

  final WalletController walletController;
  const LoyaltyPointTransactionList({super.key, required this.walletController});

  @override
  State<LoyaltyPointTransactionList> createState() => _LoyaltyPointTransactionListState();
}

class _LoyaltyPointTransactionListState extends State<LoyaltyPointTransactionList> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return widget.walletController.loyaltyPointModel != null? widget.walletController.loyaltyPointModel!.data != null && widget.walletController.loyaltyPointModel!.data!.isNotEmpty?
    PaginatedListView(
      scrollController: scrollController,
      totalSize: widget.walletController.loyaltyPointModel!.totalSize,
      offset: (widget.walletController.loyaltyPointModel != null && widget.walletController.loyaltyPointModel!.offset != null) ? int.parse(widget.walletController.loyaltyPointModel!.offset.toString()) : null,
      onPaginate: (int? offset) async {
        if (kDebugMode) {
          print('==========offset========>$offset');
        }
        await widget.walletController.getTransactionList(offset!);
      },

      itemView: ListView.builder(
        itemCount: widget.walletController.loyaltyPointModel!.data!.length,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return LoyaltyPointCard(points: widget.walletController.loyaltyPointModel!.data![index]);
        },
      ),
    ):const NoDataScreen():const NotificationShimmer();
  }
}
