//
//  AppealIndividualsViewController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 07.10.2021.
//

import UIKit
import WebKit
import  HTMLKit

class FullScreenWKWebView: WKWebView {

    override var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            let insects = super.safeAreaInsets
            return UIEdgeInsets(top: insects.top, left: insects.left, bottom: 0, right: insects.right)
        } else {
            return .zero
        }

    }
    override var alignmentRectInsets: UIEdgeInsets{
        let insects = super.alignmentRectInsets
        return UIEdgeInsets(top: insects.top-20, left: insects.left, bottom: -100, right: insects.right)
    }
}



class AppealIndividualsViewController: UIViewController{

    @IBOutlet var webViewContainer: UIView!
    @IBOutlet weak var webView1: WKWebView!
    

    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    @IBAction func showSettingDialog(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsControllerId") as! SettingsController
       self.present(viewController, animated: true) 
        
    }
    @IBOutlet weak var appealPageWebView: WKWebView!
    
    
    
    let contaienrView: UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()

        let webView: FullScreenWKWebView = {
            let v = FullScreenWKWebView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()

        func setupViews(){
            view.addSubview(contaienrView)
            contaienrView.addSubview(webView)
            let constrains = [
                contaienrView.topAnchor.constraint(equalTo: view.topAnchor),
                contaienrView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contaienrView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                contaienrView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

                webView.topAnchor.constraint(equalTo: contaienrView.topAnchor),
                webView.leadingAnchor.constraint(equalTo: contaienrView.leadingAnchor),
                webView.bottomAnchor.constraint(equalTo: contaienrView.bottomAnchor),
                webView.trailingAnchor.constraint(equalTo: contaienrView.trailingAnchor),
                ]
            NSLayoutConstraint.activate(constrains)
        }

        func loadRequest(){
            //let url = URL(string: "https://www.gorvodokanal.com/services/orderMobileApp")!
            guard  let url   = URL(string: "https://www.gorvodokanal.com/services/orderMobileApp") else {
                return
            }
//            url.startAccessingSecurityScopedResource()
            let request = URLRequest(url: url)
            webView.navigationDelegate = self
            webView.addObserver(self, forKeyPath: "bad" , options: .new, context: nil)
            webView.load(request)
        
        }


        override func viewDidLoad() {
            super.viewDidLoad()
            sideMenuButton.target = revealViewController()
            sideMenuButton.action = #selector(self.revealViewController()?.revealSideMenu)
            setupViews()
            loadRequest()
        }
    override func dismiss(animated flag: Bool, completion: (() -> Void)?)
    {
        if self.presentedViewController != nil {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    }
    
   



extension AppealIndividualsViewController: WKNavigationDelegate{
  
    

    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        print("URL:", navigationAction.request.url!)
        let urlValue = navigationAction.request.url!
       
        
             
        let urlComponents = URLComponents(url: urlValue, resolvingAgainstBaseURL: false)
        if urlComponents!.path.hasSuffix("bad.php"){
            let parameterWeWant = urlComponents?.queryItems?.filter({ $0.name == "error" }).first
            print(parameterWeWant?.value ?? "")
            navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "shoeGeneralInfo", sender: self)
            _ = UserDefaults.standard
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let secondViewController = storyboard.instantiateViewController(identifier: "PaymentMetersNavController") as? PaymentMetersController else { return }
            
         
           // Toast(text: messageToast).show()
            secondViewController.messageErrorToast =  "erorsa abon"
            //self.present(secondViewController, animated: true)
            decisionHandler(.allow)
           
            
        }else if urlComponents!.path.hasSuffix("ok.php"){
            navigationController?.popViewController(animated: true)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard storyboard.instantiateViewController(identifier: "PaymentMetersNavController") is PaymentMetersController
    
                else { return }
            
            _ = navigationAction.request.url
            decisionHandler(.allow)
 
        }  else{
            print("errorss")
            decisionHandler(.allow)
            
        }
        


}
}




