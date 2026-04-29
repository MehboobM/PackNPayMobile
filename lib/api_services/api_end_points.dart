class ApiEndPoints {


  ///Local
  /*static const server = "http://192.168.0.247:5000/api/";*/
  /*static const server = "http://192.168.0.246:5000/api/";*/


  ///Production
  static const server = "https://packnpay.in/api/";


  static const baseurl = '${server}';


  static const sendOtp = 'auth/send-otp';
  static const  verifyOtp = "auth/verify-otp";
  static const  register = "auth/register";
  static const  quatationApi = "quotation-list";
  static const  surveylistApi = "survey-list";
  static const  prefillFormApi = "quotation/survey/";
  static const  prefillOrderFormApi = "order/prefill";
  static const  createOrder = "order/create";
  static const  getOrderByUid = "order";
  static const  updateOrder = "order/update";
  static const  uploadMedia = "order/media";
  static const  updateOrderStatus = "order/status";
  static const  generateEncoded = "survey/generate-encoded";

  static const  stateApi = "get-states";
  static const  cityApi = "get-cities";
  static const  createQuotationApi = "quotation/create";
  static const  deleteQuotationApi = "quotation";
  static const  getQuotationApi = "quotation";
  static const  updateQuotationApi = "quotation/update";
  static const moneyReceiptList = "money-receipt-list";
  static const createMoneyReceipt = "money-receipt/create";
  static const orderList = "order-list";

  static const userList = "user-list";
  static const createUser = "user/create";
  static const toggle ="user/toggle-status/";
  static const String lrList = "lr-list";
  static const String getAllCities = "get-all-cities";
  static const String getStates = "get-states";
  static const String getCitiesByState = "get-cities";
  static const String createLorryReceipt = "lr/create";
  static String getLorryReceiptByUid(String uid) =>
      "lr?uid=$uid";

  static String updateLorryReceipt(String uid) =>
      "lr/update/$uid";

  static String deleteLorryReceipt(String uid) =>
      "lr/$uid";
  static const String prefillByOrderNo =
      "lr/prefill-order/";
  static const String getSettings = "settings";
  static const String updateWatermarkSettings = "settings/watermark";
  static const String updateLetterHeadSettings = "settings/letterhead";
  static const String updateQuotationSettings =
      "settings/quotation";

  static const String updateLRSettings =
      "settings/lr";
  static const String createSupportTicket = "support/create";
  static const String getMySupportTickets = "support/my-tickets";
  static const String getSummaray = "dashboard/summary";
  static const String getActions = "dashboard/actions";
  static const String getupcomingOrders = "dashboard/upcoming-orders";
  static const String getcalender= "dashboard/calendar";
  static const String subscription = "subscription/current";
  static const String subscriptionHistory = "subscription/history";



  static const String setFollowUp = "dashboard/create-action";



}
