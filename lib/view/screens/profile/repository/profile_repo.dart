import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/view/screens/profile/widget/vehicle_body.dart';

class ProfileRepo {
  ApiClient apiClient;
  ProfileRepo({required this.apiClient});


  Future<Response?> profileOnlineOffline() async {
    return await apiClient.postData(AppConstants.onlineOfflineStatus,
        {});
  }

  Future<Response?> getProfileInfo() async {
    return await apiClient.getData(AppConstants.profileInfo);
  }
  Future<Response?> dailyLog() async {
    return await apiClient.getData(AppConstants.trackDriverLog);
  }

  Future<Response?> getVehicleModelList(int offset) async {
    return await apiClient.getData('${AppConstants.vehicleModelList}$offset');
  }


  Future<Response?> getVehicleBrandList(int offset) async {
    return await apiClient.getData('${AppConstants.vehicleBrandList}$offset');
  }
  Future<Response?> getCategoryList(int offset) async {
    return await apiClient.getData('${AppConstants.vehicleMainCategory}$offset');
  }

  Future<Response?> addNewVehicle(VehicleBody vehicleBody, List<MultipartDocument> file ) async {
    return await apiClient.postMultipartData(
        AppConstants.addNewVehicle,
        vehicleBody.toJson(),
        [],
        null,
        file

    );
  }
  Future<Response?> updateProfileInfo(String firstName, String lastname,String email, XFile? profile) async {
    Map<String, String> fields = {};

    fields.addAll(<String, String>{
      '_method': 'put',
      'first_name': firstName,
      'last_name': lastname,
      'email':email
    });
    return await apiClient.postMultipartData(AppConstants.updateProfileInfo,
        fields,
        [],
        MultipartBody('profile_image', profile),
        []
    );
  }

}