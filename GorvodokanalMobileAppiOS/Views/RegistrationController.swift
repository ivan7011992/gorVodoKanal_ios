//
//  RegistrationController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 31.08.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import TLCustomMask

class RegistrationController: UIViewController, UITextFieldDelegate {

  
    @IBOutlet weak var registrationViewController: UIView!
    @IBOutlet weak var kodSubscriberTextFiled: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var houseTextField: UITextField!
    @IBOutlet weak var flatTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var buttonRegistration: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var errorLabelKod: UILabel!
    @IBOutlet weak var errorLabelStreer: UILabel!
    @IBOutlet weak var errorLabelHouse: UILabel!
    @IBOutlet weak var errorLabelFlat: UILabel!
    @IBOutlet weak var errorLabelPhone: UILabel!
    @IBOutlet weak var errorLabelPassword: UILabel!
    @IBOutlet weak var errorLabelConfirmPassword: UILabel!
    @IBOutlet weak var errorLabelEmail: UILabel!
    
    @IBOutlet weak var scrollviewRegistration: UIScrollView!
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBAction func showReference(_ sender: Any) {
        let alert = UIAlertController(title:"Код абонента", message: "Код вводится в формате *-******", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showReferenceFlat(_ sender: Any) {
        let alert1 = UIAlertController(title:"", message: "Если отсутствует номер квартиры,необходимо указать цифру 0", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert1.addAction(okBtn)
        present(alert1, animated: true, completion: nil)
    }
    
    @IBAction func returnButton(_ sender: Any) {
     
        self.dismiss(animated: true, completion: nil)
    }
    
    var collectionDataForSetRegistration : [String : String] = [:]
    var collectionUITextFeild : [String: UITextField] = [:]
    var collectionUITextFeildErrors: [String: UIStackView] = [:]
    var textErrorRegistrationCollection: [String : String] = [:]
    var collectionErrorLabel: [String: UILabel] = [:]
    private let maxNumberCount = 9
        private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    
    var flagPassword : Int =  0
    var flagConfirmPassword : Int =  0
    var customMask = TLCustomMask()
//    @IBAction func swithShowPassword(_ sender: Any) {
//        if flagPassword == 0{
//
//            passwordTextField.isSecureTextEntry = false
//            flagPassword = 1
//        }else {
//            passwordTextField.isSecureTextEntry = true
//            flagPassword = 0
//        }
//    }
//
//    @IBAction func swithShowConfirmPassword(_ sender: Any) {
//        if flagConfirmPassword == 0{
//            confirmPasswordTextField.isSecureTextEntry = false
//            flagConfirmPassword = 1
//        }else {
//            confirmPasswordTextField.isSecureTextEntry = true
//            flagConfirmPassword = 0
//        }
//    }
   
    
    @IBAction func submitRegistrationData(_ sender: Any) {
     
        
      
        print ("collection",  collectionDataForSetRegistration)
         var countErrors = 0
        for (key, value) in collectionDataForSetRegistration{
            if value .isEmpty {
                countErrors += 1
                collectionErrorLabel[key]?.text = textErrorRegistrationCollection[key]
               // let label = makeNewLabel(textLabel: textErrorRegistrationCollection[key] ?? "")
               // label.removeFromSuperview()
                print ("collection",  "ok")
               // let stackView = collectionUITextFeildErrors[key]
                
          
              // stackView?.spacing = 6
            }
            else {
                collectionErrorLabel[key]?.text = " "
                
            }
    }
        if countErrors == 0 {
            submitRegistrationData()
        }
    }
    
    
    @IBAction func returnToMainController(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AuthControllerId") as! AuthorizationController
       
        self.present(viewController, animated: true)
        
    }
    
    @IBAction func SubmitData(_ sender: Any) {
       
        
        
        print ("collection",  collectionDataForSetRegistration)
         var countErrors = 0
        for (key, value) in collectionDataForSetRegistration{
            if value .isEmpty {
                countErrors += 1
                let label = makeNewLabel(textLabel: textErrorRegistrationCollection[key] ?? "")
                label.removeFromSuperview()
                print ("collection",  "ok")
                let stackView = collectionUITextFeildErrors[key]
                
               
           
                
                
                    
               stackView?.spacing = 6
            }
    }
        if countErrors == 0 {
            submitRegistrationData()
        }
    }
    
    
    func submitRegistrationData(){
        let param = collectionDataForSetRegistration
        
        AF.request(UrlCollection.REGISTRATION_URL, method: .post, parameters: param, encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { (response) in
        
            debugPrint(response)
            switch response.result{
            case.success(let value):
             
                let json = JSON(value)
                let status = json["success"]
                if status == true{
                    
                   
                    ToastUtils.showToast(message: "Регистрация удалась", view: self.view)
               // print("status", message)
                    let seconds = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        self.dismiss(animated: true, completion: nil)
                    }
                   
                   
                // let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerId") as! MainViewController
               // self.present(viewController, animated: true)
               
                    }else {
                        let message = json["message"].string
                       
                        let errors = json["errors"]
                        var stringErrors = " "
                        for obj in json["errors"] {
                            stringErrors += obj.1.stringValue + "\n"
                            print(stringErrors)
                        }
                     
                            
                        
                        ToastUtils.showToast(message: stringErrors, view: self.view)
                      
                  print("status", errors)
                    
                }
            case .failure(let error):
                print (error)
            }
                                                                                                                
        })
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationViewController.insetsLayoutMarginsFromSafeArea = false
        //enterLabelKod.isHidden = true
        let screenRect = UIScreen.main.bounds
        let screenHeight = screenRect.size.height
        let screenWidth = screenRect.size.width
        registrationViewController.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.registrationViewController.backgroundColor = UIColor(patternImage: UIImage(named: "fon")!)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fon")!)
        addPlaceholderTextField()
        
        kodSubscriberTextFiled.delegate = self
        collectionDataForSetRegistration = [
            "kod": "",
             "street" : "",
             "house" : "",
             "flat" : "",
             "phone" : "",
             "passwordReg" : "",
             "confirmPassword" : "",
              "emailReg" : ""]
        
            collectionUITextFeild =
            ["kod": kodSubscriberTextFiled,
             "street" : streetTextField,
             "house" : houseTextField,
             "flat" : flatTextField,
             "phone" : phoneTextField,
             "passwordReg" : passwordTextField,
             "confirmPassword" : confirmPasswordTextField,
              "emailReg" : emailTextField
            ]
        
         
        
//           collectionUITextFeildErrors = [
//            "kod" : stackViewCode,
//            "street" : stackViewStreet,
//            "house" : stackViewHouse,
//            "flat" : stackViewFlat,
//            "phone" : stackViewPhone,
//            "password" : stackViewPassword,
//            "confirmPassword" : stackViewConfirmPassword,
//             "email" : stackViewEmail
//           ]
        
        
        
        collectionErrorLabel = [
            "kod" : errorLabelKod,
            "street" : errorLabelStreer,
            "house" : errorLabelHouse,
            "flat" :  errorLabelFlat,
            "phone" : errorLabelPhone,
            "passwordReg" : errorLabelPassword,
            "confirmPassword" : errorLabelConfirmPassword,
            "emailReg" : errorLabelEmail
        
        ]
        textErrorRegistrationCollection = [
            "kod" : "Введите код абонента",
            "street" : "Введите улицу",
            "house" :  "Введите дом",
            "flat" :  "Введите квартиру",
            "phone" : "Введите телефон",
            "passwordReg" : "Введите пароль",
            "confirmPassword" : "Подтвердите пароль",
            "emailReg" : "Введите почту"
            
            
        
        ]
      
    
        for (_, valueCollectionTextField) in collectionUITextFeild{
            
            
            setChangeLisenenOnTextFeild(textFeild: valueCollectionTextField)
        }
        
        phoneTextField.addTarget(self, action: #selector(textFieldPhoneDidChange), for: .editingChanged)
      

        buttonRegistration.layer.cornerRadius = 5
        addBottomBorderInput(input: kodSubscriberTextFiled)
        addBottomBorderInput(input: streetTextField)
        addBottomBorderInput(input: houseTextField)
        addBottomBorderInput(input: flatTextField)
        addBottomBorderInput(input: phoneTextField)
        addBottomBorderInput(input: passwordTextField)
        addBottomBorderInput(input: confirmPasswordTextField)
        addBottomBorderInput(input: emailTextField)
        customMask.formattingPattern = "$$-$$$$$$$"
        registerForKeyboardNotifications()
     
     
        
    }
    
    
    @objc  func gestureFired(_ gesture : UITapGestureRecognizer){
        self.view.endEditing(true)
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
      
     let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollviewRegistration.contentInset = contentInsets
        scrollviewRegistration.scrollIndicatorInsets = contentInsets
 
           
        }
        
 
    @objc func kbWillHide() {
        self.view.frame.origin.y = 0
        
    }
    
    @objc func hideKeboard()  {
        self.view.endEditing(true)
    }
    
    
    @IBAction func prepareForUnwind (segue: UIStoryboardSegue) {

    }
    
    @objc func textFieldPhoneDidChange(_ textField: UITextField) {
        let fullString = (textField.text ?? "")
        textField.text = formatPhone(with: "+X(XXX) XXX-XX-XX", phone: fullString)

    }
    func addPlaceholderTextField(){
       
        kodSubscriberTextFiled.attributedPlaceholder = NSAttributedString( string : "XX-XXXXXXX", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        streetTextField.attributedPlaceholder = NSAttributedString( string : "Введите улицу ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        houseTextField.attributedPlaceholder = NSAttributedString( string : "Введите дом", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        flatTextField.attributedPlaceholder = NSAttributedString( string : "Введите квартиру", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        phoneTextField.attributedPlaceholder = NSAttributedString( string : "Введите телефон", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString( string : "Введите пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString( string : "Подтвердите пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.attributedPlaceholder = NSAttributedString( string : "Введите почту", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    func setChangeLisenenOnTextFeild(textFeild: UITextField){
        textFeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    
    
    @objc func textFieldDidChange(input : UITextField){
        let inputValue = input.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let keyTextField = collectionUITextFeild.someKey(forValue: input)
        
        collectionDataForSetRegistration[keyTextField!] = inputValue
        collectionErrorLabel[keyTextField!]?.text = " "
        print(collectionDataForSetRegistration)
        
    }

    func addBottomBorders(button : UIButton) {
       let thickness: CGFloat = 2.0
       let bottomBorder = CALayer()
       bottomBorder.frame = CGRect(x:0, y: button.frame.size.height - thickness, width: button.frame.size.width, height:thickness)
       bottomBorder.backgroundColor = UIColor.white.cgColor
       button.layer.addSublayer(bottomBorder)
        
        
    }
    
    func addBottomBorderInput(input: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: input.frame.height - 1, width: input.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        input.borderStyle = UITextField.BorderStyle.none
        input.layer.addSublayer(bottomLine)
        
         
    }
    func addBorders(button : UIButton) {
        button.backgroundColor = .clear
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        button.layer.cornerRadius = 5
    }
    override func viewDidAppear(_ animated: Bool) {
       
      
        buttonRegistration.layer.cornerRadius = 5
        addBottomBorderInput(input: kodSubscriberTextFiled)
        addBottomBorderInput(input: streetTextField)
        addBottomBorderInput(input: houseTextField)
        addBottomBorderInput(input: flatTextField)
        addBottomBorderInput(input: phoneTextField)
        addBottomBorderInput(input: passwordTextField)
        addBottomBorderInput(input: confirmPasswordTextField)
        addBottomBorderInput(input: emailTextField)
      
    }
    
    func makeNewLabel(textLabel : String)-> UILabel{
      
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textColor = .red
        label.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.textAlignment = .center
        label.text = textLabel
        
        return label
        
        
    }
    
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
      
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        
            let pattern = "(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1-$2", options: .regularExpression, range: regRange)
        
         // login = number
        collectionDataForSetRegistration["kod"] = number
        return number
    }
    
    func formatPhone(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        collectionDataForSetRegistration["phone"] = result
        return result
    }


    

}



extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

extension RegistrationController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        kodSubscriberTextFiled.text = customMask.formatStringWithRange(range: range, string: string)
        collectionDataForSetRegistration["kod"] = kodSubscriberTextFiled.text ?? " "
        return false
        
    }
}


