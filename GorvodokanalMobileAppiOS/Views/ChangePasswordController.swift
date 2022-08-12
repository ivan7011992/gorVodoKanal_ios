//
//  ChangePasswordController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 09.09.2021.
//

import UIKit
import Alamofire
import  SwiftyJSON
import IQKeyboardManagerSwift

class ChangePasswordController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var changePassView: UIView!
    let url  = "https://www.gorvodokanal.com/mobile_app/change_password.php"
    @IBOutlet weak var closeDialog: UIImageView!
    @IBOutlet weak var oldPassTextField: UITextField!
    @IBOutlet weak var newPassTextFeild: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var errorOldPassLabel: UILabel!
    @IBOutlet weak var errorNewPassLabel: UILabel!
    @IBOutlet weak var errorlCobirmPassLabel: UILabel!
    var dataTextFieldArray : [String : UITextField] = [:]
    var dataPasswordToChange : [String : String] =  ["oldPassword" : "",
                                                     "newPassword" : "",
                                                     "confirmPassword" : ""]
    var dataErrorTextField : [String : String] =  ["oldPassword" : "Введите старый пароль",
                                                   "newPassword" : "Введите новый пароль",
                                                   "confirmPassword" : "Подтвердите пароль"]
    var collectionErrorLabel : [String : UILabel] = [:]
    
    @IBAction func SubmitData(_ sender: Any) {
        for (key, value) in dataPasswordToChange{
            if value .isEmpty {
               
              collectionErrorLabel[key]?.text = dataErrorTextField[key]
       
            }
     
        }
        if dataPasswordToChange["newPassword"] != dataPasswordToChange["confirmPassword"]{
            print ("password no to match")
            collectionErrorLabel["confirmPassword"]?.text  = "Пароли не совпадают"
            
        }else {
            submitDataPassword()
            
        }
    }

    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        addBottomBorderInput(input: oldPassTextField)
        addBottomBorderInput(input: newPassTextFeild)
        addBottomBorderInput(input: confirmPassTextField)
        oldPassTextField.attributedPlaceholder = NSAttributedString(string:"Введите старый пароль", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font :UIFont(name: "Arial", size: 11)!])
        
        oldPassTextField.adjustsFontSizeToFitWidth = true
        oldPassTextField.minimumFontSize = 0.5
        oldPassTextField.textAlignment = .center
        newPassTextFeild.attributedPlaceholder = NSAttributedString(string:"Введите новый пароль", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font :UIFont(name: "Arial", size: 11)!])
        
        newPassTextFeild.textAlignment = .center
        confirmPassTextField.attributedPlaceholder = NSAttributedString(string:"Подтвериде пароль", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font :UIFont(name: "Arial", size: 11)!])
        
        confirmPassTextField.textAlignment = .center
        changePassView.layer.cornerRadius = 10
        
        errorOldPassLabel.adjustsFontSizeToFitWidth = true
        errorOldPassLabel.minimumScaleFactor = 0.5
        errorNewPassLabel.adjustsFontSizeToFitWidth = true
        errorNewPassLabel.minimumScaleFactor = 0.5
        errorlCobirmPassLabel.adjustsFontSizeToFitWidth = true
        errorlCobirmPassLabel.minimumScaleFactor = 0.5
        dataTextFieldArray =
            ["oldPassword" : oldPassTextField,
             "newPassword" : newPassTextFeild,
             "confirmPassword" : confirmPassTextField]
        collectionErrorLabel =
            ["oldPassword" : errorOldPassLabel,
             "newPassword" : errorNewPassLabel,
             "confirmPassword" : errorlCobirmPassLabel]
      
        for (_, valueCollectionTextField) in dataTextFieldArray{
            
            
            setChangeLisenenOnTextFeild(textFeild: valueCollectionTextField)
        }
        newPassTextFeild.delegate = self
        confirmPassTextField.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_ :)))
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        closeDialog.isUserInteractionEnabled = true
        closeDialog.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc  func gestureFired(_ gesture : UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView

        self.dismiss(animated: true, completion: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= 200
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func submitDataPassword(){
        print ("ok5")
        let param =
            ["oldPassword" : dataPasswordToChange["oldPassword"],
             "newPassword" : dataPasswordToChange["newPassword"]]
  
        
        AF.request(UrlCollection.CHANGE_PASSWORD_URL, method: .post, parameters: param, encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { (response) in
        
            debugPrint(response)
            switch response.result{
            case.success(let value):
             
                let json = JSON(value)
                let status = json["success"]
                if status == true{
                    
                  
                    self.showToast(textToast: "Пароль изменен")
                 
               // print("status", message)
                    let seconds = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        self.dismiss(animated: true, completion: nil)
                    }
                  
                // let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerId") as! MainViewController
               // self.present(viewController, animated: true)
               
                    }else {
                    let message = json["message"]
                      
                  print("status", message)
                    
                }
            case .failure(let error):
                print (error)
            }
                                                                                                                
        })   }
    func setChangeLisenenOnTextFeild(textFeild: UITextField){
        textFeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    @objc func textFieldDidChange(input : UITextField){
      
        let inputValue = input.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let keyTextField = dataTextFieldArray.someKey(forValue: input)
        let  lebelError = collectionErrorLabel[keyTextField ?? ""]
        lebelError?.text = ""
        dataPasswordToChange[keyTextField!] = inputValue
        print (dataPasswordToChange)
     
    }
    
    
    
    
    

    func addBottomBorderInput(input: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: input.frame.height - 1, width: input.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        input.borderStyle = UITextField.BorderStyle.none
        input.layer.addSublayer(bottomLine)
        
         
    }
    
    func showToast(textToast : String) {
     
       let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 60, y: self.view.frame.size.height-100, width: 150, height: 35))
       toastLabel.backgroundColor = UIColor.blue.withAlphaComponent(0.6)
       toastLabel.textColor = UIColor.white
       toastLabel.textAlignment = .center;
     
       toastLabel.text =  textToast
        toastLabel.numberOfLines = 0;
        
   
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toastLabel.isHidden = true
        }
        toastLabel.sizeToFit()
     
        toastLabel.alpha = 1.0
       toastLabel.layer.cornerRadius = 10;
       toastLabel.clipsToBounds  =  true
       toastLabel.adjustsFontSizeToFitWidth = true
       toastLabel.minimumScaleFactor = 0.5
        self.view.addSubview(toastLabel)
   }
   
}

extension ChangePasswordController :UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       //  let length = !string.isEmpty ? textField.text!.count + 1 : textField.text!.count - 1
        let inputValue = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let keyTextField = dataTextFieldArray.someKey(forValue: textField)
        let  lebelError = collectionErrorLabel[keyTextField ?? ""]
        lebelError?.text = ""
        dataPasswordToChange[keyTextField!] = inputValue
        print ("pass\(dataPasswordToChange)")
       
           
         return true
    } }
