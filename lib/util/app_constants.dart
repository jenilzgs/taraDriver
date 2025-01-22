
import 'package:ride_sharing_user_app/localization/language_model.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class AppConstants {
  static const String appName = 'Taracabs Partner';
  static const bool isDemo = true;
  static const String polylineMapKey = 'AIzaSyCGSZyU5GjFtJuay5jjqRD-xIr3XhGu1Ek';
  static const String baseUrl = 'https://app.taraapps.com';
  // static const String baseUrl = 'https://drivemond-admin.codemond.com';
  static const String configUri = '/api/driver/configuration';
  static const String registration = '/api/driver/auth/registration';
  static const String loginUri = '/api/driver/auth/login';
  static const String logout = '/api/user/logout';
  static const String sendOtp = '/api/driver/auth/send-otp';
  static const String otpVerification = '/api/driver/auth/otp-verification';
  static const String resetPassword = '/api/driver/auth/reset-password';
  static const String changePassword = '/api/user/change-password';
  static const String onlineOfflineStatus = '/api/driver/update-online-status';
  static const String profileInfo = '/api/driver/info';
  static const String updateProfileInfo = '/api/driver/update/profile';
  static const String vehicleBrandList = '/api/driver/vehicle/brand/list?limit=20&offset=';
  static const String vehicleModelList = '/api/driver/vehicle/model/list?limit=20&offset=';
  static const String vehicleMainCategory = '/api/driver/vehicle/category/list?limit=20&offset=';
  static const String addNewVehicle = '/api/driver/vehicle/store';
  static const String geoCodeURI = '/api/driver/config/geocode-api';
  static const String getZone = '/api/driver/config/get-zone-id';
  static const String fcmTokenUpdate = '/api/driver/update/fcm-token';
  static const String tripDetails = '/api/driver/ride/details/';
  static const String uploadScreenShots = '/api/ride/store-screenshot';
  static const String tripAcceptOrReject = '/api/driver/ride/trip-action';
  static const String matchOtp = '/api/driver/ride/match-otp';
  static const String remainDistance = '/api/driver/get-routes';
  static const String tripStatusUpdate = '/api/driver/ride/update-status';
  static const String rideRequestList = '/api/driver/ride/pending-ride-list';
  static const String activityList = '/api/driver/my-activity';
  static const String bidding = '/api/driver/ride/bid';
  static const String ongoingTrip = '/api/driver/last-ride-details';
  static const String finalFare = '/api/driver/ride/final-fare';
  static const String currentRideStatus = '/api/driver/ride/ride-resume-status';
  static const String submitReview = '/api/driver/review/store';
  static const String tripList = '/api/driver/ride/list';
  static const String tripOverView = '/api/driver/ride/overview';
  static const String paymentUri = '/api/driver/ride/payment';
  static const String searchLocationUri = '/api/customer/config/place-api-autocomplete';
  static const String getDistanceFromLatLng = '/api/customer/config/distance_api';
  static const String placeApiDetails = '/api/customer/config/place-api-details';

  static const String createChannel = '/api/driver/chat/create-channel';
  static const String channelList = '/api/driver/chat/channel-list';
  static const String conversationList = '/api/driver/chat/conversation';
  static const String sendMessage = '/api/driver/chat/send-message';
  static const String notificationList = '/api/driver/notification-list?limit=10&offset=';
  static const String arrivalPickupPoint = '/api/driver/ride/arrival-time';
  static const String waitingUri = '/api/driver/ride/ride-waiting';
  static const String transactionListUri = '/api/driver/transaction/list?limit=10&offset=';
  static const String loyaltyPointListUri = '/api/driver/loyalty-points/list?limit=10&offset=';
  static const String reviewList = '/api/driver/review/list?limit=10&offset=';
  static const String saveReview = '/api/driver/review/save/';
  static const String pointConvert = '/api/driver/loyalty-points/convert';
  static const String leaderboardUri = '/api/driver/activity/leaderboard?limit=10&offset=';
  static const String dynamicWithdrawMethodList = '/api/driver/withdraw/methods?limit=20&offset=1';
  static const String withdrawRequestUri = '/api/driver/withdraw/request';
  static const String dailyActivities = '/api/driver/activity/daily-income';
  static const String trackDriverLog = '/api/driver/time-tracking';
  static const String updateLastLocationUsingSocket = '/user/live-location?appKey';
  static const String storeLastLocationAPI = '/api/user/store-live-location';
  static const String ignoreNotification = '/api/driver/ride/ignore-trip-notification';
  static const String arrivedDestination = '/api/driver/ride/coordinate-arrival';

  static const String parcelOngoingList = '/api/driver/ride/ongoing-parcel-list?limit=100&offset=1';
  static const String parcelUnpaidList = '/api/driver/ride/unpaid-parcel-list?limit=100&offset=1';






  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String deviceToken = 'deviceToken';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userNumber = 'user_number';
  static const String searchAddress = 'search_address';
  static const String localization = 'X-Localization';
  static const String topic = 'notify';
  static const String zoneId = 'zoneId';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.unitedKingdom, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.saudi, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  ];

  static const int limitOfPickedIdentityImageNumber = 2;
  static const double limitOfPickedImageSizeInMB = 2;
  static const double completionArea = 500;


}
