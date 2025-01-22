import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class ReviewRepo{
  final ApiClient apiClient;

  ReviewRepo({required this.apiClient});


  Future<Response> getReviewList(int offset ) async {
    return await apiClient.getData('${AppConstants.reviewList}$offset');
  }
  Future<Response> getSavedReviewList(int offset, int isSaved ) async {
    return await apiClient.getData('${AppConstants.reviewList}$offset&is_saved=$isSaved');
  }


  Future<Response> savedReview(String id ) async {
    return await apiClient.postData('${AppConstants.saveReview}$id',{
      "_method" : 'put',
    });
  }

  Future<Response> submitReview(String id, int ratting, String comment ) async {
    return await apiClient.postData(AppConstants.submitReview,{
      "ride_request_id" : id,
      "rating" : ratting,
      "feedback" : comment
    });
  }


}