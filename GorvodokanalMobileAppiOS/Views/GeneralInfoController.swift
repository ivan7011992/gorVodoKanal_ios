//
//  ViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/§/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Sentry

 
class GeneralItemModel{
    var kod : [String]
    var kvartira : [String]
    
    
    init(kod : [String], kvartira: [String] ){
    
    self.kod = kod
        self.kvartira = kvartira
    
    }
    
}

class GeneralInfoController: UIViewController {
    var heightHeader: CGFloat = 0
    var  stackViewHeight : CGFloat = 0
    var IPU: Int = 0
    let url = "https://www.gorvodokanal.com/mobile_app/general_info.php"
    let generalDataCellId = "GeneralInfoCollectionViewCell"
    let headerGeneralInfoCellId = "GeneralInfoHeaderCollectionViewCell"
    let numberMeterArray:[String] = ["1234","456"]
    let typeMeterArray:[String] = ["Холодная","Горячая"]
    let dateInstallArray: [String] = ["12.04.2020","12.05.2020"]
    let dateVarifiaArray: [String] = ["01.05.2019","01.12.2019"]
    var headerHeight: CGFloat = 0
    var data : GeneralInfoData? = nil
    var generatItemData = [GeneralItemModel]()
    var activityIndicator = UIActivityIndicatorView  (style: UIActivityIndicatorView.Style.medium)
    var email:String = ""
    @IBAction func closeDialog(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var generalInfoControllerView: UICollectionView!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
   let layout = UICollectionViewFlowLayout()
   
  //  @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var CollectionViewGeneralData: UICollectionView!
  
    
    @IBAction func showSettingController(_ sender: Any) {
        
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsControllerId") as! SettingsController
        self.navigationController?.pushViewController(viewController, animated: true)    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Menu Button Tint Color
        navigationController?.navigationBar.tintColor = .white
        setupActivityIndicators()
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
     
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
       
       // let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       // CollectionViewGeneralData.isScrollEnabled = false
        let nibCell2 = UINib(nibName: headerGeneralInfoCellId, bundle: nil)
     
         CollectionViewGeneralData.register(nibCell2, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerGeneralInfoCellId)
        let nibCell = UINib(nibName: generalDataCellId, bundle: nil)
        CollectionViewGeneralData.register(nibCell, forCellWithReuseIdentifier: generalDataCellId)
      
        
        CollectionViewGeneralData.delegate = self
        CollectionViewGeneralData.dataSource = self
        let   general = GeneralInfoHeaderCollectionViewCell()
         heightHeader =  general.getViewHeaderHeight()
        
        getDataUser();
        getDataGeneralInfo();
        
        
//        let screenRect = UIScreen.main.bounds
//        let screenWidth = screenRect.size.width
//        print("general\(screenWidth)")
//        generalInfoControllerView.frame =  CGRect(x: 0, y: 0, width: 300, height: 100)
//        let error = NSError(domain: "YourErrorDomain", code: 0, userInfo: nil)
//        SentrySDK.capture(error: error)
   
       
    }
 

    func setupActivityIndicators(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.blue
        view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController()?.gestureEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        self.revealViewController()?.gestureEnabled = true
    }
    override func didReceiveMemoryWarning() {
        print("warning111")
        super.didReceiveMemoryWarning()
    }
  

    func getDataUser(){
        
        // let cookieStorage = AF.session.configuration.httpCookieStorage?.cookies
       
        AF.request(UrlCollection.GET_USER_DATA,method: .get).responseJSON(completionHandler: { [self] (response) -> Void in
            switch response.result{
            case.success(let value):
            let json = JSON(value)
            
            let status = json["success"]
                if status == true{
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                
            
                        self.email = json["email"].stringValue
                    let defaults = UserDefaults.standard
                    defaults.set(email, forKey: defaultsKeys.email)
                        print (email )
                
                    
             
                
                }else{
                    ToastUtils.showToast(message:"Неизвестная ошибка, попробуйте ещё раз", view:self.view);
                }
               
            case .failure(_):
                print("error")
            }
            
            return
        })

}
    
    
    func getDataGeneralInfo(){
        
        // let cookieStorage = AF.session.configuration.httpCookieStorage?.cookies
       
        AF.request(UrlCollection.GENERAL_INFO_URL,method: .get).responseJSON(completionHandler: { [self] (response) -> Void in
            switch response.result{
            case.success(let value):
            let json = JSON(value)
                
       
            let status = json["success"]
                if status == true{
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    var datas: [GeneralInfoDataItem] = []
                  
                    
                  
                    for i in json["data"].arrayValue  {
                       // var value1 = i.1[0]["KOD"].stringValue
                        self.IPU =  Int((i["IPU"]).stringValue)!
                        datas.append(GeneralInfoDataItem(json: i))
                        
                        print ("array", IPU)
                
                    }
             
                    let header: GeneralInfoDataHeader =  GeneralInfoDataHeader(json: json["data"].arrayValue[0])
                    self.data = GeneralInfoData(header: header, items: datas)
                     
                    self.CollectionViewGeneralData.reloadData()
                }else{
                    ToastUtils.showToast(message:"Неизвестная ошибка, попробуйте ещё раз", view:self.view);
                }
              
               
            case .failure(_):
                print("error")
           
            }
            
            return
        })

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

//struct datatype : Identifiable{
//    var id: String
//    var kod : String
//    var  kvartira : String
//    
//}


extension GeneralInfoController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: generalDataCellId, for: indexPath) as! GeneralInfoCollectionViewCell
        
        //let generalItem = datas
        
      //  var kod :String = generalItem[0].numberMeter
        
       
      //  print("1234",kod)
//       let datas1 = datas[0]
        if (data == nil){
            print("data not found")
        return cell
        }
        cell.configure(item:self.data!.items[indexPath.row])
        cell.layoutIfNeeded()
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        //cell.numberMeter.text = kod
        return cell    }
    
    
 
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if IPU == 0{
        return 0
        }
      
        return data!.items.count

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 10
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let collectionWidth = view.frame.width
        //UIScreen.main.bounds.width,
        
        let cellWidth = UIScreen.main.bounds.size.width 
        return CGSize(width: cellWidth,  height: 150)
    }
       
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header =   collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerGeneralInfoCellId, for: indexPath) as!GeneralInfoHeaderCollectionViewCell
        if (data == nil){
            return header
        }
        self.headerHeight = header.generalStackView.frame.height
        heightHeader =  header.generalStackView.frame.height
        
        header.configure(item: data!.header)
        heightHeader =   header.getViewHeaderHeight()
        stackViewHeight = header.generalStackView.frame.height
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
         let indexPath = IndexPath(row: 0, section: section)
        _ = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        let cellWidth = UIScreen.main.bounds.size.width
        
        _ = stackViewHeight
        
        return CGSize(width: cellWidth, height: stackViewHeight + 190)
    }
 
 
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let generalItem = generalInfoData[indexPath.row]
       // print("\(indexPath.row) - \(generalItem.numberMeter)")
    }
    
    
  }


