import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';



class NoDataScreen extends StatelessWidget {
  final String? title;
  final bool fromHome;
  const NoDataScreen({super.key, this.title, this.fromHome = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(fromHome?  Images.initTrip : Images.noDataFound, width: 100, height: 100, color: fromHome? null : Theme.of(context).primaryColor,),
          Text(title != null? title!.tr : 'no_data_found'.tr,
            style: textRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: MediaQuery.of(context).size.height*0.023),
            textAlign: TextAlign.center,
          ),

        ]),
      ),
    );
  }
}
