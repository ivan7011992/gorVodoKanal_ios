//
//  PaymentMeterData.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 17.08.2021.
//

import Foundation
import SwiftyJSON
import  UIKit




struct PaymentMeterData{
    var id: String
    var deptPeriodBegin : Double
    var accruedPeriodValue : Double
    var paymentPeriodValue: Double
    var deptPeriodEndValue:Double
    var nameUslugi:String
    var vidUslugi:String
    
    }

extension  PaymentMeterData{
    init (json :JSON){
        id = json["id"].stringValue
        nameUslugi = json["NAME_USLUGI"].stringValue
        deptPeriodBegin = toDouble(jsonString:json["SALDO_BEGIN"].stringValue).rounded(toPlaces: 4)
        accruedPeriodValue = toDouble(jsonString: json["NACHISLENO"].stringValue).rounded(toPlaces: 4)
        paymentPeriodValue = toDouble(jsonString: json["OPLATA"].stringValue).rounded(toPlaces: 4)
      //  lastMeterValue = json["DATE_OT"].stringValue
        deptPeriodEndValue = deptPeriodBegin + accruedPeriodValue -  paymentPeriodValue
       
        
        if deptPeriodEndValue < 0 {
            deptPeriodEndValue = 0
        }
        vidUslugi = json["VID_USLUGI"].stringValue
     
        
    }
}

struct PaymentMeterDataSum{
    var items: [PaymentMeterData]
    
    var getServiseType : Int{
        get {
            var serviseType : Int = 0
            for i in items {
                serviseType = Int (i.vidUslugi)!
            }
            return serviseType
        }
    }
    var deptPeriodBeginSum : Double{
        get{
            var deptPeriodBeginSum: Double = 0.0
            for i in items {
                deptPeriodBeginSum += i.deptPeriodBegin
            }
        
            return  Double(deptPeriodBeginSum).rounded(toPlaces: 4)
                        
    }
                    
    }
    
    var  accuredPeriodValueSum: Double{
        get {
            var accuredPeriodValue: Double = 0.0
            for i in items{
                accuredPeriodValue += i.accruedPeriodValue
            }
            return  Double(accuredPeriodValue).rounded(toPlaces: 4)
        }
    }
    
    var paymentPeriodValueSum: Double{
        get {
            var paymentPeriodValue : Double = 0.0
            for i in items{
                paymentPeriodValue += i.paymentPeriodValue
                print ("sum", i )
            }
           
            return  paymentPeriodValue.rounded(toPlaces: 4)
            
        }
    }
    
    var deptPeriodEndValue : Double{
        get {
            var deptPeriodEndValue : Double = 0.0
            for i in  items {
                deptPeriodEndValue += i.deptPeriodEndValue
            }
            if deptPeriodEndValue < 0 {
                return 0
            }
            return deptPeriodEndValue.rounded(toPlaces: 4)
        }
    }
    
    

}


    
