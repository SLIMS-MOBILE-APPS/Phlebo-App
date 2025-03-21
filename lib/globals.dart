String completed = "";
String flag = "";
String status = "";
String customer_name = "";
String order_no = "";
String customer_mobile_no = "";
String order_date = "";
String schedule_dt = "";
String CHANNEL = "";
String REFERAL_DOCTOR = "";
String customer_address = "";
String service_name = "";
String PAID_AMOUNT = "";
String outstanding_due = "";
String customer_gender = "";
String customer_age = "";
String DISPLAY_NAME = "";
String USER_NAME = "";
String PASSWORD = "";
String USER_ID = "";
String selectDate = "";
String REFERENCE_ID = "";
String order_id = "";
String assign_phlebotomist_id = "";
String gender = "";
String Mobile_Number = "";
String? Selected_Title;
String? Selected_Auth;
String? Selected_Pincode;
String? Area_NAME;

String glb_Order_Checking_status = "";

String Selected_Date = "";
String LOCATIONID = "";
String user_name = "";
String umr_no = "";
String option = "";
// String Channel = "";
String SESSION_ID = "";
String session_id = "";

String family_members_uid = "";
String family_members_area_name = "";
String family_members_user_name = "";
String family_members_user_dob = "";
String family_members_age = "";
String family_members_user_phone = "";
String family_members_gender = "";
String family_members_user_email = "";
String family_members_user_address = "";
String family_members_umr_no = "";
String family_members_city_id = "";
String family_members_carea_id = "";
String Regisered_Name = "";
String Regisered_Mail = "";
String Regisered_Mobile = "";
String Regisered_Gender = "";
String Regisered_Age = "";
String PRICES = "";
String SERVICE_IDS = "";
String order_url = "";
String SPECIMEN_IDS = "";
String glb_IS_DISCOUNT_NEED = "";
String glob_IS_REQ_BARCODE_BILLNO = "";
String VACCUTAINER_IDS = "";
String SERVICE_NAME = "";
String DUE_BILL = "";
String PRICE = "";
String customer_id = "";
String LOCATION_NAME = "";

var Price_new_order = null;
var total_price = '0';
var barcode = "";
var vac_count = "";
String age = "";
String cancelled_reason = "";
String rejection_reason = "";
String registraion_data = "";

String SERVICE_ID_by_new_order = "";
String SERVICE_ID_by_new_order_with_all_Service_id = "";
String SPECIMEN_ID_by_new_order = "";
String VACCUTAINER_ID_by_new_order = "";
String SERVICE_NAME_by_new_order = "";
String SPECIMEN_NAME_by_new_order = "";
String VACCUTAINER_by_new_order = "";
String visible = "";

String PHLEBO_PENDING_CNT = "";
String REJECT_CNT = "";
String CANCEL_CNT = "";
String COMPLETED_CNT = "";
String TOTAL_CNT = "";

String Cancel_SERVICE_ID = "";

String schedule_address = "";

String Service_Id_Add_Test = "";
String COMPANY_NAME = "";
String COMPANY_ID = "";

var Billing_pricenew = "";
var Billing_serviceids = "";

var Billing_servicePrice = "";
var existing_dataset = [];
var Glb_myOrderList = [];
var Billing_servicespec = "";
var Billing_servicevacs = "";

String Barcode_for_New_Order = "";
String VACCUTAINER_CUNT_for_New_Order = "";
String REF_DOCTOR_DESIGNATION = "";

String EndDrawer = "";
String AGENCY_ID = "";
var flag_check = "";

//////////////////////dropdown

// globals.SESSION_ID

String ID = "";
String LOCATION_ID = "";

String LOC_ID = "";
String LOCATION_ID_new_order = "";
String AREA_ID = "";
String REFRL_ID = "";
String discount_policy_id = "";
String REFERAL_SOURCE_ID = "";
String CLIENT_ID = "";
String DISCOUNT_POLICY_ID = "";
String SRV_NET_PRICE = "";
String AUTH_NAME = "";
String Service_Id_Add_Price = "";
String AUTH_ID = "";
String selected_date = "";

//..........................................
String Report_URL = ""; //report url coming from data base.
String Connection_Flag = "";
String Logo = "";
String API_url = "";
String API_url_Main_login = "https://mobileappjw.softmed.in";
String Client_Name = "";

String mobile_no = "";
String refferal_name = "";
String registration_no = "";
String payment_mode = "";
String permanent_dr = "";
int onlinePrice = 0;
var Scannned_Code = "";
var glb_Total_Vaccutainer_Value = 0;
var glb_ConcessionPlusCash = 0.0;
var glb_ConcessionAmount = 0.0;
var glb_ConcessionPercentage = 0.0;
var glb_PercentageAmount = 0.0;
String glb_manualbarcode = "";
String glb_REFERAL_NAME = "";
String glb_Selected_Employee_Id = "";
String glb_REFERAL_SOURCE_ID = "";
String REFERAL_NAME = "";
String no_use_glb = "";
String Glb_Bill_Validation_Controller = "";

String glb_IMG_PATH = "";

bool readonly = false;

// String API_url = "http://115.112.254.129/TESTING_SERVER_PHLEBO";

var PaymentMode = 0;
var glb_Card_Cash_Saving_Amount = 0;
String Geolocateor_Longitude = "";
String Geolocator_Latitude = "";
String Selected_Due_Auth = "";
String glb_IS_REQ_DUE = "";
var glb_Due_Amount = 0;
String Selected_Due_Auth_NAME = "";
String Selected_Due_Auth_Id = "";
String Glb_CLASS_SERVICE_ID = "";
String glb_IS_REQ_Reject = "";
bool package = false;
var packageList = [];
String Glb_Payment_Id = "";
String Glb_Order_Id = "";
String glb_bill_id = "";
String Glb_IS_CARD_NEED = "";
String Glb_Payment_Message = "";
String Glb_Is_Req_Wallet = "";
String Glb_Payment_Code = "";
String Glb_Payment_Error = "";

String Glb_Payment_Key = "";
String Glb_Payment_Marchant_Name = "";
String Glb_Payment_Marchant_Contact_No = "";
String Glb_Payment_Marchant_Email_Id = "";

String Glb_barcodeResult_Variable = "";
String Glb_QR_Scaner_SERVICE_ID = "";
String Glb_IS_REQ_BARCODE_Scan_Manual = "";
String Glb_NAVIGATION = "";
String merchantId_Value = "";
String bdOrderId_Value = "";
String authToken_Value = "";
String returnUrl_Value = "";
String glb_umr_no = "";
//..........................................................................
var glb_transaction_list = [];
String glb_amount = "";
String glb_transactionlogid = "";
String glb_transactionNumber = "";
String glb_Approved_Value = "";
String glb_service_name = "";
String glb_QR_IMG = "";
String Glb_LOCATION_QR = "";
String Glb_DUE_RECOVERED = "";

//billdesk
String Glb_auth_status_Value = "";

String Glb_transactionid = "";

String Glb_glb_orderid = "";

String Glb_transaction_date = "";
String glb_selectedPaymentMethod = "";
String PAID_AMOUNT_VALIDATION = "";
