import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/trip_details_model.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/model/trip_model.dart';
import 'package:ride_sharing_user_app/view/screens/trip/model/trip_overview_model.dart';
import 'package:ride_sharing_user_app/view/screens/trip/repository/trip_repo.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widget/review_this_customer_screen.dart';

class TripController extends GetxController implements GetxService{
  final TripRepo tripRepo;

  TripController({required this.tripRepo});

   bool customerReviewed = false;
  List<TripDetail> tripList = [];
  bool isLoading = false;


   void toggleReviewed(){
     customerReviewed = true;
     update();
   }


   List<String> activityTypeList = ['trips', 'over_view'];
   int activityTypeIndex = 0;
   void setActivityTypeIndex(int index){
     activityTypeIndex = index;
     update();
   }


  List<String> selectedFilterType = ['today', 'this_month', 'this_year'];
  String _selectedFilterTypeName = 'today';
  String get selectedFilterTypeName => _selectedFilterTypeName;
  void setFilterTypeName(String name){
    tripModel = null;
    _selectedFilterTypeName = name;
    getTripList(1, '', '', 'ride_request', selectedFilterTypeName);
    update();
  }


  TripModel? tripModel;
  Future<Response> getTripList(int offset, String from, String to, String tripType, String filter) async {
    isLoading = true;

    Response response = await tripRepo.getTripList(tripType, from, to, offset, filter);
    if (response.statusCode == 200) {
      isLoading = false;
      if(offset == 1){
        tripModel = TripModel.fromJson(response.body);
        update();
      }else{
        tripModel!.data!.addAll(TripModel.fromJson(response.body).data!);
        tripModel!.offset = TripModel.fromJson(response.body).offset;
        tripModel!.totalSize = TripModel.fromJson(response.body).totalSize;
      }


    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  List<String> selectedOverviewType = ['this_week', 'previous_week'];
  String selectedOverview = 'this_week';
  void setOverviewType(String name){
    selectedOverview = name;
    getTripOverView(selectedOverview);
    update();
  }

  List<double> weekList = [0,0,0,0,0,0,0,0];
  List<FlSpot> earningChartList = [];
  double maxValue = 0;

  TripOverView? tripOverView;
  Future<void> getTripOverView(String filter) async {
    Response response = await tripRepo.getTripOverView(filter);
    if (response.statusCode == 200) {
      weekList = [];
      earningChartList = [];
      weekList.clear();
      earningChartList.clear();
      tripOverView = TripOverView.fromJson(response.body);
      weekList.insert(0, 0);
      weekList.insert(1, double.parse(tripOverView!.incomeStat!.sun!.toStringAsFixed(2)));
      weekList.insert(2, double.parse(tripOverView!.incomeStat!.mon!.toStringAsFixed(2)));
      weekList.insert(3, double.parse(tripOverView!.incomeStat!.tues!.toStringAsFixed(2)));
      weekList.insert(4, double.parse(tripOverView!.incomeStat!.wed!.toStringAsFixed(2)));
      weekList.insert(5, double.parse(tripOverView!.incomeStat!.thu!.toStringAsFixed(2)));
      weekList.insert(6, double.parse(tripOverView!.incomeStat!.fri!.toStringAsFixed(2)));
      weekList.insert(7, double.parse(tripOverView!.incomeStat!.sat!.toStringAsFixed(2)));
      earningChartList = weekList.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList();
      maxValue = weekList.reduce(max);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }




  Future<Response> paymentSubmit(String tripId, String paymentMethod , {fromSenderPayment = false}) async {
    isLoading = true;
    update();
    Response response = await tripRepo.paymentSubmit(tripId, paymentMethod);
    if (response.statusCode == 200 ) {
      if(fromSenderPayment){
        Get.find<RideController>().getRideDetails(tripId).then((value) {
          if(value.statusCode == 200)
          {
            Get.find<RideController>().updateRoute(false, notify: true);
            Get.offAll(()=> const MapScreen());
          }
        });

      }else{
        showCustomSnackBar('payment_successful'.tr, isError: false);
        if(Get.find<ConfigController>().config!.reviewStatus!){
          Get.offAll(()=> ReviewThisCustomerScreen(tripId: tripId));
        }else{
          Get.offAll(()=> const DashboardScreen());
        }
      }



      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


}