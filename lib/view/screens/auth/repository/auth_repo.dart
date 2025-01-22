import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/view/screens/auth/model/signup_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response?> login({required String phone, required String password}) async {
    return await apiClient.postData(AppConstants.loginUri,
        {"phone_or_email": phone,
          "password": password});
  }

  Future<Response?> logOut() async {
    return await apiClient.postData(AppConstants.logout, {});}


  Future<Response> registration({required SignUpBody signUpBody, XFile? profileImage, List<MultipartBody>? identityImage}) async {
    return await apiClient.postMultipartData(AppConstants.registration,
      signUpBody.toJson(),
      identityImage!,
      MultipartBody('profile_image', profileImage), []);
  }



  Future<Response?> sendOtp({required String phone}) async {
    return await apiClient.postData(AppConstants.sendOtp,
        {"phone_or_email": phone});
  }

  Future<Response?> verifyOtp({required String phone, required String otp}) async {
    return await apiClient.postData(AppConstants.otpVerification,
        {"phone_or_email": phone,
          "otp": otp
        });
  }


  Future<Response?> resetPassword(String phoneOrEmail, String password) async {
    return await apiClient.postData(AppConstants.resetPassword,
      { "phone_or_email": phoneOrEmail,
        "password": password,},
    );
  }

  Future<Response?> changePassword(String oldPassword, String password) async {
    return await apiClient.postData(AppConstants.changePassword,
      { "password": oldPassword,
        "new_password": password,
      },
    );
  }



  String? deviceToken;
  Future<Response?> updateToken() async {
    if (GetPlatform.isIOS) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    }else {
      deviceToken = await _saveDeviceToken();
      saveDeviceToken();
    }

    if(!GetPlatform.isWeb){
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
    }
    return await apiClient.postData(AppConstants.fcmTokenUpdate, {"_method": "put", "fcm_token": deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }catch(e) {
      debugPrint('');
    }
    if (deviceToken != null) {
      if (kDebugMode) {
        print('--------Device Token---------- $deviceToken');
      }
    }
    return deviceToken;
  }

  Future<Response?> forgetPassword(String? phone) async {
    return await apiClient.postData(AppConstants.configUri, {"phone_or_email": phone});
  }




  Future<Response?> verifyPhone(String phone, String otp) async {
    return await apiClient.postData(AppConstants.configUri, {"phone": phone, "otp": otp});
  }

  Future<bool?> saveUserToken(String token, String zoneId) async {
    apiClient.token = token;
    apiClient.updateHeader(token, sharedPreferences.getString(AppConstants.languageCode), "latitude", "longitude", zoneId);
    return await sharedPreferences.setString(AppConstants.token, token);

  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);

    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveDeviceToken() async {
    try {
      await sharedPreferences.setString(AppConstants.deviceToken, deviceToken??'');
    } catch (e) {
      rethrow;
    }
  }

  String getDeviceToken() {
    return sharedPreferences.getString(AppConstants.deviceToken) ?? "";
  }
  String getUserNumber() {
   return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  String getUserCountryCode() {
   // return sharedPreferences.getString(AppConstants.USER_COUNTRY_CODE) ?? "";
    return "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  bool isNotificationActive() {
    //return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
    return true;
  }

  toggleNotificationSound(bool isNotification){
    //sharedPreferences.setBool(AppConstants.NOTIFICATION, isNotification);
  }


  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  bool clearSharedAddress(){
    //sharedPreferences.remove(AppConstants.USER_ADDRESS);
    return true;
  }
  String getZonId() {
    return sharedPreferences.getString(AppConstants.zoneId) ?? "";

  }
  Future<void> updateZone(String zoneId) async {
    try {
      await sharedPreferences.setString(AppConstants.zoneId, zoneId);
      apiClient.updateHeader(sharedPreferences.getString(AppConstants.token)??'', sharedPreferences.getString(AppConstants.languageCode), 'latitude', 'longitude', zoneId);
    } catch (e) {
      rethrow;
    }
  }
}
