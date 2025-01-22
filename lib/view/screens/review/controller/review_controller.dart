import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/review/model/review_model.dart';
import 'package:ride_sharing_user_app/view/screens/review/repository/review_repo.dart';

class ReviewController extends GetxController implements GetxService{
  final ReviewRepo reviewRepo;

  ReviewController({required this.reviewRepo});

  int _reviewTypeIndex = 0;
  int get reviewTypeIndex => _reviewTypeIndex;

  List<String> reviewTypeList =['reviews', 'saved'];


  void setReviewIndex(int index){
    _reviewTypeIndex = index;
    if(index == 0){
      reviewModel = null;
      getReviewList(1);
    }else{
      reviewModel = null;
      getReviewList(1,1);
    }
    update();
  }

  ReviewModel? reviewModel;

  Future<void> getReviewList([int? offset, int? isSaved]) async {
    Response response;
    if(isSaved != null){
      response = await reviewRepo.getSavedReviewList(1, isSaved);
    }else{
       response = await reviewRepo.getReviewList(1);
    }
    if (response.statusCode == 200) {
      if(offset == 1){
        reviewModel = null;
        reviewModel = ReviewModel.fromJson(response.body);
      }else{
        reviewModel!.data!.addAll(ReviewModel.fromJson(response.body).data!);
        reviewModel!.offset = ReviewModel.fromJson(response.body).offset;
        reviewModel!.totalSize = ReviewModel.fromJson(response.body).totalSize;
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<Response> saveReview(String id, int index) async {
    isLoading = true;
    update();
    Response response = await reviewRepo.savedReview(id);
    if (response.statusCode == 200 ) {
      getReviewList(1, _reviewTypeIndex);
      if(reviewModel!.data![index].isSaved!){
        showCustomSnackBar('review_removed_successfully_from_saved_list'.tr, isError: false);
      }else{
        showCustomSnackBar('review_saved_successfully'.tr, isError: false);
      }
      reviewModel!.data![index].isSaved = !reviewModel!.data![index].isSaved!;

      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  bool isLoading = false;

  Future<Response> submitReview(String id, int ratting, String comment) async {
    isLoading = true;
    update();
    Response response = await reviewRepo.submitReview(id, ratting, comment);
    if (response.statusCode == 200 ) {
      Get.back();
      showCustomSnackBar('review_submitted_successfully'.tr, isError: false);
      Get.offAll(()=> const DashboardScreen());
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


}