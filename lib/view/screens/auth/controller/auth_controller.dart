import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/auth/model/signup_body.dart';
import 'package:ride_sharing_user_app/view/screens/auth/repository/auth_repo.dart';
import 'package:ride_sharing_user_app/view/screens/auth/sign_in_screen.dart';
import 'package:ride_sharing_user_app/view/screens/auth/widgets/approve_dialog.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/forgot_password/reset_password_screen.dart';
import 'package:ride_sharing_user_app/view/screens/forgot_password/verification_screen.dart';
import 'package:ride_sharing_user_app/view/screens/location/view/access_location_screen.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_snackbar.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  bool _isLoading = false;
  bool _acceptTerms = false;
  AuthController({required this.authRepo});
  bool get isLoading => _isLoading;
  bool get acceptTerms => _acceptTerms;
  final String _mobileNumber = '';
  String get mobileNumber => _mobileNumber;
  XFile? _pickedProfileFile ;
  XFile? get pickedProfileFile => _pickedProfileFile;
  XFile identityImage = XFile('');
  List<XFile> identityImages = [];
  List<MultipartBody> multipartList = [];
  String countryDialCode = '+63';

  void setCountryCode(String code){
    countryDialCode = code;
    update();
  }

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();

  FocusNode fNameNode = FocusNode();
  FocusNode lNameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode identityNumberNode = FocusNode();

  void pickImage(bool isBack, bool isProfile) async {
       if(isProfile){
        _pickedProfileFile = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
      } else{
         identityImage = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
         identityImages.add(identityImage);
         multipartList.add(MultipartBody('identity_images[]', identityImage));
      }
    update();
  }

  void removeImage(int index){
    identityImages.removeAt(index);
    update();
  }

  final List<String> _identityTypeList = ['passport', 'driving_licence', 'nid', ];
  List<String> get identityTypeList => _identityTypeList;
  String _identityType = '';
  String get identityType => _identityType;

  void setIdentityType (String setValue){
    _identityType = setValue;
    update();
  }


  Future<void> login(String countryCode, String phone, String password) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.login( phone: countryCode.trim()+phone, password: password);
    if(response!.statusCode == 200){
      Map map = response.body;
      String token = '';
      token = map['data']['token'];
      setUserToken(token);

      updateToken().then((value) {
        _navigateLogin(countryCode, phone,password);
      });
      _isLoading = false;
    }else if(response.statusCode == 202){
      if(response.body['data']['is_phone_verified'] == 0){
        Get.to(()=> VerificationScreen(countryCode: countryCode, number: phone, from: 'login',));
      }
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  bool logging = false;
  Future<void> logOut() async {
    logging = true;
    update();
    Response? response = await authRepo.logOut();
    if(response!.statusCode == 200){
      Get.find<RideController>().updateRoute(false, notify: true);
      Get.find<ProfileController>().stopLocationRecord();
      logging = false;
      Get.back();
      Get.offAll(()=> const SignInScreen());
      showCustomSnackBar('successfully_logout'.tr, isError: false);
    }else{
      logging = false;
      ApiChecker.checkApi(response);
    }
    update();
  }




  Future<void> register(String code, SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.registration(signUpBody: signUpBody,profileImage: pickedProfileFile,identityImage: multipartList);
    if(response.statusCode == 200){
      fNameController.clear();
      lNameController.clear();
      passwordController.clear();
      phoneController.clear();
      confirmPasswordController.clear();
      emailController.clear();
      addressController.clear();
      identityNumberController.clear();
      _pickedProfileFile = null;
      identityImages.clear();
      multipartList.clear();
      _isLoading = false;

      print('----------registre------> ${Get.find<ConfigController>().config!.verification!}');
      if(Get.find<ConfigController>().config?.verification ?? false){
        Get.to(()=> VerificationScreen(countryCode : code, number: signUpBody.phone?.replaceAll(code, '') ?? '', from: 'signup',));
      }else{
        showCustomSnackBar('registration_completed_successfully'.tr, isError: false);
        Get.offAll(()=> const SignInScreen());
      }
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }


  _navigateLogin(String code,String phone, String password){
    if (_isActiveRememberMe) {
      saveUserNumberAndPassword(phone, password);
    } else {
      clearUserNumberAndPassword();
    }
    Get.find<ProfileController>().getProfileInfo().then((value){
      if(value.statusCode == 200){
        if(Get.find<AuthController>().getZoneId() == ''){
          Get.offAll(()=> const AccessLocationScreen());
        }else{
          Get.offAll(()=> const DashboardScreen());
        }
      }
    });
  }



  Future<Response> sendOtp({required String countryCode, required String phone}) async{
    _isLoading = true;
    update();
    Response? response = await authRepo.sendOtp(phone: '$countryDialCode$phone');
    print("responseOTP==${response?.body}");
    if(response!.statusCode == 200){
      _isLoading = false;
      showCustomSnackBar('otp_sent_successfully'.tr, isError: false);
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> otpVerification(String code, String phone, String otp,  {String password = '', required String from}) async{
    _isLoading = true;
    update();

    String phoneNumber = '$code$phone';

    Response? response = await authRepo.verifyOtp(phone: phoneNumber, otp: otp);

    print("responseOtpVeri==${response?.body}");
    if(response!.statusCode == 200){
      clearVerificationCode();
      _isLoading = false;
      if(from == 'signup'){
        showDialog(context: Get.context!, builder: (_)=> ApproveDialog(
            icon: Images.waitForVerification,
            description: 'create_account_approve_description'.tr,
            title: 'registration_not_approve_yet'.tr,
            onYesPressed: (){
              Get.offAll(()=> const SignInScreen());
            }), barrierDismissible: false);
      }else if(from == 'login'){
        Map map = response.body;
        String token = '';
        token = map['data']['token'];
        setUserToken(token);
        _isLoading = false;
        updateToken().then((value){
          _navigateLogin(code, phone,password);
        });
      }else{
        Get.to(()=> ResetPasswordScreen(phoneNumber: phoneNumber));
      }
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }



  Future<void> forgetPassword(String phone) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.forgetPassword(phone);
    if (response!.statusCode  == 200) {
      _isLoading = false;
      customSnackBar('successfully_sent_otp'.tr, isError: false);
    }else{
      _isLoading = false;
      customSnackBar('invalid_number'.tr);
    }
    update();
  }


  Future<void> resetPassword(String phone, String password) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.resetPassword(phone, password);
    if (response!.statusCode == 200) {
      customSnackBar('password_change_successfully'.tr, isError: false);
      Get.offAll(()=> const SignInScreen());
    }else{
      customSnackBar(response.body['message']);
    }
    _isLoading = false;
    update();
  }


  Future<void> changePassword(String password, String newPassword) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.changePassword(password, newPassword);
    if (response!.statusCode == 200) {
      customSnackBar('password_change_successfully'.tr, isError: false);
      Get.offAll(()=> const DashboardScreen());
    }else{
      customSnackBar(response.body['message']);
    }
    _isLoading = false;
    update();
  }




  bool updateFcm = false;
  Future<void> updateToken() async {
    updateFcm = true;
    update();
    Response? response =  await authRepo.updateToken();
    if(response?.statusCode == 200){
      updateFcm = false;
    }else{
      updateFcm = false;
      ApiChecker.checkApi(response!);
    }
    update();
  }



  String _verificationCode = '';
  String _otp = '';
  String get otp => _otp;
  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    if(_verificationCode.isNotEmpty){
      _otp = _verificationCode;
    }
    update();
  }

  void clearVerificationCode(){
    updateVerificationCode('');
    _verificationCode = '';
    update();
  }


  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void setRememberMe() {
    _isActiveRememberMe = true;
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future<bool> clearSharedData() async{
    return authRepo.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  String getUserNumber() {
    return authRepo.getUserNumber();
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode();
  }

  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  bool isNotificationActive() {
    return authRepo.isNotificationActive();
  }

  toggleNotificationSound(){
    authRepo.toggleNotificationSound(!isNotificationActive());
    update();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  String getDeviceToken() {
    return authRepo.getDeviceToken();
  }

  Future <void> setUserToken(String token) async{
     authRepo.saveUserToken(token, getZoneId());
  }


  Future <void> updateZoneId(String zoneId) async{
    authRepo.updateZone(zoneId);
  }

  String getZoneId() {
    return authRepo.getZonId();
  }
}