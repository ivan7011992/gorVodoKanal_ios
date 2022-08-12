//
//  DateInterval.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 06.08.2021.
//

import Foundation

struct DateInterval{
    static let month = ["Январь":1,"Февраль":2,"Март":3,"Апрель":4,"Май":5,"Июнь":6,"Июль":7,
                        "Август":8,"Сентябрь":9,"Октябрь":10,"Ноябрь":11,"Декабрь":12]
  
    static let monthByIndex = ["","Январь","Февраль","Март","Апрель","Май","Июнь","Июль",
                               "Август","Сентябрь","Октябрь","Ноябрь","Декабрь"]
    static let years = [2022,2021,2020,2019,2018,2017,2016];
    
    var beginMonth:Int
    var beginYear:Int
    var endMonth: Int
    var endYear:Int
    
    
    init() {
     //   let calender = Calendar.current
    //       let dateComponents = DateComponents(calendar: calender, year: 2021,month: 8)
        endMonth = (Date().string(format: "MM") as NSString).integerValue
        endYear = (Date().string(format: "yyyy") as NSString).integerValue
        
        
        if endMonth - 6 >= 1{
            beginYear = endYear
            beginMonth = endMonth - 6
        }else{
            beginYear = endYear - 1
            beginMonth = 12 - (6 - endMonth)
        }
    }
    
    func isValid() -> Bool {
    
        if(beginYear > endYear){
            
            return false
        }
        if (beginYear == endYear){
            print ("Начальный месяц",beginYear , endYear)
            if (beginMonth > endMonth){
                return false
                       }
            
        }
        return true
    }
    
    static func indexByYear(year: Int) ->Int{
        
        let i = years.firstIndex(where: { $0 == year })
        return i!
  
    }
    
    
    
    func beginDate() -> String {
        return self.formatDate(year: beginYear, month: beginMonth)
    }
    func endDate() -> String {
        return self.formatDate(year: endYear, month: endMonth)
    }
    
    func getDateBeginLabel() -> String{
        return self.FormatGetDateLabel(year: beginYear, month: beginMonth)
    }
    func getDateEndLabel() ->String{
        return self.FormatGetDateLabel(year: endYear, month: endMonth)
    }
    
    
    func FormatGetDateLabel(year: Int, month: Int) -> String{
         print ("month\(month)")
      
        return  DateInterval.monthByIndex[month]  + " " +  String(year)
        
    }
    
    private func formatDate(year: Int, month: Int) -> String {
        return "01." + self.formatMonth(month: month) + "." + String(year)
        
    }
    
    private func formatMonth(month: Int) -> String {
        if(month <= 9) {
            return "0" + String(month)
        }
        return String(month)
    }
    
    
}
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
