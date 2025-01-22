import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/help_and_support/controller/help_and_support_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/type_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HelpAndSupportController>(
        builder: (helpAndSupportController) {
          String data = helpAndSupportController.helpAndSupportIndex ==1?
          '${Get.find<ConfigController>().config!.legal?.shortDescription??''}\n${Get.find<ConfigController>().config!.legal?.longDescription??''}':
          '${Get.find<ConfigController>().config!.privacyPolicy?.shortDescription??''}\n${Get.find<ConfigController>().config!.privacyPolicy?.longDescription??''}';
          return Stack(children: [

              Column(children: [
                CustomAppBar(title: 'help_and_support'.tr, regularAppbar: true),
                const SizedBox(height: 30),


                helpAndSupportController.helpAndSupportIndex ==0?
                Padding(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeExtraLarge),
                  child: Column(children: [

                    Padding(padding:  const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                      child: Center(
                        child: SizedBox(width: 200, child: Image.asset(Images.supportDesk)))),

                    Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeDefault),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(padding:  const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtraSmall),
                          child: Text('contact_us_through_email'.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault))),

                        Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                            Text('you_can_send_us_email_through'.tr, style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                            Text(Get.find<ConfigController>().config!.businessContactEmail??'',
                              style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                            Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                child: Text.rich(
                                  TextSpan(children: [
                                      TextSpan(text: 'typically_support_team_send_you_feedback'.tr,
                                          style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                                      TextSpan(text: 'two_hours'.tr, style: textSemiBold)]))),
                          ],),
                        ),

                        Padding(padding:  const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtraSmall),
                          child: Text('contact_us_through_phone'.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault))),

                        Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                          Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text.rich(TextSpan(children: [
                                 TextSpan(text: 'contact_with_us'.tr, style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                              TextSpan(text: Get.find<ConfigController>().config!.businessContactPhone??'',
                                  style: textSemiBold)]))),


                          Text.rich(TextSpan(children: [
                            TextSpan(text: 'talk_with_our'.tr, style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                            TextSpan(text: 'customer_support_executive'.tr, style: textSemiBold),
                            TextSpan(text: 'at_any_time'.tr, style: textRegular.copyWith(color: Theme.of(context).hintColor))]))
                        ],),
                      ],),
                    ),
                    SizedBox(height: Dimensions.paddingSizeOverLarge),


                    Row(children: [
                      Expanded(child: Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: CustomButton(buttonText: 'email'.tr, icon: Icons.email, radius: 100,
                          onPressed: ()=> _launchUrl("sms:${Get.find<ConfigController>().config!.businessContactEmail!}",true)))),

                      Expanded(child: Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: CustomButton(buttonText: 'call'.tr, icon: Icons.call,radius: 100,
                          onPressed: () => _launchUrl("tel:${Get.find<ConfigController>().config!.businessContactPhone!}",false)),
                      )),
                    ],)
                  ],),
                ):

                helpAndSupportController.helpAndSupportIndex ==1?
                 Expanded(child: Container(height: MediaQuery.of(context).size.height, color: Theme.of(context).cardColor,

                   child: SingleChildScrollView(padding:  const EdgeInsets.all(Dimensions.paddingSizeSmall),
                     physics: const BouncingScrollPhysics(),
                     child: HtmlWidget(data, key: const Key( 'privacy_policy')))),
                 ):

                Expanded(child: Container(height: MediaQuery.of(context).size.height, color: Theme.of(context).cardColor,
                  child: SingleChildScrollView(
                    padding:  const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    physics: const BouncingScrollPhysics(),
                    child: HtmlWidget(data, key: const Key( 'privacy_policy')))))],),


              Positioned(top: 90,left: 10,right: 10,
                child: SizedBox(height: Dimensions.headerCardHeight,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: helpAndSupportController.helpAndSupportTypeList.length,
                      itemBuilder: (context, index){
                        return TypeButtonWidget(index: index,
                            name: helpAndSupportController.helpAndSupportTypeList[index],
                            selectedIndex: helpAndSupportController.helpAndSupportIndex,
                            cardWidth: Get.width/3.45,
                            onTap: () => helpAndSupportController.setHelpAndSupportIndex(index));
                      }),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

final Uri params = Uri(
  scheme: 'mailto',
  path: '',
  query: 'subject=support Feedback&body=',
);


Future<void> _launchUrl(String url, bool isMail) async {
  if (!await launchUrl(Uri.parse(isMail? params.toString() :url))) {
    throw 'Could not launch $url';
  }
}
