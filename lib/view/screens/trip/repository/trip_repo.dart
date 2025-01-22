import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class TripRepo{
  final ApiClient apiClient;
  TripRepo({required this.apiClient});




  Future<Response> getTripList(String tripType, String from, String to, int offset, String filter) async {
    return await apiClient.getData('${AppConstants.tripList}?type=$tripType&limit=10&offset=$offset&filter=$filter');
  }

  Future<Response> paymentSubmit(String tripId, String paymentMethod ) async {
    return await apiClient.getData('${AppConstants.paymentUri}?trip_request_id=$tripId&payment_method=$paymentMethod');
  }
  Future<Response> getTripOverView(String filter) async {
    return await apiClient.getData('${AppConstants.tripOverView}?filter=$filter');
  }


}