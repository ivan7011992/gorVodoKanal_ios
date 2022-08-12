//
//  PaymentCollectionViewCell.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 17.08.2021.
//

import UIKit

protocol CollectionViewCellDelegatePayment {
    func collectionViewCell(textField: UITextField, delegatedFrom cell: PaymentCollectionViewCell)
    func collectionViewCell(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, delegatedFrom cell: PaymentCollectionViewCell)  -> Bool
}

class PaymentCollectionViewCell: UICollectionViewCell{
    var userData:String = ""
    var idCard  : Int = 0
    var deptTextFeidl: Double = 0.0
    var vidUslugi:Int = 0;
    var i : Int = 0;
    
    
    
   
    @IBOutlet weak var labelServiceType: UILabel!
    @IBOutlet weak var deptPeriodBeginValue: UILabel!
    @IBOutlet weak var accruedPeriodValue: UILabel!
    @IBOutlet weak var paymentPeriodValue: UILabel!
    @IBOutlet weak var deptPeriodEndValue: UILabel!
    @IBOutlet weak var amountToPayTextField: UITextField!
    @IBOutlet weak var amountToPayLabel: UILabel!
   
    @IBOutlet weak var idcard: UILabel!
    var deptPlaceholder:String = ""
    var delegate: CollectionViewCellDelegatePayment?
    override func awakeFromNib() {
        super.awakeFromNib()
        amountToPayTextField.keyboardType = .numberPad
        
        amountToPayTextField.delegate = self
        amountToPayTextField.addTarget(self, action: #selector(saveDataInput), for: .editingChanged)
        amountToPayTextField.layer.borderColor = UIColor.black.cgColor
        amountToPayTextField.layer.borderWidth = 1.0
        amountToPayTextField.layer.cornerRadius = 5.0
    }
    @objc func saveDataInput(){
        
        userData = amountToPayTextField.text!
     
        delegate?.collectionViewCell(textField: amountToPayTextField, delegatedFrom: self)
   
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        if amountToPayLabel != nil{
            amountToPayLabel.text = " "
            
        }
        
        
    }
    
    func configure (item: PaymentMeterData){
        deptPeriodBeginValue.text = String(item.deptPeriodBegin)
        accruedPeriodValue.text = String(item.accruedPeriodValue)
        paymentPeriodValue.text = String(item.paymentPeriodValue)
        deptPeriodEndValue.text = String(item.deptPeriodEndValue)
        deptPlaceholder =  String(item.deptPeriodEndValue)
        deptTextFeidl = item.deptPeriodEndValue
        print ("dept", item.deptPeriodEndValue)
      
        userData = deptPlaceholder
        if (item.deptPeriodEndValue) <= 0 {
            amountToPayTextField?.placeholder =  "0"
        } else {
         
            amountToPayTextField?.placeholder =  deptPlaceholder 
            print("textDept: \(item.deptPeriodEndValue)")
    
        }
          
        labelServiceType.text = String(item.nameUslugi)
  
        idCard =  (item.vidUslugi as NSString).integerValue

        
    
 
    }
    func configureCard0 (item: PaymentMeterDataSum){
        deptPeriodBeginValue.text = String(item.deptPeriodBeginSum)
        accruedPeriodValue.text = String(item.accuredPeriodValueSum)
        paymentPeriodValue.text = String(item.paymentPeriodValueSum)
        deptPlaceholder =  String(item.deptPeriodEndValue)
        deptPeriodEndValue.text = String(item.deptPeriodEndValue)
        i += 1
        print("item1:\( item.getServiseType)")
        if (vidUslugi !=  item.getServiseType){
            if amountToPayTextField != nil{
                //amountToPayTextField.removeFromSuperview()
                print("item1:\(i+=1)")
            print("idCard:\(idCard)")
        
            }
        }
        if (item.getServiseType != 0){
        vidUslugi = item.getServiseType
        print("idCard1:\(item)")
            vidUslugi = 1
        }
      
    
    }
    
    
    func validate() ->Bool{
        if userData.isEmpty{
            //errorLabel.text = "Введите данные"
            return false
           
        }else{
        
            return true
        }
          
            }
}


extension PaymentCollectionViewCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if let delegate = delegate {
           return delegate.collectionViewCell(textField: amountToPayTextField, shouldChangeCharactersIn: range, replacementString: string, delegatedFrom: self)
        
      
        
        }
        
       
        return true
    }
}
