//
//  MoviesViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/9/21.
//

import UIKit
import Alamofire
import  SwiftyJSON



class PassMetersController: UIViewController {
   
    
    var passMeterInputData = [Double]()
    
    @IBOutlet var passMetrsView: UIView!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var passMetersCollectionView: UICollectionView!
    @IBOutlet weak var passMeterDataLabel: UILabel!
    @IBOutlet weak var passMeterDataButton: UIButton!
    let passMetersCellId = "PassMetersCollectionViewCell"
    let headerGeneralInfoCellId = "GeneralInfoHeaderCollectionViewCell"
    var passMettersDataArray = [PassMeterData]()
    var date_Prom: String = ""
    var activityIndicator = UIActivityIndicatorView  (style: UIActivityIndicatorView.Style.medium)
    
    private let button : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Передать", for: .normal)
        button.layer.cornerRadius = 22
        
        
        return button
    }()
    
    @IBOutlet weak var scrollViewPassMeters: UIScrollView!

    
    @IBAction func showSettingsDialog(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsControllerId") as! SettingsController
       self.present(viewController, animated: true)  
    }
    
    override func viewDidLoad() {
   
        super.viewDidLoad()
     
        let nibCell2 = UINib(nibName: headerGeneralInfoCellId, bundle: nil)
        
        
        passMetersCollectionView.register(nibCell2, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerGeneralInfoCellId)
        
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        let nibCell = UINib(nibName: passMetersCellId, bundle: nil)
        passMetersCollectionView.register(nibCell, forCellWithReuseIdentifier: passMetersCellId)
        passMetersCollectionView.delegate = self
        passMetersCollectionView.dataSource = self
        getPassMetersData()
        passMeterDataLabel.text = dateLabel()
        passMeterDataButton.layer.cornerRadius = 5
       
        setupActivityIndicators()
        //registerForKeyboardNotifications()
      // registerForKeyboardNotifications()
       
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_ :)))
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gestureRecognizer)
      
 
//        view.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
//        
//            NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 148).isActive = true
//            NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 39).isActive = true
//  
//    
        passMeterDataButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        passMeterDataButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20).isActive = true
              
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        passMeterDataButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20).isActive = true
    }
    
    @objc  func gestureFired(_ gesture : UITapGestureRecognizer){
        self.view.endEditing(true)
     
    }
  
   

    

    func setupActivityIndicators(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.blue
        view.addSubview(activityIndicator)
    }
    
    
    func dateLabel() ->String{
      
        let  intMonth = (Date().string(format: "MM") as NSString).integerValue
        let  endYear = Date().string(format: "yyyy")
        let month =    DateInterval.monthByIndex[intMonth]
        let date = month + " " + endYear
        return date
        
        
    }
    
    
    
    @IBAction func onSubmit(_ sender: Any) {
        var indicationMap = [Int : String ]()
        var status = 0;
        for cell in passMetersCollectionView.visibleCells   {
            
            let currentCell = cell as! PassMetersCollectionViewCell
            if  currentCell.validate(){
               // indicationArray.insert( (currentCell.userData as NSString).doubleValue, at: currentCell.idCard)
                indicationMap[currentCell.idCard] = (currentCell.userData)
            }else{
                status = 1
            }
    
        }
        if (status != 1){
            setMetersData(items: indicationMap)
        }
       
        print(indicationMap)
        self.passMetersCollectionView.reloadData()
    }
    
    func submitData(){
        self.getPassMetersData()
     
        self.passMetersCollectionView.reloadData()
    }
    
    public func setMetersData(items: [Int : String] ){
        
        let param = ["meters" : items]
        
        AF.request(UrlCollection.SET_METERS, method: .post, parameters: param, encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { (response) in
        
            debugPrint(response)
            switch response.result{
            case.success(let value):
             
                let json = JSON(value)
                let status = json["success"]
                if status == true{
                    self.submitData()
                    let message =  json["message"].string

                print("status", message!)
                    self.showMessage(message: message!)
                    
                    
                    
                    
                // let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerId") as! MainViewController
               // self.present(viewController, animated: true)
               
                    }else {
                     
                    let message = json["message"]
                      
                  print("status", message)
                    
                }
            case .failure(let error):
                print (error)
            }
                                                                                                                
        })
    }
    
    
public func getPassMetersData(){
    passMettersDataArray.removeAll()
    AF.request(UrlCollection.PASS_METERS,method: .get).responseJSON(completionHandler: { [self] (response) -> Void in
        switch response.result{
        case.success(let value):
        let json = JSON(value)
   
        let status = json["success"]
            if status == true{
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
           
                for i in json["data"].arrayValue  {
                   // var value1 = i.1[0]["KOD"].stringValue
                    date_Prom = i["DATE_PROM"].stringValue
                    self.passMettersDataArray.append(PassMeterData(id: i["id"].stringValue, numberUzel: i["NODE"].stringValue, nameMeters: i["N_VODOMER"].stringValue, datePassMeterValue: i["ENTER_DATE"].stringValue, lastMeterValue: i["POKAZ2"].stringValue, typeWater : i["PR_VOD"].intValue, date_Prom: i["DATE_PROM"].stringValue))
            
                }
                self.passMetersCollectionView.reloadData()
                showBannerTextMeters()
            }else{
                ToastUtils.showToast(message:"Неизвестная ошибка, попробуйте ещё раз", view:self.view);
            }
           
        case .failure(_):
            print("error")
        }
        
        return;
    })
    }
   
    func showMessage(message:String){
        let alert = UIAlertController(title:"", message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
      
        present(alert, animated: true, completion: nil)
    }
    
    func showBannerTextMeters(){
        
        if   passMettersDataArray.count == 0{
            passMeterDataButton.removeFromSuperview()
            passMetersCollectionView.removeFromSuperview()
               makeNewLabel(textLabel: " По вашему лицевому счёту не установлены приборы учёта")
        }
        if !date_Prom.isEmpty {
       
        
            let alert = UIAlertController(title:"", message: "Расчет платы за холодное водоснабжение и водоотведение по вашему адресу производит обслуживающая управляющая организация. По этой причине ввод показаний приборов учёта в приложении к сожалению недоступен. Вам следует передавать показания в вашу управляющую организацию.", preferredStyle: .alert)
            alert.view.tintColor = UIColor.red
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okBtn)
            present(alert, animated: true, completion: nil)
            passMeterDataButton.alpha = 0
        }
     
        
      let  day = (Date().string(format: "dd") as NSString).integerValue
     
        if day   > 25 {
            let alert = UIAlertController(title:"", message: "Обращаем Ваше внимание, что показания, переданные после 25 числа, будут учтены при расчете размера платы в следующем расчетном периоде. Переданные показания будут обновлены позже", preferredStyle: .alert)
            alert.view.tintColor = UIColor.red
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okBtn)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    func makeNewLabel(textLabel : String)-> Void{
    
        var noDataLbl : UILabel?
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 290, height: 70))
        noDataLbl?.textAlignment = .center
        noDataLbl?.textColor = UIColor.red
        
        noDataLbl?.font = UIFont(name: "Halvetica", size: 18.0)
        noDataLbl?.numberOfLines = 0
        noDataLbl?.text = textLabel
        noDataLbl?.lineBreakMode = .byTruncatingTail
        noDataLbl?.center = self.view.center
        view.addSubview(noDataLbl!)
        
    }
    

}




extension PassMetersController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @objc public func lisenenChangeInput(input : UITextField){
        
      
      
      
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return passMettersDataArray.count
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: passMetersCellId, for: indexPath) as! PassMetersCollectionViewCell
        cell.delegate = self
        if passMettersDataArray.count > 0{
        cell.idCard = indexPath.row
            cell.configure(nameMetertKnot: passMettersDataArray[indexPath.row].numberUzel, nameMeterVal: passMettersDataArray[indexPath.row].nameMeters, datePassMeter: passMettersDataArray[indexPath.row].datePassMeterValue, lastMeter: passMettersDataArray[indexPath.row].lastMeterValue, typeWater: passMettersDataArray[indexPath.row].typeWater,dateProm: passMettersDataArray[indexPath.row].date_Prom)
            if !date_Prom.isEmpty {
                cell.inputTextField?.removeFromSuperview()
            }
           
        
            
        //let generalItem = generalInfoData[indexPath.row]
//       let datas1 = datas[0]
       // cell.name.text = generalItem.valueKod
        }
        cell.backgroundColor = UIColor.white
         cell.layer.borderColor = UIColor.white.cgColor
         cell.layer.borderWidth = 1
        
        return cell

}
    
}
extension PassMetersController: CollectionViewCellDelegate {

    func collectionViewCell(valueChangedIn textField: UITextField, delegatedFrom cell: PassMetersCollectionViewCell) {
        if let indexPath = passMetersCollectionView.indexPath(for: cell),
           let text = textField.text {
            
            
            print("textField text: \(text) from cell: \(indexPath))")
            print("text33", text)
        }
    }

    func collectionViewCell(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, delegatedFrom cell: PassMetersCollectionViewCell)  -> Bool {
        print("Validation action in textField from cell: \(String(describing: passMetersCollectionView.indexPath(for: cell)))")
        return true
    }

}


