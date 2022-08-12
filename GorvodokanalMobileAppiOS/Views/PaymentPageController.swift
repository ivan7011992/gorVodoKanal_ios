//
//  PaymentPageController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 27.08.2021.
//

import UIKit
import WebKit
import Combine
import Toaster
 



class PaymentPageController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var pagePaymentView: UIView!
    
    @IBOutlet weak var webView1: UILabel!
    var urlString = ""
    var messageToast = ""
  
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
    }()
        
        override func viewDidLoad() {
              
        guard  let url   = URL(string: urlString) else {
            return
        }
        super.viewDidLoad()
        view.addSubview(webView)
          

 //           let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
          //  if let components = components {
          

//                if let queryItems = components.queryItems
//                {
//                    var bad = queryItems[3].value
//                    print ("bad" , bad )
//
//                    for queryItem in queryItems {
//
//                        print ("urlParse","\(queryItem)")
//                        print("\(queryItem.name): \(queryItem.value)")
//
//                    }
//
//                }
//            }
           
            webView.navigationDelegate = self
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
           
        webView.load(URLRequest(url: url))
          

            
    }
  
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] as? NSObject{
            
            print("observeValue \(key)") // url value
            
            
           
  
            
        }
        
        
    }
    
    
   
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func showToast1(){
        print("4343")
        ToastUtils.showToast(message: "ddfdfd", view: self.view)
    }
    
}


extension  PaymentPageController: WKNavigationDelegate{
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
     
        let urlValue = navigationAction.request.url!
       
        
             
        let urlComponents = URLComponents(url: urlValue, resolvingAgainstBaseURL: false)
        if urlComponents!.path.hasSuffix("bad.php"){
            let parameterWeWant = urlComponents?.queryItems?.filter({ $0.name == "error" }).first
            print(parameterWeWant?.value ?? "")
            navigationController?.popToRootViewController(animated: true)
            messageToast = parameterWeWant?.value ?? ""
            let defaults = UserDefaults.standard
        
            defaults.set(messageToast, forKey: defaultsKeys.messagePayemnt)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let secondViewController = storyboard.instantiateViewController(identifier: "PaymentMetersNavController") as? PaymentMetersController else { return }
           // Toast(text: messageToast).show()
            secondViewController.messageErrorToast =  "erorsa abon"
            //self.present(secondViewController, animated: true)
            decisionHandler(.allow)
            self.pagePaymentView.removeFromSuperview()
            
        }else if urlComponents!.path.hasSuffix("ok.php"){
            navigationController?.popToRootViewController(animated: true)
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                guard let secondViewController = storyboard.instantiateViewController(identifier: "PaymentMetersNavController") as? PaymentMetersController
//
//                else { return }
//
//            let currentUrl = navigationAction.request.url
            decisionHandler(.allow)
            self.pagePaymentView.removeFromSuperview()
        }  else{
            print("errorss")
            decisionHandler(.allow)
            
        }
        


}
}



