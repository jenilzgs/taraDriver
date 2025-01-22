import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocationRepo {
  final ApiClient
  apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.getZone}?lat=$lat&lng=$lng');
  }

  Future<bool?> saveUserZoneId(String zoneId) async {
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.token)??'', sharedPreferences.getString(AppConstants.languageCode), 'latitude', 'longitude', zoneId);
    return await sharedPreferences.setString(AppConstants.zoneId, zoneId);
  }



  Future<Response> getAddressFromGeocode(LatLng? latLng) async {
    return await apiClient.getData('${AppConstants.geoCodeURI}?lat=${latLng!.latitude}&lng=${latLng.longitude}');
  }

  Future<Response> searchLocation(String text) async {
    return await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text');
  }


  Future<Response> getPlaceDetails(String placeID) async {
    return await apiClient.getData('${AppConstants.placeApiDetails}?placeid=$placeID');
  }

  Future<Response> storeLastLocationApi(String lat, String lng, String zoneID) async {
    return await apiClient.postData(AppConstants.storeLastLocationAPI,
        {"user_id": "${Get.find<ProfileController>().profileInfo?.id}",
          "type": "driver",
          "latitude": lat,
          "longitude": lng,
          "zone_id": zoneID});
  }

}
