//
//  HistoryMetersData.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 10.08.2021.
//

import Foundation
import SwiftyJSON
func toDouble(jsonString: String) -> Double{
    
   return (jsonString as NSString).doubleValue
}
struct HistoryMetersData: Identifiable{
    var id: String
    var deptBeginValue:Double
    var accruedPeriodvalue: Double
    var paymentPeriodValue:Double
    var depdEndValue:Double
    var dateCurrentCard:String
    var vidUslugi : Int
    var nameUslugi: String
    
    
}

var monthMeters : [String : String] = ["JAN" : "Январь",
                                       "FEB" : "Февраль",
                                       "MAR" : "Март",
                                       "APR" : "Апрель",
                                       "MAY" : "Май",
                                       "JUN" : "Июнь",
                                       "JUL" : "Июль",
                                       "AUG" : "Август",
                                       "SEP" : "Сентябрь",
                                       "OCT" : "Октябрь",
                                       "NOV" : "Ноябрь",
                                       "DEC" : "Декабрь"]

extension  HistoryMetersData{
    init (json :JSON){
        id = json["id"].stringValue
        deptBeginValue = toDouble(jsonString:json["SALDO_BEGIN"].stringValue )
        accruedPeriodvalue = toDouble(jsonString: json["NACHISLENO"].stringValue)
        paymentPeriodValue = toDouble(jsonString: json["OPLATA"].stringValue)
        dateCurrentCard = json["DATE_OT"].stringValue
        
        let depdEndValueDouble = deptBeginValue + accruedPeriodvalue -  paymentPeriodValue
        depdEndValue =  depdEndValueDouble
        vidUslugi = json["VID_USLUGI"].intValue
        nameUslugi = json["NAME_USLUGI"].stringValue
        
    }

    
}
    
    struct  HistoryMetersDateSummary{
        
        var date: String
        var items: [HistoryMetersData]
        
     
        
        func formatDate(month:String, year :String) -> String{
            var monthNew  : String {
                get{
                    var monthNew : String = ""
                    monthNew = String(month.dropFirst(3))
                    monthNew = String(monthNew.dropLast(3))
                
                return monthNew
                }
            }
            print ("month" , monthNew)
            let monthRus = monthMeters[monthNew]
            let yearFormat = "20" + String(month.dropFirst(7))
            let date = monthRus! + " " +  yearFormat
            return date

        }
        
        var getDate: String {
            get{
                var date : String = " "
                for i in items {
                    date = i.dateCurrentCard
            }
                return date
            }
        }
        
        var getCurrentDateCard : String{
            get{
                var currentDateCard: String = ""
                for i in items {
                   currentDateCard = i.dateCurrentCard
                   currentDateCard =  formatDate(month: i.dateCurrentCard, year: i.dateCurrentCard)
                }
                
                return currentDateCard
                            
        }
                        
        }
 
        
        var getSaldoBegin : Double{
            get{
                var getSaldoBegin: Double = 0.0
                for i in items {
                    getSaldoBegin += i.deptBeginValue
                }
            
                return Double(getSaldoBegin).rounded(toPlaces: 4)
                            
        }
                        
        }
        
        var getAccured: Double{
            get{
                var accruedPeriod:Double = 0.0
                for i in items{
                    accruedPeriod += i.accruedPeriodvalue
                }
                return Double(accruedPeriod).rounded(toPlaces: 4)
        }
        }
    
        var getpaymant: Double{
            get{
                var paymentPeriod:Double = 0.0
                for i in items{
                    paymentPeriod += i.paymentPeriodValue
                }
                return Double(paymentPeriod).rounded(toPlaces: 4)
        }
        }
        
        var getDepdEndValue: Double{
            get{
                var depdEndValue:Double = 0.0
                for i in items{
                    depdEndValue += i.depdEndValue
                }
                return Double(depdEndValue).rounded(toPlaces: 4)
        }
        }
        
    }



extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
