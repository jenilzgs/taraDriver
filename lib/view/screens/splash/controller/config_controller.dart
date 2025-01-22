import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/screens/splash/model/config_model.dart';
import 'package:ride_sharing_user_app/view/screens/splash/repo/config_repo.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfigController extends GetxController implements GetxService {
  final ConfigRepo configRepo;
  ConfigController({required this.configRepo});

  ConfigModel? _config;

  ConfigModel? get config => _config;

  bool loading = false;
  Future<bool> getConfigData({bool reload= false}) async {
    loading = true;
    Response response = await configRepo.getConfigData();
    bool isSuccess = false;
    if(response.statusCode == 200) {
      isSuccess = true;
      loading = false;
      _config = ConfigModel.fromJson(response.body);
    }else {
      loading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return configRepo.initSharedData();
  }



  Future<bool> removeSharedData() {
    return configRepo.removeSharedData();
  }

  final Uri params = Uri(
    scheme: 'mailto',
    path: '',
    query: 'subject=support Feedback&body=',
  );

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future<void> sendMailOrCall(String url, bool isMail) async {
    if (!await launchUrl(Uri.parse(isMail? params.toString() :url))) {
      throw 'Could not launch $url';
    }
  }

}