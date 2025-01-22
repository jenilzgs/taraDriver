import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class WalletRepo{
  final ApiClient apiClient;

  WalletRepo({required this.apiClient});


  Future<Response?> getTransactionList(int offset) async {
    return await apiClient.getData('${AppConstants.transactionListUri}$offset');
  }
  Future<Response?> getLoyaltyPointList(int offset) async {
    return await apiClient.getData('${AppConstants.loyaltyPointListUri}$offset');
  }


  Future<Response?> convertPoint(String point) async {
    return await apiClient.postData(AppConstants.pointConvert,{
      'points' : point
    });
  }

  Future<Response?> getDynamicWithdrawMethodList() async {
    return await apiClient.getData(AppConstants.dynamicWithdrawMethodList);
  }
  Future<Response?> withdrawBalance(List <String> typeKey, List<String> typeValue,int id, String balance, String note) async {

      Map<String, String> fields = {};

      for(var i = 0; i < typeKey.length; i++){
        fields.addAll(<String, String>{
          typeKey[i] : typeValue[i]
        });
        if (kDebugMode) {
          print('--here is type key =${typeKey.toList()}/${typeValue.toList()}');
        }
      }
      fields.addAll(<String, String>{
        'amount': balance,
        'withdraw_method': id.toString(),
        'note': note
      });

      Response response = await apiClient.postData(
          AppConstants.withdrawRequestUri, fields);

      return response;

  }

}