//
//  GeneralInfoCollectionViewCell.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 25.06.2021.
//

import UIKit

class GeneralInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberMeter: UILabel!
    @IBOutlet weak var typeMeter: UILabel!
    @IBOutlet weak var dateIntallMeter: UILabel!
    @IBOutlet weak var dateVerifyMeter: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        
    }
    
    
    func configure (item : GeneralInfoDataItem){
        numberMeter.text = item.numberMeter
        typeMeter.text = item.typeMeter
        dateIntallMeter.text = item.dateInstall
        dateVerifyMeter.text = item.dateVerification
 
    }

}
