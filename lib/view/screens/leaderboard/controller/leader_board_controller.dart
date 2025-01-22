import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/view/screens/leaderboard/model/leaderboard_model.dart';
import 'package:ride_sharing_user_app/view/screens/leaderboard/repository/leader_board_repo.dart';

class LeaderBoardController extends GetxController implements GetxService{
  final LeaderBoardRepo leaderBoardRepo;
  LeaderBoardController({required this.leaderBoardRepo});

  bool isLoading = false;
  LeaderBoardModel? leaderBoardModel;
  Future<Response> getLeaderboardList(int offset) async {
    isLoading = true;
    Response? response = await leaderBoardRepo.getLeaderboardList(offset);
    if (response!.statusCode == 200) {
      if(offset == 1){
        leaderBoardModel = LeaderBoardModel.fromJson(response.body);
      }else{
        leaderBoardModel!.data!.addAll(LeaderBoardModel.fromJson(response.body).data!);
        leaderBoardModel!.offset = LeaderBoardModel.fromJson(response.body).offset;
        leaderBoardModel!.totalSize = LeaderBoardModel.fromJson(response.body).totalSize;
      }
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  String totalIncome = '0';
  int totalTrip = 0;
  Future<Response> getDailyActivities() async {
    isLoading = true;
    Response? response = await leaderBoardRepo.getDailyActivity();
    if (response!.statusCode == 200) {
      totalIncome = response.body['total_income'].toString();
      totalTrip = response.body['total_trip'];
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

}