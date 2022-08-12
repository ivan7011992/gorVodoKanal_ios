//
//  RecoveryViewController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 07.09.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import TLCustomMask
import Toaster
class RecoveryViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet var recoveryControllerView: UIView!
    @IBOutlet weak var loginRecTextField: UITextField!
    
    @IBOutlet weak var recoveryAvtionButton: UIButton!
    @IBOutlet weak var labelErrorRecovery: UILabel!
    var customMask = TLCustomMask()
    var loginRecovery: String = ""
    var emailRecovery:String = ""
    @IBAction func returnAuthController(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func showReferenceKod(_ sender: Any) {
        let alert = UIAlertController(title:"Код абонента", message: "Код вводится в формате *-******", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func recoveryAcvtionButton(_ sender: Any) {
   
        if loginRecovery.isEmpty {
            labelErrorRecovery.text = "Введите код"
        }else{
            labelErrorRecovery.text = ""
            recoveryPassword(login: loginRecovery)
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loginRecTextField.delegate = self
        let screenRect = UIScreen.main.bounds
        let screenHeight = screenRect.size.height
        let screenWidth = screenRect.size.width
        recoveryControllerView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.recoveryControllerView.backgroundColor = UIColor(patternImage: UIImage(named: "fon")!)
        loginRecTextField.attributedPlaceholder = NSAttributedString( string : "Введите логин", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            loginRecTextField.addTarget(self, action: #selector(getLoginRecoveryToTextField), for: .editingChanged)
        addBottomBorderInput(input: loginRecTextField)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        recoveryAvtionButton.layer.cornerRadius = 5
        
        addBottomBorderInput(input: loginRecTextField)
        customMask.formattingPattern = "$$-$$$$$$$"
    }
    
    @objc func getLoginRecoveryToTextField(input: UITextField){
        loginRecovery = input.text ?? ""
    }
    
    
    func recoveryPassword(login: String){
      
        
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: defaultsKeys.email) {
            emailRecovery =  email
        }
        let param = ["kodRec" : login]
        
        
        
        AF.request(UrlCollection.RECOVERY_URL,method: .get, parameters: param).responseJSON(completionHandler: { (response) -> Void in
            
           
            switch response.result{
            case.success(let value):
            let json = JSON(value)
       
            let status = json["success"]
                if status == true{
                    let email =  json["email"].string
                  
                    let alert = UIAlertController(title:"Восстановление пароля", message: "Для восстановления пароля на почтовый ящик" + " " + email! + " " + "выслан временный код. Используйте его при авторизации",  preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "Закрыть окно", style: .default, handler: nil)
                    alert.addAction(okBtn)
                    self.present(alert, animated: true, completion: nil)
                    let message =  json["message"].stringValue
                    ToastUtils.showToast(message: message, view: self.view)
                }
                    let message =  json["message"].stringValue
                    ToastUtils.showToast(message: message, view: self.view)
                
               
            case .failure(_):
            
                let message =  "Ошибка, кода не существует или  некорректные введенные данные"
                Toast(text: message).show()
                print("error")
                
            }
            
            return
        })
          
    
   
        //if status == true{
     
      
           
        // let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerId") as! MainViewController
       // self.present(viewController, animated: true)
       
         
              
           
        
    }
    
    
   
    func addBottomBorderInput(input: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: input.frame.height - 1, width: input.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        input.borderStyle = UITextField.BorderStyle.none
        input.layer.addSublayer(bottomLine)
        
    }
    func addBottomBorders(button : UIButton) {
        let thickness: CGFloat = 2.0
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: button.frame.size.height - thickness, width: button.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.white.cgColor
        button.layer.addSublayer(bottomBorder)
        
        
    }
    func addBorders(button : UIButton) {
        button.backgroundColor = .clear
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        button.layer.cornerRadius = 5
    }
    
    
      
 
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension RecoveryViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        loginRecTextField.text = customMask.formatStringWithRange(range: range, string: string)
        loginRecovery = loginRecTextField.text ?? " "
        return false
        
    }
}

