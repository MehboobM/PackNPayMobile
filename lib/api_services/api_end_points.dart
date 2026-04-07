class ApiEndPoints {


  ///Local
//  static const server = "http://192.168.0.176:5000/api/";

  ///Production
  static const server = "http://packnpay.in/api/";


  static const baseurl = '${server}';


  static const sendOtp = 'auth/send-otp';
  static const  verifyOtp = "auth/verify-otp";
  static const  register = "auth/register";
  static const  quatationApi = "quotation-list";
  static const  surveylistApi = "survey-list";
  static const  stateApi = "get-states";
  static const  cityApi = "get-cities";


}
