class TripOverView {
  double? successRate;
  int? totalTrips;
  double? totalEarn;
  int? totalCancel;
  int? totalReviews;
  IncomeStat? incomeStat;

  TripOverView(
      {this.successRate,
        this.totalTrips,
        this.totalEarn,
        this.totalCancel,
        this.totalReviews,
        this.incomeStat});

  TripOverView.fromJson(Map<String, dynamic> json) {
    successRate = json['success_rate'].toDouble();
    totalTrips = json['total_trips'];
    totalEarn = json['total_earn'].toDouble();
    totalCancel = json['total_cancel'];
    totalReviews = json['total_reviews'];
    incomeStat = json['income_stat'] != null
        ? IncomeStat.fromJson(json['income_stat'])
        : null;
  }
}

class IncomeStat {
  double? sun;
  double? mon;
  double? tues;
  double? wed;
  double? thu;
  double? fri;
  double? sat;

  IncomeStat(
      {this.sun, this.mon, this.tues, this.wed, this.thu, this.fri, this.sat});

  IncomeStat.fromJson(Map<String, dynamic> json) {
    sun = json['Sun'].toDouble();
    mon = json['Mon'].toDouble();
    tues = json['Tues'].toDouble();
    wed = json['Wed'].toDouble();
    thu = json['Thu'].toDouble();
    fri = json['Fri'].toDouble();
    sat = json['Sat'].toDouble();
  }
}
