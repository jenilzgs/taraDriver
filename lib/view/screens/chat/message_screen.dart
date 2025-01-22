import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/chat/controller/chat_controller.dart';
import 'package:ride_sharing_user_app/view/screens/chat/widget/message_bubble.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';

class MessageScreen extends StatefulWidget {
  final String channelId;
  const MessageScreen({super.key, required this.channelId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    Get.find<ChatController>().getConversation(widget.channelId, 1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GetBuilder<ChatController>(builder: (messageController){
        return Column(children: [
          CustomAppBar(title: 'message'.tr, regularAppbar: true,),


          (messageController.messageModel != null && messageController.messageModel!.data != null)? messageController.messageModel!.data!.isNotEmpty?
          Expanded(child: SingleChildScrollView(controller: scrollController,
            reverse: true,
            child: Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: PaginatedListView(
                reverse: true,
                scrollController: scrollController,
                totalSize: messageController.messageModel!.totalSize,
                offset: (messageController.messageModel != null && messageController.messageModel!.offset != null) ?
                int.parse(messageController.messageModel!.offset.toString()) : null,
                onPaginate: (int? offset) async  => await messageController.getConversation(widget.channelId, offset!),

                  itemView: ListView.builder(
                    reverse: true,
                    itemCount: messageController.messageModel!.data!.length,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ConversationBubble(message: messageController.messageModel!.data![index]);
                    },
                  ),
                ),
            ),
            ),
          ):  Expanded(child: NoDataScreen(title: 'no_message_found'.tr,)) :
           Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, children: [
              SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,),
              ],
            ),
          ),


          messageController.pickedImageFile != null && messageController.pickedImageFile!.isNotEmpty ?
          Container(height: 90, width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                return  Stack(children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ClipRRect(borderRadius: BorderRadius.circular(10),
                      child: SizedBox(height: 80, width: 80,
                        child: Image.file(File(messageController.pickedImageFile![index].path), fit: BoxFit.cover)))),


                    Positioned(right: 5,
                      child: InkWell(child: const Icon(Icons.cancel_outlined, color: Colors.red),
                        onTap: () => messageController.pickMultipleImage(true,index: index))),
                  ],
                );},
              itemCount: messageController.pickedImageFile!.length)) : const SizedBox(),

          messageController.otherFile != null ?
          Stack(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 25), height: 25,
              child: Text(messageController.otherFile!.names.toString())),


            Positioned(top: 0, right: 0,
                child: InkWell(child: const Icon(Icons.cancel_outlined, color: Colors.red),
                    onTap: () => messageController.pickOtherFile(true)))]) : const SizedBox(),

          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(margin: const EdgeInsets.only(left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraLarge),
              decoration: BoxDecoration(boxShadow: Get.isDarkMode? null : [
                  BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25), blurRadius: 2.0, spreadRadius: 5, offset: const Offset(5, 4),)],
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(100))),

              child: Form(key: messageController.conversationKey,
                child: Row(children: [
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(child: TextField(minLines: 2,
                        controller: messageController.conversationController,
                        textCapitalization: TextCapitalization.sentences,
                        style: textMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color:Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.8)),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "type_here".tr,
                          hintStyle: textRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.8),
                            fontSize: 16)),
                        onChanged: (String newText) {

                        },
                      ),
                    ),

                    Row(children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: InkWell(child: Image.asset(
                              Images.pickImage, color: Get.isDarkMode?Colors.white:Colors.black),
                              onTap: () => messageController.pickMultipleImage(false))),

                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSeven),
                          child: InkWell(child: Image.asset(Images.pickFile, color: Get.isDarkMode?Colors.white:Colors.black),
                              onTap: () => messageController.pickOtherFile(false))),

                        messageController.isLoading ?
                        Container(padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 20, width: 40,
                          child: Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)),
                        ) :

                        InkWell(onTap: (){
                            if(messageController.conversationController.text.isEmpty
                                && messageController.pickedImageFile!.isEmpty
                                && messageController.otherFile==null){
                            }
                            else if(messageController.conversationKey.currentState!.validate()){
                              messageController.sendMessage(widget.channelId);
                            }
                            messageController.conversationController.clear();
                          },
                          child: messageController.isSending?  Padding(padding: const EdgeInsets.all(8.0),
                            child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 25.0,),
                          ):

                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: Image.asset(Images.sendMessage,
                              width: Dimensions.iconSizeMedium,
                              height: Dimensions.iconSizeMedium,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ],
      );
    }),
    );
  }
}
