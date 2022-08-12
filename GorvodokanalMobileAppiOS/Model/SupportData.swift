//
//  SupportData.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 10.09.2021.
//

import Foundation
import UIKit
import SwiftyJSON

struct SupportData {
    var  id: String
    var dateAppeal:String
    var question:String
    var answer:String
    
    }

extension  SupportData{
    init (json :JSON){
         
       
        
        id = json["id"].stringValue
        dateAppeal = String(json["date_question"].stringValue.dropLast(8))
        question = json["question"].stringValue
        answer = String(json["date_response"].stringValue.dropLast(8)) + " " + json["response"].stringValue

    }
}
