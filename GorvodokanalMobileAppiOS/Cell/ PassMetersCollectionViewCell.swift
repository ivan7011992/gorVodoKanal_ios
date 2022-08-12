//
//  PassMetersCollectionViewCell.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 11.07.2021.
//

import UIKit


@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}

protocol CollectionViewCellDelegate {
    func collectionViewCell(valueChangedIn textField: UITextField, delegatedFrom cell: PassMetersCollectionViewCell)
    func collectionViewCell(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, delegatedFrom cell: PassMetersCollectionViewCell)  -> Bool
}
class PassMetersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameMetertKnotValue: UILabel!
    
    @IBOutlet weak var nameMeter: UILabel!
    @IBOutlet weak var inputPassMeters: UITextField!
    @IBOutlet weak var datePassMeterValue: UILabel!
    @IBOutlet weak var lastMeterValue: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    var delegate: CollectionViewCellDelegate?
    var idCard  : Int = 0
    var userData:String = ""
    var lastMeterValueText = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputTextField.keyboardType = .numberPad
        addBottomBorderInput(input: inputPassMeters)
        inputTextField.delegate = self
        // Initialization code
            inputTextField.addTarget(self, action: #selector(showChange), for: .editingChanged)
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Введите показания",
            attributes: [.paragraphStyle: centeredParagraphStyle]
            
        )
       

    }

    @IBAction func tap(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
    
    @objc func showChange(input: UITextField){
        
        userData = inputTextField.text!
        delegate?.collectionViewCell(valueChangedIn: inputTextField, delegatedFrom: self)    }
    
    func configure (nameMetertKnot: String,nameMeterVal:String,datePassMeter:String,lastMeter:String, typeWater: Int, dateProm: String){
        if typeWater == 1 {
            nameMetertKnotValue.text = "№ узла" + " " +  nameMetertKnot + " " + "-" + " " +  "Холодная"
        }else {
            nameMetertKnotValue.text = "№ узла" + " " +  nameMetertKnot + " " + "-" + " " +  "Горячая"
        }
      
        
        nameMeter.text = nameMeterVal
        datePassMeterValue.text = datePassMeter
        lastMeterValueText = lastMeter
        
        lastMeterValue.text =  String(toDouble(jsonString: lastMeter).rounded(toPlaces: 4))
        
       // inputTextField.placeholder = "Введите показания"
        if !dateProm.isEmpty {
           
        }
        
 
    }
    func addBottomBorderInput(input: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: input.frame.height - 1, width: input.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        input.borderStyle = UITextField.BorderStyle.none
        input.layer.addSublayer(bottomLine)
        
         
    }
    func addRedBottomBorderInput(input: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: input.frame.height - 1, width: input.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.red.cgColor
        input.borderStyle = UITextField.BorderStyle.none
        input.layer.addSublayer(bottomLine)
        
         
    }
    
    func toDoubleinString(jsonString: String) -> Double{
        
       return (jsonString as NSString).doubleValue
    }

    func validate() ->Bool{
        if userData.isEmpty{
            errorLabel.adjustsFontSizeToFitWidth = true
            errorLabel.minimumScaleFactor = 0.5
            errorLabel.text = "Введите данные"
            return false
        }else if (toDoubleinString(jsonString: userData) < toDoubleinString(jsonString: lastMeterValueText)) {
                errorLabel.minimumScaleFactor = 0.5
                errorLabel.text = "Показания  меньше предыдущих"
               return false
        }else{
                errorLabel.minimumScaleFactor = 0.5
                errorLabel.text = ""
            }
        return true
        }
          
        
    
}




extension PassMetersCollectionViewCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if let delegate = delegate {
           return delegate.collectionViewCell(textField: inputTextField, shouldChangeCharactersIn: range, replacementString: string, delegatedFrom: self)
        }
        return true
    }
}
