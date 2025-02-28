import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/chat/message_screen.dart';
import 'package:ride_sharing_user_app/view/screens/chat/model/channel_model.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';

class MessageItem extends StatelessWidget {
  final bool isRead;
  final ChannelUsers channelUsers;
  final String lastMessage;
  const MessageItem({super.key, required this.isRead, required this.channelUsers, required this.lastMessage});

  @override
  Widget build(BuildContext context) {
    return  InkWell(onTap: ()=> Get.to(()=>  MessageScreen(channelId: channelUsers.channelId!)),
      child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
        child: Container(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
            color: isRead ? Theme.of(context).colorScheme.primary.withOpacity(.1) : Theme.of(context).cardColor),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center, children:[
              const SizedBox(width: Dimensions.paddingSizeSmall,),
              ClipRRect(borderRadius: BorderRadius.circular(50),
                child: CustomImage(height: 35, width: 35,
                    image: '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImageCustomer}/${channelUsers.user!.profileImage??''}')),



              const SizedBox(width: Dimensions.paddingSizeSmall,),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${channelUsers.user!.firstName!} ${channelUsers.user!.lastName!}', style: textBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault, color:Theme.of(context).primaryColor)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),



                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: Text(lastMessage, style: textMedium.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color:isRead? Theme.of(context).textTheme.bodyMedium!.color :Theme.of(context).hintColor,
                    ),overflow: TextOverflow.ellipsis)),


                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                  Text( DateConverter.isoStringToDateTimeString(channelUsers.updatedAt!),
                    textDirection: TextDirection.ltr,
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).primaryColor),
                  )],
                )])),
              const SizedBox(width: Dimensions.paddingSizeSmall,),
            ],
          ),
        ),
      ),
    );
  }
}
