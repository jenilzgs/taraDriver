import 'package:ride_sharing_user_app/view/screens/ride/model/trip_details_model.dart';

class OngoingTripModel {
  String? responseCode;
  List<TripDetail>? data;


  OngoingTripModel(
      {this.responseCode,
        this.data
      });

  OngoingTripModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    if (json['data'] != null) {
      data = <TripDetail>[];
      json['data'].forEach((v) {
        data!.add(TripDetail.fromJson(v));
      });
    }
  }

}

