//
//  SupportViewController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 10.09.2021.
//

import UIKit
import  Alamofire
import SwiftyJSON

class SupportViewController: UIViewController , UINavigationControllerDelegate{
    @IBOutlet weak var sideMenu: UIBarButtonItem!
    @IBOutlet weak var supportCollectionView: UICollectionView!
    @IBOutlet var supportView: UIView!
    
    @IBOutlet weak var buttonSupport: UIButton!
    @IBOutlet weak var supportTextInput: UITextView!
    
    
    let supportCollectionCellId = "SupportCollectionViewCell"
    var supportDataArray = [SupportData]()
    var question: String = ""
    @IBOutlet weak var textViewQuestion: UITextView!
    
    
    @IBAction func showSettingDialog(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsControllerId") as! SettingsController
       self.present(viewController, animated: true)  
    }
    @IBAction func submitQuestion(_ sender: Any) {
        if !question.isEmpty{
        passDataSupport()
        }
        }
    
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportTextInput.text = "Введите текст вопроса"
        supportTextInput.textColor = UIColor.lightGray
        sideMenu.target = self.revealViewController()
        sideMenu.action = #selector(self.revealViewController()?.revealSideMenu)
        textViewQuestion.delegate = self
        let nibCell = UINib(nibName: supportCollectionCellId, bundle: nil)
        supportCollectionView.register(nibCell, forCellWithReuseIdentifier: supportCollectionCellId)
        supportCollectionView.delegate = self
        supportCollectionView.dataSource = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_ :)))
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gestureRecognizer)
      
      
    
    }
    
    @objc  func gestureFired(_ gesture : UITapGestureRecognizer){
        self.view.endEditing(true)
     
    }
  
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите текст вопроса"
            textView.textColor = UIColor.lightGray
        }
    }
    func getSupportData(){
            AF.request(UrlCollection.GET_INFO_SUPPORT,method: .get).responseJSON(completionHandler: { (response) -> Void in
                
               
                switch response.result{
                case.success(let value):
                let json = JSON(value)
           
                let status = json["success"]
                    if status == true{
                       
                   for i in json["data"].arrayValue {
                  
                    self.supportDataArray.append(SupportData(json: i))
                       }
                    }
                   
                case .failure(_):
                    print("error")
                }
                self.supportCollectionView.reloadData()

                return
            })        }

    func passDataSupport(){
        let param = ["question" : question]
        AF.request(UrlCollection.SET_DATA_QUESTION, method: .post, parameters: param, encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { (response) in
        
            debugPrint(response)
            switch response.result{
            case.success(let value):
             
                let json = JSON(value)
                let status = json["success"]
                if status == true{
                    
                   
                    let alert = UIAlertController(title:"Поддержка", message: "Вопрос отправлен\nОтвет будет дан в разделе 'Поддержка' позже или выслан по электронной почте",  preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "Закрыть окно", style: .default, handler:{(
                        action: UIAlertAction!) in
                        self.navigationController?.popToRootViewController(animated: true)
                    
                    })
                    alert.addAction(okBtn)
                    self.present(alert, animated: true, completion: nil)
               
                    }else {
                    let message = json["message"]
                      
                  print("status", message)
                    
                }
            case .failure(let error):
                print (error)
            }
                                                                                                                
        })    }
    
    
    

}

extension SupportViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      
            getSupportData()
        
     
        return  supportDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 0
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let collectionWidth = view.frame.width
        //UIScreen.main.bounds.width,
        let cellWidth = UIScreen.main.bounds.size.width
        return CGSize(width: cellWidth,  height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: supportCollectionCellId, for: indexPath) as! SupportCollectionViewCell
        cell.configure(item: supportDataArray[indexPath.row])

        return cell
    }
    
}

extension SupportViewController: UITextViewDelegate{


      func textViewDidChange(_ textView: UITextView) {
        self.question = textView.text
        print(question)
        
      }}

