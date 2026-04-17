class ApiEndPoints {


  ///Local
//  static const server = "http://192.168.0.176:5000/api/";

  ///Production
  static const server = "https://packnpay.in/api/";


  static const baseurl = '${server}';


  static const sendOtp = 'auth/send-otp';
  static const  verifyOtp = "auth/verify-otp";
  static const  register = "auth/register";
  static const  quatationApi = "quotation-list";
  static const  surveylistApi = "survey-list";
  static const  prefillFormApi = "quotation/survey/";
  static const  stateApi = "get-states";
  static const  cityApi = "get-cities";
  static const  createQuotationApi = "quotation/create";
  static const  deleteQuotationApi = "quotation";
  static const  getQuotationApi = "quotation";
  static const  updateQuotationApi = "quotation/update";
  static const moneyReceiptList = "money-receipt-list";
  static const createMoneyReceipt = "money-receipt/create";
  static const orderList = "order-list";



}
