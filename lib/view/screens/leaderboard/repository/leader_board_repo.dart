import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class LeaderBoardRepo{
  final ApiClient apiClient;

  LeaderBoardRepo({required this.apiClient});


  Future<Response?> getLeaderboardList(int offset) async {
    return await apiClient.getData('${AppConstants.leaderboardUri}$offset');
  }

  Future<Response?> getDailyActivity() async {
    return await apiClient.getData(AppConstants.dailyActivities);
  }


}