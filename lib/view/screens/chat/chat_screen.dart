import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/chat/controller/chat_controller.dart';
import 'package:ride_sharing_user_app/view/screens/chat/model/channel_model.dart';
import 'package:ride_sharing_user_app/view/screens/chat/widget/message_item.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widget/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    Get.find<ChatController>().getChannelList(1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatController>(
        builder: (chatController) {
          return Stack(children: [
              Column(children: [
                CustomAppBar(title: 'message'.tr,regularAppbar: true),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                chatController.channelModel!= null?(chatController.channelModel!.data != null && chatController.channelModel!.data!.isNotEmpty)?
                Expanded(child:
                    SingleChildScrollView(controller: scrollController,
                      child: PaginatedListView(
                        scrollController: scrollController,
                        totalSize: chatController.channelModel!.totalSize,
                        offset: chatController.channelModel != null && chatController.channelModel!.offset != null?
                        int.parse(chatController.channelModel!.offset.toString()) : 1,
                        onPaginate: (int? offset) async => await chatController.getChannelList(offset!),

                        itemView: ListView.builder(
                          itemCount: chatController.channelModel!.data!.length,
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            ChannelUsers? channelUser;
                            for (var element in chatController.channelModel!.data![index].channelUsers!) {
                              if(element.user!.userType == 'customer'){
                                channelUser = element;
                              }
                            }
                            return  MessageItem(isRead: false, channelUsers: channelUser!,
                                lastMessage: chatController.channelModel!.data![index].lastChannelConversations!.message??'');
                          },
                        ),
                      ),
                    )
                ):
                 Expanded(child: NoDataScreen(title: 'no_channel_found'.tr,)):const Expanded(child: NotificationShimmer()),

              ],),
            ],
          );
        }
      ),
    );
  }
}
