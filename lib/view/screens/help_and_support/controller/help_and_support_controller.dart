
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/screens/help_and_support/repository/help_and_support_repository.dart';

class HelpAndSupportController extends GetxController implements GetxService{
  final HelpAndSupportRepo helpAndSupportRepo;

  HelpAndSupportController({required this.helpAndSupportRepo});



  List<String> helpAndSupportTypeList = ['regular', 'legal', 'policy'];
  int _helpAndSupportIndex = 0;
  int get helpAndSupportIndex => _helpAndSupportIndex;

  void setHelpAndSupportIndex(int index){
    _helpAndSupportIndex = index;
    update();
  }




}