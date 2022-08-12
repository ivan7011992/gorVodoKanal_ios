//
//  HistoryMettersCollectionViewCell.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 06.07.2021.
//

import UIKit

protocol HisotyMetersViewDekegate {
    func showDetaiHistoryDialog(cell: HistoryMettersCollectionViewCell )
}

class HistoryMettersCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var debtBeginValue: UILabel!
    @IBOutlet weak var accruedPeriodvalue: UILabel!
    @IBOutlet weak var paymentPeriod: UILabel!
    @IBOutlet weak var deptEndPeriod: UILabel!
   
    @IBOutlet weak var details: UIButton!
    
    var numberCard: Int = 0
    var dateCard: String = " "
    var delegate : HisotyMetersViewDekegate?
    
    
    @IBAction func showDetails(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard storyboard.instantiateViewController(identifier: "DetailHistoryContollerId") is DetailHistoryViewController else { return }
        
        
        delegate?.showDetaiHistoryDialog(cell: self)
       
    }
    override func awakeFromNib() {
        debtBeginValue.numberOfLines = 1
        debtBeginValue.minimumScaleFactor = 0.5
        debtBeginValue.adjustsFontSizeToFitWidth = true
        super.awakeFromNib()
       
        
        // Initialization code
    }
    
    func setMeters(numb: Int){
        
        print("count" , numberCard)
        if numberCard == numb {
            print ("count2",numb)
            if details != nil{
            details.removeFromSuperview()
            }
        }
    }

    func configure(item: HistoryMetersDateSummary){
        
        dateLabel.text = item.getCurrentDateCard
        dateCard = item.getDate
        debtBeginValue.text =  String (item.getSaldoBegin)
        accruedPeriodvalue.text =  String(item.getAccured)
        paymentPeriod.text = String(item.getpaymant)
        deptEndPeriod.text =  String(item.getDepdEndValue)
        print ("date\(dateCard)\n")
        
    }
    
}




