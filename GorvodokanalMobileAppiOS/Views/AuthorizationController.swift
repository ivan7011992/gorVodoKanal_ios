//
//  AuthorizationController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 23.06.2021.
//

import UIKit
import Alamofire
import  SwiftyJSON
import TLCustomMask
import LBTATools



class AuthorizationController: UIViewController , UITextFieldDelegate,UIViewControllerTransitioningDelegate{
    
    @IBOutlet weak var controllerViewAuthorization: UIView!
    @IBOutlet weak var loginBtn: UITextField!
    @IBOutlet weak var passwordBtn: UITextField!
    @IBOutlet weak var styleAythActionBtn: UIButton!
    @IBOutlet weak var recoveryBtn: UIButton!
    @IBOutlet weak var registrationBtn: UIButton!
    
    @IBOutlet weak var scrollViewAuth: UIScrollView!
    @IBOutlet weak var scrollViewA: UIScrollView!
    
    var hiddenPasswrd = 0
    var login : String = ""
    var password : String = ""
    var email : String = ""
    var flagPassword : Int =  0
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    var customMask = TLCustomMask()
    var window : UIWindow?
    
    @IBOutlet weak var labelErrorTop: UILabel!
    
    @IBOutlet weak var labelErrorButtom: UILabel!
    private let maxNumberCount = 9
        private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    
    @IBAction func referecesShow(_ sender: Any) {
        let alert = UIAlertController(title:"Код абонента", message: "Код вводится в формате *-******", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
       
    }
    
    @IBAction func hideshowPassword(_ sender: Any) {
        if flagPassword == 0{
        passwordBtn.isSecureTextEntry = false
            flagPassword = 1
        }else {
            passwordBtn.isSecureTextEntry = true
            flagPassword = 0
        }
    }
    
   @IBAction func authActionBtn(_ sender: Any) {
       labelErrorTop.text = "";
       labelErrorButtom.text = "";
    if self.login.isEmpty {
        labelErrorTop.text = "Введите логин";
        //self.showToast(textToast: "Введите логин", type: 1)
        
       return
    }
    if self.password.isEmpty{
        labelErrorButtom.text = "Введите пароль";
        //self.showToast(textToast: "Введите пароль", type: 2)
        
       return        }
    saveLoginAndStatus(login: login, status: "1")
    downloadTags(url:UrlCollection.AUTH_URL,login:login,password: password)
      
   }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.delegate = self
                loginBtn.keyboardType = .numberPad
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        controllerViewAuthorization.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: 100)
        self.controllerViewAuthorization.backgroundColor = UIColor(patternImage: UIImage(named: "fon")!)
        let defaults = UserDefaults.standard
        if let loginValue = defaults.string(forKey: defaultsKeys.login) {
            loginBtn.text = loginValue
            login = loginValue
        }
        loginBtn.attributedPlaceholder = NSAttributedString( string : "Логин", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        loginBtn.adjustsFontSizeToFitWidth = true
        loginBtn.minimumFontSize = 0.5
        loginBtn.delegate = self
        loginBtn.keyboardType = .asciiCapableNumberPad
        loginBtn.addTarget(self, action: #selector(textFieldDidChangeLogin), for: .editingChanged)
        passwordBtn.addTarget(self, action: #selector(textFieldDidChangePassword), for: .editingChanged)
        passwordBtn.attributedPlaceholder = NSAttributedString( string : "Пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        customMask.formattingPattern = "$$-$$$$$$$"
        controllerViewAuthorization.translatesAutoresizingMaskIntoConstraints = false
        self.preferredContentSize = CGSize(width: 100, height: 100)
        // Do any additional setup after loading the view.
        registerForKeyboardNotifications()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_ :)))
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gestureRecognizer)
        print("height\(self.view.frame.height)")
        if let status = defaults.string(forKey: defaultsKeys.status) {
            if !status.isEmpty{
        downloadTags(url:UrlCollection.AUTH_URL,login:login,password: "123456")
            }
        }
       
        labelErrorTop.text = "";
        labelErrorButtom.text = "";


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
        scrollViewA.contentInset = contentInsets
        scrollViewA.scrollIndicatorInsets = contentInsets
        
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
   
    

    
    func saveLoginAndStatus(login:String, status: String){
        let defaults = UserDefaults.standard
        defaults.set(login, forKey: defaultsKeys.login)
        defaults.set(status, forKey: defaultsKeys.status)
        
      
        }
  
    func addBorders(){
        addBottomBorders(button: recoveryBtn)
        styleAythActionBtn.layer.cornerRadius = 5
        addBorders(button: registrationBtn)
        addBottomBorderInput(input: loginBtn)
        addBottomBorderInput(input:passwordBtn)
    }
    
    @objc func textFieldDidChangeLogin (inputLogin : UITextField){
       
        //let pattern = "##-#######"
       // let loginPattern = inputLogin.text
      //  inputLogin.text = loginPattern!.applyPatternOnNumbers(pattern: pattern)
        inputLogin.text = customMask.formatString(string: inputLogin.text ?? " ")
        login = inputLogin.text ?? ""
        
         
        
    }
    @objc func textFieldDidChangePassword (inputPassword : UITextField){

        password = inputPassword.text ?? ""
        
         
        
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
   
    
    @IBAction func authhorizationAction(_ sender: Any) {
        //let newVC = storyboard?.instantiateViewController(withIdentifier: "swithOnMenu")
        //navigationController?.pushViewController(newVC!, animated: true)
        
    }
    func addBorders(button : UIButton) {
        button.backgroundColor = .clear
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        button.layer.cornerRadius = 5
    }

    override func viewDidAppear(_ animated: Bool) {
       
        addBorders()
        
    }
    
    func downloadTags(url:String,login:String,password: String) {
         
        
        
        let param = ["login" : login, "password": password]
      
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { (response) in
        
        
          
            debugPrint(response)
            switch response.result{
            case.success(let value):
             
                let json = JSON(value)
                let status = json["success"]
                if status == true{
                    self.email = json["email"].stringValue
                    let defaults = UserDefaults.standard
                    defaults.set(self.email, forKey: defaultsKeys.email)
                   
               
           // let general = ViewController()
             //   general.showToast()
               // self.performSegue(withIdentifier:"AuthorizationID", sender: self)
                    
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerId") as! MainViewController
               self.present(viewController, animated: true)
//              et vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeNavID") as? GeneralInfoController
//              self.navigationController?.pushViewController(vc!, animated: true)
                }else {
                    let message = json["message"]
                    self.labelErrorButtom.text = message.stringValue
                    //self.showToast(textToast: message.stringValue, type: 2)
                    
                }
            case .failure(let error):
                self.labelErrorButtom.text = "Неизвестная ошибка, попробуйте ещё раз"
//                ToastUtils.showToast(message:"Неизвестная ошибка, попробуйте ещё раз", view:self.view);
                print (error)
            }
                                                                                                                
        })

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
        
          login = number 
        return number
    }



    @IBAction func showRegesrrationController(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationId") as! RegistrationController
       
        self.present(viewController, animated: true)
    }
    
    @IBAction func showRecoveryController(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RecoveryPassId") as! RecoveryViewController
       
        self.present(viewController, animated: true)
    }
    func showToast(textToast : String, type :Int) {
      print ("widthVie\(self.controllerViewAuthorization.frame.size.width)")
       let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 110, y: 70, width: 150, height: 35))
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
        if type == 1 {
        self.loginBtn.addSubview(toastLabel)
         
        }
        if type == 2 {
            self.passwordBtn.addSubview(toastLabel)
        }
        
        toastLabel.textAlignment = .center;
        
   
   
   }
  

}
extension String{
      func applyPatternOnNumbers(pattern: String) -> String {
           let replacmentCharacter: Character = "#"
           let pureNumber = self.replacingOccurrences( of: "[^۰-۹0-9]", with: "", options: .regularExpression)
           var result = ""
           var pureNumberIndex = pureNumber.startIndex
           for patternCharacter in pattern {
               if patternCharacter == replacmentCharacter {
               guard pureNumberIndex < pureNumber.endIndex else { return result }
               result.append(pureNumber[pureNumberIndex])
               pureNumber.formIndex(after: &pureNumberIndex)
               } else {
                 result.append(patternCharacter)
               }
            }
        return result
     }
}

extension AuthorizationController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        loginBtn.text = customMask.formatStringWithRange(range: range, string: string)
        login = loginBtn.text ?? " "
        return false
    }

}

