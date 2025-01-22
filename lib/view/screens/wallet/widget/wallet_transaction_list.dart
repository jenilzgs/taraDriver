import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widget/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/controller/wallet_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/transaction_card_widget.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';

class WalletTransactionList extends StatefulWidget {
  final WalletController walletController;
  final ScrollController scrollController;
  const WalletTransactionList({super.key, required this.walletController, required this.scrollController});

  @override
  State<WalletTransactionList> createState() => _WalletTransactionListState();
}

class _WalletTransactionListState extends State<WalletTransactionList> {
  @override
  Widget build(BuildContext context) {
    return widget.walletController.transactionModel != null? widget.walletController.transactionModel!.data != null && widget.walletController.transactionModel!.data!.isNotEmpty?
    Padding(padding: const EdgeInsets.only(bottom : 85.0),
      child: PaginatedListView(
        scrollController: widget.scrollController,
        totalSize: widget.walletController.transactionModel!.totalSize,
        offset: (widget.walletController.transactionModel != null && widget.walletController.transactionModel!.offset != null) ? int.parse(widget.walletController.transactionModel!.offset.toString()) : null,
        onPaginate: (int? offset) async {
          if (kDebugMode) {
            print('==========offset========>$offset');
          }
          await widget.walletController.getTransactionList(offset!);
        },

        itemView: ListView.builder(
          itemCount: widget.walletController.transactionModel!.data!.length,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return TransactionCard(transaction: widget.walletController.transactionModel!.data![index]);
          },
        ),
      ),
    ):const NoDataScreen():SizedBox(height: Get.height, child: const NotificationShimmer());
  }
}
