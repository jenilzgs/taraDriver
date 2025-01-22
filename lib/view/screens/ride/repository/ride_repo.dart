import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class RideRepo{
  ApiClient apiClient;
  RideRepo({required this.apiClient});



  Future<Response> bidding(String tripId, String amount) async {
    return await apiClient.postData(AppConstants.bidding,{
      "trip_request_id" : tripId,
      "bid_fare" : amount
    });
  }



  Future<Response> getRideDetails(String tripId) async {
    return await apiClient.getData('${AppConstants.tripDetails}$tripId');
  }

  Future<Response> uploadScreenShots(String id, XFile? file) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'trip_request_id': id
    });

    return await apiClient.postMultipartData(AppConstants.uploadScreenShots,
      fields,
      [],
        MultipartBody('file', file),
      []
    );
  }

  Future<Response> getRideDetailBeforeAccept(String tripId) async {
    return await apiClient.getData('${AppConstants.tripDetails}$tripId?type=overview');
  }
  Future<Response> tripAcceptOrReject(String tripId, String type) async {
    return await apiClient.postData(AppConstants.tripAcceptOrReject,{
      "trip_request_id": tripId,
      "action" : type
    });
  }

  Future<Response> ignoreMessage(String tripId) async {
    return await apiClient.postData(AppConstants.tripAcceptOrReject,{
      "trip_request_id": tripId
    });
  }

  Future<Response> matchOtp(String tripId, String otp) async {
    print("trip otp");
    return await apiClient.postData(AppConstants.matchOtp,{
      "trip_request_id": tripId,
      "otp" : otp
    });
  }

  Future<Response> remainDistance(String id) async {
    return await apiClient.postData(AppConstants.remainDistance,
    {
      "trip_request_id": id,
    });
  }

  Future<Response> tripStatusUpdate(String status, String id) async {
    return await apiClient.postData(AppConstants.tripStatusUpdate,
        {
          "status": status,
          "trip_request_id" : id,
          "_method" : 'put'
        });
  }

  Future<Response> getPendingRideRequestList(int offset) async {
    return await apiClient.getData('${AppConstants.rideRequestList}?limit=10&offset=$offset');
  }

  Future<Response> ongoingTripRequest() async {
    return await apiClient.postData(AppConstants.ongoingTrip, {
      'status' : 'last_trip',
      'trip_type' : 'ride_request'
    });
  }

  Future<Response> getFinalFare(String tripId) async {
    return await apiClient.getData('${AppConstants.finalFare}?trip_request_id=$tripId');
  }

  Future<Response> currentRideStatus() async {
    return await apiClient.getData(AppConstants.currentRideStatus);
  }

  Future<Response> arrivalPickupPoint(String tripId) async {
    return await apiClient.postData(AppConstants.arrivalPickupPoint,
        {
          "trip_request_id" : tripId,
          "_method" : "put"
        });
  }

  Future<Response> arrivalDestination(String tripId, String destination) async {
    return await apiClient.postData(AppConstants.arrivedDestination,
        {
          "trip_request_id" : tripId,
          "is_reached": destination,
          "_method" : "put"
        });
  }

  Future<Response> waitingForCustomer (String tripId, String status) async {
    return await apiClient.postData(AppConstants.waitingUri,
        {
          "waiting_status": status,
          "trip_request_id" : tripId,
          "_method" : "put"
        });
  }

  Future<Response> getOnGoingParcelList(int offset) async {
    return await apiClient.getData(AppConstants.parcelOngoingList);
  }
  Future<Response> getUnpaidParcelList(int offset) async {
    return await apiClient.getData(AppConstants.parcelUnpaidList);
  }

}