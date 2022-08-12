//
//  UserModel.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 08.10.2021.
//

import Foundation
import UIKit
import SwiftyJSON
class UserModel{
    

 
    var  shared: UserModel{
        get {
            var instance: UserModel
            
            instance =  UserModel(login: login, email: email)
            
            return instance
        }
    }
    
    init(login:String,email:String) {
        self.login = login
        self.email = email
    }
    
    private var login:String = ""
    private var email:String = ""
    
  
    public static func  createInstanceFromJson( json : JSON){
        
    }
    
    
    
}
