import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/view/screens/chat/controller/chat_controller.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/payment_received_screen.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/review_this_customer_screen.dart';

class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    AndroidInitializationSettings androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // TODO: Route
        try{
          if(response.payload != null && response.payload!.isNotEmpty) {
            if (kDebugMode) {
              print('Notification response ==> ${response.payload.toString()}');
            }

          }
        }catch (e) {
          if (kDebugMode) {
            print('Notification response ==> ${response.payload.toString()}');
          }
        }
        return;
      },
      onDidReceiveBackgroundNotificationResponse: myBackgroundMessageReceiver,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AndroidInitializationSettings androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // TODO: Route
        try{
          if(response.payload != null && response.payload!.isNotEmpty) {
          }
        }catch (e) {
          if (kDebugMode) {
            print('Notification response ==> ${response.payload.toString()}');
          }
        }
        return;
      },
      onDidReceiveBackgroundNotificationResponse: myBackgroundMessageReceiver,
    );


    customPrint('onMessage: ${message.data}');

      if(message.data['action'] == "new_message_arrived"){
        Get.find<ChatController>().getConversation(message.data['type'], 1);
      }


    if(message.data['action'] == "new_ride_request_notification"){
      Get.find<RideController>().getPendingRideRequestList(1);
      Get.find<RideController>().getRideDetailBeforeAccept(message.data['ride_request_id']).then((value){
        if(value.statusCode == 200){
          Get.find<RiderMapController>().getPolyline();
          Get.find<RiderMapController>().setRideCurrentState(RideState.pending);
          Get.find<RideController>().updateRoute(false, notify: true);
          Get.to(()=> const MapScreen());
        }
      });
    }
    else if(message.data['action'] == "ride_completed" ){
      Get.find<RideController>().getRideDetails(message.data['ride_request_id']).then((value){
        if(value.statusCode == 200){
          Get.find<RideController>().getFinalFare(message.data['ride_request_id']).then((value){
            if(value.statusCode == 200){
              Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
              Get.to(()=> const PaymentReceivedScreen());
            }
          });
        }
      });
    }

    else if(message.data['action'] == "ride_accepted"){
      Get.find<RideController>().getRideDetails(message.data['ride_request_id']).then((value){
        if(value.statusCode == 200){
          Get.find<RiderMapController>().setRideCurrentState(RideState.accepted);
          Get.find<RideController>().updateRoute(false, notify: true);
          Get.to(()=> const MapScreen());
        }
      });
    }
    else if(message.data['action'] == "coupon_removed" || message.data['action'] == "coupon_applied"){
      Get.find<RideController>().getFinalFare(message.data['ride_request_id']);
    }
    else if(message.data['action'] == "payment_successful" && message.data['type'] == "ride_request"){
      Get.find<RideController>().getRideDetails(message.data['ride_request_id']).then((value){
        if(value.statusCode == 200){
          if(Get.find<ConfigController>().config!.reviewStatus!){
            Get.offAll(()=>  ReviewThisCustomerScreen(tripId: message.data['ride_request_id']));
          }else{
            Get.offAll(()=> const DashboardScreen());
          }

        }
      });

    }
    else if(message.data['action'] == "payment_successful" && message.data['type'] == "parcel"){
      Get.find<RideController>().getRideDetails(message.data['ride_request_id']).then((value){
        if(value.statusCode == 200){
          Get.find<RideController>().getOngoingParcelList();
          Get.back();
        }
      });

    }
    else if(message.data['action'] == "ride_cancelled" || message.data['action'] == "ride_started"){
      Get.find<RideController>().getPendingRideRequestList(1).then((value){
        if(value.statusCode == 200){
          Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
          Get.offAll(()=> const DashboardScreen());
        }
      });
    }
    else if(message.data['action'] == "account_approved" || message.data['action'] == "withdraw_rejected" ){
      Get.find<ProfileController>().getProfileInfo().then((value){
        if(value.statusCode == 200){
          Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
          Get.offAll(()=> const DashboardScreen());
        }
      });
    }


      NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      customPrint('onOpenApp: ${message.data}');
    });
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
    String title = message.data['title'];
    String body = message.data['body'];
    String? orderID = message.data['order_id'];
    String? image = (message.data['image'] != null && message.data['image'].isNotEmpty)
        ? message.data['image'].startsWith('http') ? message.data['image']
        : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;

    try{
      await showBigPictureNotificationHiddenLargeIcon(title, body, orderID, image, fln);
    }catch(e) {
      await showBigPictureNotificationHiddenLargeIcon(title, body, orderID, null, fln);
      customPrint('Failed to show notification: ${e.toString()}');
    }
  }


  static Future<void> showTextNotification(String title, String body, String orderID, String action, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'hexaride', 'hexaride', playSound: true,
      importance: Importance.max, priority: Priority.max, sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: action);
  }

  static Future<void> showBigTextNotification(String title, String body, String orderID, String action, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(

      body, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'hexaride', 'hexaride', importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: action);
  }


  // static Future<void> ongoingRideRequestProgress(int count, int i, String? body) async {
  //
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'hexaride', 'hexaride',
  //       channelDescription: 'progress channel description',
  //       channelShowBadge: true,
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       onlyAlertOnce: true,
  //       showProgress: true,
  //       ongoing: true,
  //       color: const Color(0xFF00A08D),
  //       maxProgress: count,
  //       progress: i);
  //   var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  //   flutterLocalNotificationsPlugin.show(0, 'Your ride is ongoing',
  //       body??'Enjoy your ride', platformChannelSpecifics,
  //       payload: 'item x');
  // }
  //




  static Future<void> showBigPictureNotificationHiddenLargeIcon(String title, String body, String? orderID, String? image, FlutterLocalNotificationsPlugin fln) async {
    String? largeIconPath;
    String? bigPicturePath;
    BigPictureStyleInformation? bigPictureStyleInformation;
    BigTextStyleInformation? bigTextStyleInformation;
    if(image != null && !GetPlatform.isWeb) {
      largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
      bigPicturePath = largeIconPath;
      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
        contentTitle: title, htmlFormatContentTitle: true,
        summaryText: body, htmlFormatSummaryText: true,
      );
    }else {
      bigTextStyleInformation = BigTextStyleInformation(
        body, htmlFormatBigText: true,
        contentTitle: title, htmlFormatContentTitle: true,
      );
    }
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'hexaride', 'hexaride', priority: Priority.max, importance: Importance.max, playSound: true,
      largeIcon: largeIconPath != null ? FilePathAndroidBitmap(largeIconPath) : null,
      styleInformation: largeIconPath != null ? bigPictureStyleInformation : bigTextStyleInformation,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage remoteMessage) async {
  customPrint('onBackground: ${remoteMessage.data}');
  // var androidInitialize = new AndroidInitializationSettings('notification_icon');
  // var iOSInitialize = new IOSInitializationSettings();
  // var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  // NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
}

Future<dynamic> myBackgroundMessageReceiver(NotificationResponse response) async {
  customPrint('onBackgroundClicked: ${response.payload}');
}