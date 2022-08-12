//
//  BooksViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/9/21.
//
import Foundation
import UIKit
import Alamofire
import  SwiftyJSON
import Toaster

class PaymentMetersController: UIViewController {

    @IBOutlet weak var sideMenu: UIBarButtonItem!
    var paymentSum: Double = 0.0
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var paymentCollevtionView: UICollectionView!
    @IBOutlet weak var paymentDateLabel: UILabel!
    var activityIndicator = UIActivityIndicatorView  (style: UIActivityIndicatorView.Style.medium)
    @IBOutlet weak var paymentLabelSum: UILabel!
    var messageErrorToast:String = ""
    var indexCell = 0
    var sum:Double = 0.0;
    var sumDept:Double = 0.0
    var paymentDataArray = PaymentMeterDataSum(items: [])
    let paymentCollectionCellId = "PaymentCollectionViewCell"
    weak var delegate : PaymentPageController?
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func showSettingDialog(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsControllerId") as! SettingsController
       self.present(viewController, animated: true)  
    }

    
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        sideMenu.target = self.revealViewController()
        sideMenu.action = #selector(self.revealViewController()?.revealSideMenu)
        let nibCell = UINib(nibName: paymentCollectionCellId, bundle: nil)
        paymentCollevtionView.register(nibCell, forCellWithReuseIdentifier: paymentCollectionCellId)
        paymentCollevtionView.delegate = self
        paymentCollevtionView.dataSource = self
        paymentButton.layer.cornerRadius = 5
        
            getPaymentData()
        
        print("paymentDataArray\(paymentDataArray)")
        paymentDateLabel.text = dateLabelPayment()
        
        let defaults = UserDefaults.standard
        let messageToast = " "
        defaults.set(messageToast, forKey: defaultsKeys.messagePayemnt)
        self.setupActivityIndicators()
      
        paymentButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        
       
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
        print ("message\(messageErrorToast)")
     
        let defaults = UserDefaults.standard
        if let paymentMessage = defaults.string(forKey: defaultsKeys.messagePayemnt) {
            self.showErrorPayment(text:paymentMessage)
        }
        }
    
    
    private func showErrorPayment(text:String){
        showToast(textToast: text)
    }
    
    func setSumPaymenttoLabel(dept:Double){
        if (dept < 0){
            sumDept = 0
        }else{
            sumDept = dept
        }
      
         
            paymentLabelSum.text = String("К оплате: \(sumDept) руб.")
        
        
    }
    
    func dateLabelPayment() ->String{
      
        let  intMonth = (Date().string(format: "MM") as NSString).integerValue
        let  endYear = Date().string(format: "yyyy")
        let month =    DateInterval.monthByIndex[intMonth]
        let date = month + " " + endYear
        return date
        
        
    }
    
    @IBAction func actionButtonPayment(_ sender: Any) {
        //let viewController = storyboard?.instantiateViewController(withIdentifier: "PayPageContoller") as! PaymentPageController
        //self.present(viewController, animated: true)
        var paymentItemsMap = [Int : String ]()
        for cell in paymentCollevtionView.visibleCells   {
            
            let currentCell = cell as! PaymentCollectionViewCell
            if  currentCell.validate(){
               // indicationArray.insert( (currentCell.userData as NSString).doubleValue, at: currentCell.idCard)
                paymentItemsMap[currentCell.idCard] = (currentCell.userData)
              
                
                
            }
            
        } 
        print ("payment1", sumDept )
        if (sumDept <= 0){
            showMessage(message: "Сумма оплаты не должна быть  равна нулю")
               return
        }
            setMetersDataPay(items: paymentItemsMap)
       
     
        
    }
    
   
    
    public func setMetersDataPay(items: [Int : String] ){
       
    
        AF.request(UrlCollection.PAYMENT_GENERATE_URL, method: .post, parameters: items, encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { (response) in
        
            debugPrint(response)
            switch response.result{
            case.success(let value):
             
                let json = JSON(value)
                let status = json["success"]
                if status == true{
                    
                    let url =  json["url"].string
                      
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    
                    guard let payPageContoller = mainStoryboard.instantiateViewController(withIdentifier: "PayPageContoller") as? PaymentPageController
                    
                    else {
                       print ("Couldn't find the view controller")
                        return
                    }
                    payPageContoller.urlString = url ?? ""
                    self.navigationController?.pushViewController(payPageContoller, animated: true)
            
                   //let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PayPageContoller") as! PaymentPageController
                  // viewController.urlString = url ?? ""
                  //  self.present(viewController, animated: true)
                
             
                    }else {
                    let message = json["message"]
                      
                  print("status", message)
                    
                }
            case .failure(let error):
                print (error)
            }
                                                                                                                
        })
    }
    public func  getPaymentData(){
        
        AF.request(UrlCollection.PAYMENT_METERS,method: .get).responseJSON(completionHandler: { [self] (response) -> Void in
            switch response.result{
            case.success(let value):
            let json = JSON(value)
       
            let status = json["success"]
                if status == true{
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    for i in json["data"].arrayValue  {
                        let sumDept =  toDouble(jsonString:i["SALDO_BEGIN"].stringValue).rounded(toPlaces: 4)  +
                        toDouble(jsonString:i["NACHISLENO"].stringValue).rounded(toPlaces: 4) -
                        toDouble(jsonString:i["OPLATA"].stringValue).rounded(toPlaces: 4)
                        
                        sum += sumDept
                        
                        print("json1",sum)
                        
                        self.paymentDataArray.items.append(PaymentMeterData(json: i))
                      
                      
                      
                    
                    }
                    if (sum < 0){
                        paymentLabelSum.text = String("К оплате: 0 руб")
                    }else{
                        paymentLabelSum.text = String("К оплате: \(sum) руб.")
                    }
                  
                    sumDept = sum
                    self.paymentCollevtionView.reloadData()
                    showBannerTextMeters()
                    //var datas =  self.datas
                     // var kod = self.datas
                     // print (datas[0].kod)
                }else{
                    showToast(textToast:"Неизвестная ошибка, попробуйте ещё раз");
                }
               
            case .failure(_):
                print("error")
            }
            
            return;
        })
       
          }
    func showToast(textToast : String) {
        print ("widthVie\(self.view.frame.size.width)")
       let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 190, y: -100, width: 200, height: 35))
       toastLabel.backgroundColor = UIColor.blue.withAlphaComponent(1)
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
       
        self.paymentButton.addSubview(toastLabel)
       
   }
    func showMessage(message:String){
        let alert = UIAlertController(title:"", message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    
    func showBannerTextMeters(){
        if   paymentDataArray.items.count == 0{
             
        }
        
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
    
   

    }



extension PaymentMetersController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @objc public func lisenenChangeInput(input : UITextField){
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentDataArray.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 0
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let collectionWidth = view.frame.width
        //UIScreen.main.bounds.width,
        print("ura\(indexPath)")
        let cellWidth = UIScreen.main.bounds.size.width
        return CGSize(width: cellWidth,  height: 180)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: paymentCollectionCellId, for: indexPath) as! PaymentCollectionViewCell
//        paymentLabelSum.text = cell.userData
//    }
  
    private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: paymentCollectionCellId, for: indexPath as IndexPath) as! PaymentCollectionViewCell
        // Perform any action you want after a cell is tapped
        // Access the selected cell's index with the indexPath.item value
        print("indexRow\(indexPath)")
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: paymentCollectionCellId, for: indexPath) as! PaymentCollectionViewCell
        print("indexd\( indexPath)")
       
        cell.delegate = self
   
      
//        if paymentDataArray.items.count > 0{
//
//            if(indexPath.row == 0){
//
//
//                cell.configureCard0(item: paymentDataArray)
//                if let textfield = cell.amountToPayTextField{
//               // cell.amountToPayTextField.removeFromSuperview()
//                }
//                cell.labelServiceType.backgroundColor = .white
//            }
//            }
    
            if(indexPath.row >= 0){

                if indexPath.row == 0 {
                    cell.configure(item: paymentDataArray.items[indexPath.row])
                    //cell.configureCard0(item: paymentDataArray)
//                    if let textField = cell.amountToPayLabel{
//                    cell.amountToPayLabel.removeFromSuperview()
//                        
//                    }
                    if cell.amountToPayLabel != nil{
                    cell.amountToPayLabel.removeFromSuperview()
                        
                    }
                    
                }else{
                    cell.configure(item: paymentDataArray.items[indexPath.row])
                  
                    if cell.amountToPayLabel != nil{
                    cell.amountToPayLabel.removeFromSuperview()
                        
                    }
                }
                
            
            }

        //let generalItem = generalInfoData[indexPath.row]
//       let datas1 = datas[0]
       // cell.name.text = generalItem.valueKod
        
        cell.backgroundColor = UIColor.white
         cell.layer.borderColor = UIColor.white.cgColor
         cell.layer.borderWidth = 1
        
        return cell
    }
    
    func showErrorToastOfPayment(message : String){
        ToastUtils.showToast(message: "dssdds", view: self.view)
    }

    func dateLabelpayment() ->String{
      
        let  intMonth = (Date().string(format: "MM") as NSString).integerValue
        let  endYear = Date().string(format: "yyyy")
        let month =    DateInterval.monthByIndex[intMonth]
        let date = month + " " + endYear
        return date
        
        
    }
}



extension PaymentMetersController: CollectionViewCellDelegatePayment {
    func collectionViewCell(textField: UITextField, delegatedFrom cell: PaymentCollectionViewCell) {
        
        
        
        _ = paymentCollevtionView.indexPath(for: cell)?.row
       
//        if index == 0{
//            cell.amountToPayLabel.text = "555"
//        }
        
        if let indexPath = paymentCollevtionView.indexPath(for: cell),
           let text = textField.text {
            cell.amountToPayTextField?.placeholder =  "0"
            let  dept =   Double(text) ?? 0
            cell.deptTextFeidl = dept
            
            
            print("textField text: \(text) from cell: \(indexPath)) indexPatd: \(indexPath)")
            print("text33",   cell.deptTextFeidl )
           
                sumDept = 0
            
            for cell in paymentCollevtionView.visibleCells {
             // let indexPath = paymentCollevtionView.indexPath(for: cell)
             //   if indexPath?.row != 0 {
               
                    let currentCell = cell as! PaymentCollectionViewCell
               sumDept +=  currentCell.deptTextFeidl
                    setSumPaymenttoLabel(dept: sumDept)
              print ("dept5\(sumDept)"
              )
           
             //   }
                    }
        
//            for cell in paymentCollevtionView.visibleCells {
//
//                let indexPath = paymentCollevtionView.indexPath(for: cell)
//                if indexPath?.row == 0 {
//                    let currentCell = cell as! PaymentCollectionViewCell
//                    if let a = currentCell.amountToPayLabel{
//                    currentCell.amountToPayLabel.text = String(sumDept)
//                    }
//
//
//                }
//                    }
        }
    }
    
    func collectionViewCell(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, delegatedFrom cell: PaymentCollectionViewCell) -> Bool {
        print("Validation action in textField from cell: \(String(describing: paymentCollevtionView.indexPath(for: cell)))")
        return true
    }
 
}

extension PaymentMetersController: UITextFieldDelegate {

    
  
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

      
        
          
               // indicationArray.insert( (currentCell.userData as NSString).doubleValue, at: currentCell.idCard)
            for cell in paymentCollevtionView.visibleCells {
                        if let cell = cell as? PaymentCollectionViewCell,
                            let text = textField.text,
                            (cell.amountToPayLabel != nil) {
                            cell.amountToPayLabel.text =  "000"
                        }
                    }

                
                
              return true
                
    }
    

    }

