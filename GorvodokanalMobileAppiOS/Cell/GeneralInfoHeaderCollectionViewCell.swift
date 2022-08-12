//
//  GeneralInfoHeaderCollectionViewCell.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 28.06.2021.
//

import UIKit

class GeneralInfoHeaderCollectionViewCell: UICollectionViewCell{
    
    var screenHeight: CGFloat = 0.0
    @IBOutlet weak var valueKod: UILabel!
    @IBOutlet weak var lodger: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var coolVodosnabValue: UILabel!
    @IBOutlet weak var vodootvValue: UILabel!
    @IBOutlet weak var standartWaterConsumption: UILabel!
    @IBOutlet weak var costWaterMeter: UILabel!
    @IBOutlet weak var normEffluent: UILabel!
    @IBOutlet weak var costEffluent: UILabel!
    @IBOutlet weak var countLodger: UILabel!
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var tatifStackView: UIStackView!
    @IBOutlet weak var IPU0StackView: UIStackView!
    @IBOutlet weak var stackViewCommonHouseNeeds: UIStackView!
    @IBOutlet weak var stackViewFio: UIStackView!
    @IBOutlet weak var stackViewAddress: UIStackView!
    @IBOutlet weak var stackViewWaterSupply: UIStackView!
    @IBOutlet weak var stackViewCoastWater: UIStackView!
    @IBOutlet weak var stackViewDrainage: UIStackView!
    @IBOutlet weak var stackViewStBlag: UIStackView!
    @IBOutlet weak var stackViewWodaKubMes: UIStackView!
    @IBOutlet weak var stackViewStokKubMes: UIStackView!
    @IBOutlet weak var stavkViewNormWaterSupply: UIStackView!
    @IBOutlet weak var stackViewNormDrainage: UIStackView!
    @IBOutlet weak var stackViewCoastDrainage: UIStackView!
    @IBOutlet weak var stackViewCountLodger: UIStackView!
    
    @IBOutlet weak var metersLabel: UIStackView!
    @IBOutlet weak var metersLabelStackView: UIStackView!
    var stackView : CGFloat = 0.0
//    func AspectWidth() -> CGFloat {
//        getViewHeaderHeight()
//
//        return round(UIScreen.main.bounds.size.width / CGFloat(375.0));
//
//    }
    
    func getViewHeaderHeight() -> CGFloat{
  
//        screenHeight = stackViewFio.frame.height
        
       
        return screenHeight
        
    }
    func configure (item : GeneralInfoDataHeader){
        
            if !item.fio.isEmpty{
        lodger.text = item.fio
            }else {
                generalStackView.removeArrangedSubview(stackViewFio)
                stackViewFio.removeFromSuperview()
            }
            if !item.address.isEmpty{
        address.text = item.address
            }else{
                generalStackView.removeArrangedSubview(stackViewAddress)
                stackViewAddress.removeFromSuperview()
            }
        
            if !item.coolWaterTarif.isEmpty{
                coolVodosnabValue.text = item.coolWaterTarif + " " +  "руб./м"
                       }
            else{
           
            }
            if !item.effluentWaterTarif.isEmpty{
                vodootvValue.text = item.effluentWaterTarif + " " +  "руб./м"
            }else{
              
            }
        
        if(item.IPU) == "1" {
            
        
//    generalStackView.removeArrangedSubview(IPU0StackView)
//    IPU0StackView.removeFromSuperview()

        }
        else {
           generalStackView.removeArrangedSubview(metersLabelStackView)
          metersLabelStackView.removeFromSuperview()
//            if item.commonHouseNeeds.isEmpty{
//                IPU0StackView.removeArrangedSubview(stackViewCommonHouseNeeds)
//                stackViewCommonHouseNeeds.removeFromSuperview()
//            }
//            if !item.standartWaterConsumption.isEmpty{
//                standartWaterConsumption.text = item.standartWaterConsumption}else{
//                    IPU0StackView.removeArrangedSubview(stackViewWaterSupply)
//                    stackViewWaterSupply.removeFromSuperview()
//                }
//            if !item.costWaterMeter.isEmpty{
//                costWaterMeter.text = item.costWaterMeter}else{
//                    IPU0StackView.removeArrangedSubview(stackViewCoastWater)
//                    stackViewCoastWater.removeFromSuperview()
//                }
//
//           if !item.normEffluent.isEmpty{
//               normEffluent.text = item.normEffluent}else{
//                IPU0StackView.removeArrangedSubview(stackViewDrainage)
//                stackViewDrainage.removeFromSuperview()
//            }
//            if !item.costEffluent.isEmpty{
//                costEffluent.text = item.costEffluent}else{
//                 IPU0StackView.removeArrangedSubview(stackViewCoastDrainage)
//                 stackViewCoastDrainage.removeFromSuperview()
//             }
//
//            if !item.countLodger.isEmpty{
//                countLodger.text = item.countLodger
//            }else {
//                IPU0StackView.removeArrangedSubview(stackViewCountLodger)
//                stackViewCountLodger.removeFromSuperview()
//            }
//
//
           }
       
       
    
        
       
       
      
    }
    
    
     
   override func awakeFromNib() {
       super.awakeFromNib()
   
  

  }
    

    
  
}

extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
}
