//
//  ChangeEmailViewController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 16.09.2021.
//

import UIKit
import Alamofire
import  SwiftyJSON
import IQKeyboardManagerSwift

class ChangeEmailViewController: UIViewController {
    
    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var closeDialog: UIImageView!
    
    @IBOutlet weak var changeEmailView: UIView!
    @IBOutlet weak var changeEmailTextField: UITextField!
   
    @IBOutlet weak var buttonChangeEmail: UIButton!
    var email:String = ""

    @IBAction func submitData(_ sender: Any) {
   
    
        if !email.isEmpty{
            submitDataEmail(email: email)
            labelError.text = ""
        }else{
            labelError.text = "Введите email"
        }
    
    }
    
    var storage = Storage.init()
    override func viewDidLoad() {

        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: defaultsKeys.email) {
            self.email =  email
        }
        if !email.isEmpty{
        
        changeEmailTextField.attributedPlaceholder = NSAttributedString( string : self.email, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
        addBottomBorderInput(input: changeEmailTextField)
        //changeEmailTextField.delegate = self
        labelError.adjustsFontSizeToFitWidth = true
        labelError.minimumScaleFactor = 0.5
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        closeDialog.isUserInteractionEnabled = true
        closeDialog.addGestureRecognizer(tapGestureRecognizer)
        changeEmailTextField.addTarget(self, action: #selector(textFieldDidChangeEmail), for: .editingChanged)
 
        // Do any additional setup after loading the view.
        registerForKeyboardNotifications()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_ :)))
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
     
    }
  
    @objc  func gestureFired(_ gesture : UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    deinit {
        removeKeyboardNotofications()
    }
   
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotofications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    var isExpand : Bool = false
    @objc func kbWillShow( notification : Notification)  {
     
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardRectangle = keyboardFrame!.cgRectValue
               let keyboardHeight = keyboardRectangle.height
          
//         let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        //scrollViewA.contentInset = contentInsets
       // scrollViewA.scrollIndicatorInsets = contentInsets
        
       // let userInfo =  notification.userInfo
        //let kbFrameSize = (userInfo? [UIResponder.keyboardIsLocalUserInfoKey] as! NSValue).cgRectValue
        //scrollViewAuth.contentOffset = CGPoint(x: 0, y: 0 )
      
    }
    @objc func kbWillHide() {
        self.view.frame.origin.y = 0
        
    }
    
    @objc func hideKeboard()  {
        self.view.endEditing(true)
    }
    
    
    @IBAction func prepareForUnwind (segue: UIStoryboardSegue) {

    }
   
    
    @objc func textFieldDidChangeEmail (inputLogin : UITextField){
       
        //let pattern = "##-#######"
       // let loginPattern = inputLogin.text
      //  inputLogin.text = loginPattern!.applyPatternOnNumbers(pattern: pattern)
      
        
        self.email = inputLogin.text ?? ""
        print("stotageEmail\(storage.email)")
         
        if !email.isEmpty{
        
        changeEmailTextField.attributedPlaceholder = NSAttributedString( string : "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
    }
    

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView

        self.dismiss(animated: true, completion: nil)
    }
    func addBottomBorderInput(input: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: input.frame.height - 1, width: input.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        input.borderStyle = UITextField.BorderStyle.none
        input.layer.addSublayer(bottomLine)
    
    }
    func submitDataEmail(email:String){
        let param = ["email" : email]
        
      
        AF.request(UrlCollection.CHANGE_EMAIL_URL, method: .post, parameters: param, encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { (response) in
        
           
            switch response.result{
            case.success(let value):
             
                let json = JSON(value)
                let status = json["success"]
                if status == true{
                    
                    self.labelError.text  =  json["message"].stringValue
                  
                    self.dismiss(animated: true, completion: nil)
              
                    }else {
                        self.labelError.text = json["message"].stringValue
                        
           
                    
                }
            case .failure(let error):
                print (error)
            }
                                                                                                                
        })
        
    }
    
}

//extension ChangeEmailViewController: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let inputValue =  textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        print ("inputValue\(inputValue)")
//        print ("email\(textField)")
//        emailArray[0] = inputValue
//        print("arrayEamil\(emailArray)")
//        dataSubmitEmail = textField.text ?? ""
//
//
//         return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        storage.email = textField.text!
//    }
//}

struct Storage {
    var email = ""
    static let initial = Storage()
}
