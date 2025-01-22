import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/auth/repository/auth_repo.dart';
import 'package:ride_sharing_user_app/view/screens/chat/controller/chat_controller.dart';
import 'package:ride_sharing_user_app/view/screens/chat/repository/chat_repo.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/view/screens/help_and_support/controller/help_and_support_controller.dart';
import 'package:ride_sharing_user_app/view/screens/help_and_support/repository/help_and_support_repository.dart';
import 'package:ride_sharing_user_app/view/screens/leaderboard/controller/leader_board_controller.dart';
import 'package:ride_sharing_user_app/view/screens/leaderboard/repository/leader_board_repo.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/repository/location_repo.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/notification/controller/notification_controller.dart';
import 'package:ride_sharing_user_app/view/screens/notification/repository/notification_repo.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/repository/profile_repo.dart';
import 'package:ride_sharing_user_app/view/screens/review/controller/review_controller.dart';
import 'package:ride_sharing_user_app/view/screens/review/repository/review_repo.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/repository/ride_repo.dart';
import 'package:ride_sharing_user_app/view/screens/setting/controller/setting_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/repo/config_repo.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/localization/language_model.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/view/screens/trip/controller/trip_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/repository/trip_repo.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/controller/wallet_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/repository/wallet_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => ConfigRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => RideRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProfileRepo(apiClient: Get.find()));
  Get.lazyPut(() => ChatRepo(apiClient: Get.find()));
  Get.lazyPut(() => ReviewRepo(apiClient: Get.find()));
  Get.lazyPut(() => LeaderBoardRepo(apiClient: Get.find()));
  Get.lazyPut(() => HelpAndSupportRepo(apiClient: Get.find()));
  Get.lazyPut(() => WalletRepo(apiClient: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find()));
  Get.lazyPut(() => TripRepo(apiClient: Get.find()));
  Get.lazyPut(() => LocationRepo(sharedPreferences: Get.find(),apiClient: Get.find()));


  // Controller
  Get.lazyPut(() => ConfigController(configRepo: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthController(authRepo:  Get.find()));
  Get.lazyPut(() => RideController(rideRepo: Get.find()));
  Get.lazyPut(() => ProfileController(profileRepo: Get.find()));
  Get.lazyPut(() => ChatController(chatRepo: Get.find()));
  Get.lazyPut(() => ReviewController(reviewRepo: Get.find()));
  Get.lazyPut(() => LeaderBoardController(leaderBoardRepo: Get.find()));
  Get.lazyPut(() => HelpAndSupportController(helpAndSupportRepo: Get.find()));
  Get.lazyPut(() => WalletController(walletRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => TripController(tripRepo: Get.find()));
  Get.lazyPut(() => RiderMapController());
  Get.lazyPut(() => BottomMenuController());
  Get.lazyPut(() => SettingController());
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));


  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> languageJson = {};
    mappedJson.forEach((key, value) {
      languageJson[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = languageJson;
  }
  return languages;
}
