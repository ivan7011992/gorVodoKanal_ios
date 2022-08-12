//
//  GeneralInfoData.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 03.08.2021.
//
import Foundation
import UIKit
import  SwiftyJSON


struct GeneralInfoData{
    var header:GeneralInfoDataHeader
    var items: [GeneralInfoDataItem]
    
}

struct GeneralInfoDataHeader : Identifiable {
    var id: String 
    var IPU:String
    var fio: String
    var street: String
    var house:String
    var flat:String
    var coolWaterTarif:String
    var effluentWaterTarif:String
    var commonHouseNeeds: String
    var standartWaterConsumption:String
    var costWaterMeter:String
    var normEffluent:String
    var costEffluent:String
    var countLodger:String
    var address: String{
        get{
            let address = "ул." + " " + street + " " +  house + " " + "КВ" + flat
            return address
        }
    }
    
    
    
}
extension GeneralInfoDataHeader{
    init(json:JSON){
        
        id = json["id"].stringValue
        IPU = json["IPU"].stringValue
        fio = json["FIO"].stringValue 
        street = json["NAIMUL"].stringValue
        house = json["DOM"].stringValue
        flat = json["KVARTIRA"].stringValue
        coolWaterTarif = json["ZENWODA"].stringValue
        effluentWaterTarif = json["ZENSTOK"].stringValue
        commonHouseNeeds  = json["ST_BLAG"].stringValue
        standartWaterConsumption = json["WODA_KUB_MES"].stringValue
        costWaterMeter = json["ZENWODA"].stringValue
        normEffluent = json["STOK_KUB_MES"].stringValue
        costEffluent = json["ZENSTOK"].stringValue
        countLodger = json["KOLJIL"].stringValue
        
        }
}

struct GeneralInfoDataItem : Identifiable {
    var id: String
    var numberMeter: String
    var typeMeter: String
    var dateInstall : String
    var dateVerification : String
    
   
}

extension GeneralInfoDataItem{
    init(json: JSON){
        id =  json["id"].stringValue
        numberMeter = json["N_VODOMER"].stringValue
        typeMeter = json["VID"].stringValue
        dateInstall = json["DAT_UST"].stringValue
        dateVerification = json["DAT_POVER"].stringValue
        
    }
    
}

