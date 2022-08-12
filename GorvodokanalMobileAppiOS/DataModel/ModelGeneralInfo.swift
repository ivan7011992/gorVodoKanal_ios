//
//  ModelGeneralInfo.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 02.08.2021.
//

import Foundation
import UIKit

class ModelGeneralInfo {
    static let  instance =  ModelGeneralInfo()
    
    private var fio: String = ""
    private var adress :String = ""
   
    private init(){
        
    }
    public func setFio(fio: String){
        
    }
    
    public func setAddress(street: String, house: String, flat: String){
        self.adress = street + house + flat
    }
    
    public func createInstance( ){
       
        
    }
    
}
