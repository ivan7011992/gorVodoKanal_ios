//
//  DetailHistoryCollectionViewCell.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 12.11.2021.
//

import UIKit

class DetailHistoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var vidUslugi: UILabel!
    @IBOutlet weak var deptBeginValueLabel: UILabel!
    @IBOutlet weak var accrualsForPeriodLabel: UILabel!
    @IBOutlet weak var paymentForPeriodLabel: UILabel!
    
    @IBOutlet weak var deptEndValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: HistoryMetersData){
        vidUslugi.text = String(item.nameUslugi)
        
        deptBeginValueLabel.text =  String (item.deptBeginValue)
        accrualsForPeriodLabel.text =  String(item.accruedPeriodvalue)
        paymentForPeriodLabel.text = String(item.paymentPeriodValue)
        deptEndValueLabel.text =  String(item.depdEndValue)
 
        
    }
    

}
