//
//  SettingsController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 08.09.2021.
//

import UIKit
import Alamofire
import  SwiftyJSON
import TLCustomMask
import LBTATools

class SettingsController: UIViewController {

    @IBOutlet weak var viewSettings: UIView!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var changeEmailButtin: UIButton!
    @IBOutlet weak var closeDialog: UIImageView!
    
    @IBAction func changePassword(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordControllerId") as! ChangePasswordController
       
        self.present(viewController, animated: true)
    }
    @IBAction func changeEmail(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangeEmailControllerId") as! ChangeEmailViewController
       
        self.present(viewController, animated: true)    }
    
  
    @IBAction func removeAccount(_ sender: Any) {
        removeAccount()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSettings.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        closeDialog.isUserInteractionEnabled = true
        closeDialog.addGestureRecognizer(tapGestureRecognizer)
        addBorders(button: changePasswordButton)
        addBorders(button: changeEmailButtin)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_ :)))
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    
    func removeAccount(){
        let defaults = UserDefaults.standard
        var login: String = "";
        if let loginValue = defaults.string(forKey: defaultsKeys.login) {
         
            login = loginValue
        }
        let param = ["login" : login]
      
        AF.request( UrlCollection.REMOVE_ACCOUNT, method: .post, parameters: param, encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { (response) in
        
        
          
            debugPrint(response)
            switch response.result{
            case.success(let value):
             
                let json = JSON(value)
                let status = json["success"]
                if status == true{
                print("status", status)
                    ToastUtils.showToast(message: "Аккаунт удален" , view:self.view);
                    
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AuthControllerId") as! AuthorizationController
                    viewController.modalPresentationStyle = .fullScreen
                   
                    self.present(viewController, animated: true)
//
                }else {
                   
                    ToastUtils.showToast(message: "Не удалось удалить аккаунт" , view:self.view);
                    
                }
            case .failure(let error):
                ToastUtils.showToast(message:"Неизвестная ошибка, попробуйте ещё раз", view:self.view);
                print (error)
            }
                                                                                                                
        })

        
    }
    @objc  func gestureFired(_ gesture : UITapGestureRecognizer){
        self.view.endEditing(true)
     
    }
  
    override func viewDidAppear(_ animated: Bool) {
       
        addBorders(button: changePasswordButton)
        addBorders(button: changeEmailButtin)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView

        self.dismiss(animated: true, completion: nil)
    }
    
    func addBorders(button : UIButton) {
        button.backgroundColor = .clear
        button.layer.borderWidth = 1.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
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
