//
//  UrlModel.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 12.07.2021.
//

import Foundation

public final class UrlCollection{
    
    public static var BASE_URL : String = "https://www.gorvodokanal.com/mobile_app/"
      public static var  KOD : String = "10-6666666"

      public static  var AUTH_URL: String = BASE_URL + "auth.php"
    
    public static  var GENERAL_INFO_URL : String = BASE_URL + "general_info.php"
    
      public static  var CHANGE_PASSWORD_URL: String = BASE_URL + "change_password.php"
      public static  var CHANGE_EMAIL_URL : String = BASE_URL + "change_email.php"
      public static  var HISTORY_METERS : String = BASE_URL + "history_meters.php"
      public static  var PASS_METERS : String = BASE_URL + "pass_meters.php"
      public static  var SET_METERS : String =  BASE_URL + "set_meters.php"
      public static  var PAYMENT_METERS : String =  BASE_URL + "payment_meters.php"
      public static  var PAYMENT_GENERATE_URL: String =  BASE_URL + "payment_url_generation.php"
      public static  var REGISTRATION_URL : String =  BASE_URL + "registration_iOS.php"
      public static  var RESENDING_URL: String =  BASE_URL + "resendingMail.php"
      public static  var RECOVERY_URL : String =  BASE_URL + "recovery.php"
      public static  var GET_USER_INFO_URL : String =  BASE_URL + "user_get_info.php"
      public static  var GET_STATUS_CONFIRM_EMAIL: String =  BASE_URL + "confirm_email.php"
      public static  var EMAIL_SEND_CONFIRM: String =  BASE_URL + "emailSendConfirm.php"
      public static  var SWITH_ACCOUNT: String =  BASE_URL + "re-authorization.php"
      public static  var GET_INFO_SUPPORT: String =  BASE_URL + "getSupportAsk.php"
      public static  var SET_DATA_QUESTION : String =  BASE_URL + "setDataQuestion.php"
      public static  var BILDING_LS : String =  BASE_URL + "bindingLs.php"
      public static  var GET_BINDING_LS : String =  BASE_URL + "getBindLs.php"
      public static  var REMOVE_BINDING_LS: String =  BASE_URL + "removeBindingLs.php"
      public static  var CONFIRM_EMAIL: String =  BASE_URL + "confirm_email.php"
      public static  var GET_USER_DATA : String =  BASE_URL + "get_data_user.php"
    
    public static var REMOVE_ACCOUNT: String = BASE_URL + "removeAccount.php"
    
    
}
