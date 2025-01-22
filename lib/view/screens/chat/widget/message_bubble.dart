import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/chat/model/message_model.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';
import 'package:ride_sharing_user_app/view/widgets/image_dialog.dart';

class ConversationBubble extends StatefulWidget {
  final Message message;
  const ConversationBubble({super.key,  required this.message});
  @override
  State<ConversationBubble> createState() => _ConversationBubbleState();
}

class _ConversationBubbleState extends State<ConversationBubble> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
    CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
      Padding(padding: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
      const EdgeInsets.fromLTRB(20, 5, 5, 5) : const EdgeInsets.fromLTRB(5, 5, 20, 5),
        child: Column(
          crossAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
          CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            SizedBox(height:Dimensions.fontSizeExtraSmall),

            Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
              MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                const SizedBox() :
                Column(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(50),
                      child: CustomImage(height: 30, width: 30,
                          image: '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImageCustomer}/${widget.message.user!.profileImage}'))]),



                const SizedBox(width: Dimensions.paddingSizeSmall,),
                Flexible(child: Column(crossAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId)?
                  CrossAxisAlignment.end:CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, children: [
                      if(widget.message.message != null)
                      Flexible(child: Container(
                          decoration: BoxDecoration(
                            color: (widget.message.user!.id! == Get.find<ProfileController>().driverId)?
                            Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10)),
                          child:  Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Text(widget.message.message??'', style: textRegular.copyWith(),)))),




                      if( widget.message.conversationFiles!.isNotEmpty) const SizedBox(height: Dimensions.paddingSizeSmall),
                      widget.message.conversationFiles!.isNotEmpty?
                      Directionality(textDirection:Get.find<LocalizationController>().isLtr ? (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                        TextDirection.rtl: TextDirection.ltr : (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?TextDirection.ltr : TextDirection.rtl,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: 3,
                            mainAxisSpacing: Dimensions.paddingSizeSmall,
                            crossAxisSpacing: Dimensions.paddingSizeSmall),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.message.conversationFiles!.length,
                          itemBuilder: (BuildContext context, index){
                            return widget.message.conversationFiles![index].fileType == 'png' || widget.message.conversationFiles![index].fileType == 'jpg'?
                            InkWell(onTap: () => showDialog(context: context, builder: (ctx) {
                                return ImageDialog(imageUrl: '${Get.find<ConfigController>().config!.imageBaseUrl!.conversation}/${widget.message.conversationFiles![index].fileName ?? ''}');
                              }),
                              child: ClipRRect(borderRadius: BorderRadius.circular(5),
                                  child:CustomImage(height: 100, width: 100, fit: BoxFit.cover,
                                    image: '${Get.find<ConfigController>().config!.imageBaseUrl!.conversation!}/${widget.message.conversationFiles![index].fileName ?? ''}')),
                            ) :


                            InkWell(onTap : () async {
                                final status = await Permission.storage.request();
                                if(status.isGranted){
                                  Directory? directory = Directory('/storage/emulated/0/Download');
                                  if (!await directory.exists()) {
                                    directory = Platform.isAndroid
                                        ? await getExternalStorageDirectory() //FOR ANDROID
                                        : await getApplicationSupportDirectory();
                                  }
                                }
                              },
                              child: Container(height: 50,width: 50,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).hoverColor),
                                child: Stack(children: [
                                    Center(child: SizedBox(width: 50, child: Image.asset(Images.folder))),
                                    Center(child: Text('${widget.message.conversationFiles![index].fileName}'.substring(widget.message.conversationFiles![index].fileName!.length-7),
                                        maxLines: 5, overflow: TextOverflow.clip)),
                                  ],
                                ),),
                            );
                          },),
                      ):
                      const SizedBox.shrink(),
                    ],
                  ),
                ),

                const SizedBox(width: 10,),
                (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                ClipRRect(borderRadius: BorderRadius.circular(50),
                    child: CustomImage(height: 30, width: 30,
                        image: '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage!}/${widget.message.user!.profileImage}'
                    )
                )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),

      Padding(padding: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
      const EdgeInsets.fromLTRB(5, 0, 50, 5) : const EdgeInsets.fromLTRB(50, 0, 5, 5),
          child: Text(DateConverter.isoStringToDateTimeString(widget.message.updatedAt!),
              textDirection: TextDirection.ltr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall))),
    ],
    );
  }
}


