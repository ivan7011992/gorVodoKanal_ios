//
//  MusicViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/9/21.
//

import UIKit
import Alamofire
import  SwiftyJSON

class HistoryMetersController: UIViewController{
   let numberMeterArray:[String] = ["123","456"]
    let typeMeterArray:[String] = ["Холодная","Горячая"]
    var interval = DateInterval()
    var arrayDataForDetailHistoryMeters = [HistoryMetersData]()
    typealias sumData = (key : String , value : HistoryMetersDateSummary)
    var  arrayHistoryItems: [sumData] = []
    var dateDetailHistoryCard = [String]()
    var activityIndicatorHistory = UIActivityIndicatorView  (style: UIActivityIndicatorView.Style.medium)
    
    @IBAction func closeHistory(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    var sumData = [ String : HistoryMetersDateSummary]()
    var sumDataArray = [HistoryMetersDateSummary]()
    var data : HistoryMetersData? = nil
   
    @IBOutlet weak var changeDateButton: UIButton!
    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    
    @IBAction func chageDateDialog(_ sender: Any) {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CahngeDateController") as? ChangeDateViewControllerHistoryMeters
//        self.navigationController?.pushViewController(vc!, animated: true)
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "CahngeDateController") as! DateIntervalDialog
        viewController.delegate = { (interval : DateInterval) -> Void in
            print(interval.beginMonth)
            self.interval = interval
            self.getData(interval: self.interval)
            self.changeDateButton.setTitle(interval.getDateBeginLabel() + "-" + interval.getDateEndLabel(), for: .normal)
        }
        self.present(viewController, animated: true)
 
    }
    @IBOutlet weak var historyMettersCollectionView: UICollectionView!
    
    let historyMetersCellId = "HistoryMettersCollectionViewCell"
    
    
    var arrayHistoryData = [String]()
    var generalInfoData = [GeneralInfoData]()
    
    @IBAction func showSettingsDialog(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsControllerId") as! SettingsController
       self.present(viewController, animated: true)  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        self.sideMenuBtn.target = revealViewController()
        self.sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        let nibCell = UINib(nibName: historyMetersCellId, bundle: nil)
        activityIndicatorHistory.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        
        historyMettersCollectionView.register(nibCell, forCellWithReuseIdentifier: historyMetersCellId)
        historyMettersCollectionView.delegate = self
        historyMettersCollectionView.dataSource = self

        getData(interval: self.interval)
        changeDateButton.setTitle(interval.getDateBeginLabel() + "-" + interval.getDateEndLabel(), for: .normal)
        changeDateButton.titleLabel?.minimumScaleFactor = 0.4
        changeDateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        setupActivityIndicators()
     
    }
    
    func setupActivityIndicators(){
    
 
        activityIndicatorHistory.center = self.view.center
        activityIndicatorHistory.hidesWhenStopped = true
        activityIndicatorHistory.style = .large
        activityIndicatorHistory.color = UIColor.blue
       
        view.addSubview(activityIndicatorHistory)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController()?.gestureEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController()?.gestureEnabled = true
    }

    
    
    func  getData(interval: DateInterval){
        arrayHistoryItems.removeAll()
        let param = ["beginDate" : interval.beginDate(),"endDate":interval.endDate()]
     print("")
        AF.request(UrlCollection.HISTORY_METERS,method: .get, parameters: param).responseData{ [self] (data) in
            let json = try! JSON(data: data.data!)
             var datas = [HistoryMetersData]()
            self.activityIndicatorHistory.stopAnimating()
            self.view.isUserInteractionEnabled = true
       
        for i in json["data"].arrayValue {
                
            datas.append(HistoryMetersData(json: i))
           
            print("данные  \(datas)")
            
            }
        var j = 0
      
            arrayDataForDetailHistoryMeters.removeAll()
        for  i in datas{
            
            let dateValue = i.dateCurrentCard
            arrayDataForDetailHistoryMeters.append(i)
           // let historyMetersDataSummary = HistoryMetersDateSummary(date: "dateValue", items: [])
           // arrayHistoryItems.append((key : "" , value : historyMetersDataSummary))
            if  arrayHistoryItems.count == 0 {
                let historyMetersDataSummary = HistoryMetersDateSummary(date: dateValue, items: [i])
                let historyRow = (key: i.dateCurrentCard, value:historyMetersDataSummary)
            
                self.arrayHistoryItems.append(historyRow)
                continue
                
            }
                if self.arrayHistoryItems[j].key == dateValue {
                self.arrayHistoryItems[j].value.items.append(i)
              
                }
             else {
                j += 1
                    let historyMetersDataSummary = HistoryMetersDateSummary(date: dateValue, items: [i])
                let historyRow = (key: i.dateCurrentCard, value:historyMetersDataSummary);
                 self.arrayHistoryItems.append(historyRow)
                
                
                
                print ("arrayHistory",self.arrayHistoryItems)
            }
        }
        
        for sumDataValues in self.sumData.values {
            self.sumDataArray.append(sumDataValues)
          
        }
        
       
        self.historyMettersCollectionView.reloadData()
        print("hsitoryJson",json)
        
        
         
            return ;
            }
        
    }
    @objc func showDetailHistory (detailButton : UIButton){
        print("tag\(detailButton.tag)")
       print("okeeyyyyyyyy\(dateDetailHistoryCard)")
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailHistoryContollerId") as! DetailHistoryViewController
        viewController.dateCardDetailHistory = dateDetailHistoryCard[detailButton.tag]
        viewController.detailHistoryData = arrayDataForDetailHistoryMeters
        viewController.index = detailButton.tag
        
        print("данные1 \(arrayDataForDetailHistoryMeters)")
       self.present(viewController, animated: true)  
   
    }
    
}

extension  HistoryMetersController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayHistoryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 0
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let collectionWidth = view.frame.width
        //UIScreen.main.bounds.width,
        let cellWidth = UIScreen.main.bounds.size.width
        return CGSize(width: cellWidth,  height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: historyMetersCellId, for: indexPath) as! HistoryMettersCollectionViewCell
      
        cell.numberCard = indexPath.row
        let countData = arrayHistoryItems.count
        print ("countData", countData)
        cell.setMeters(numb : countData-1)
        cell.configure(item: arrayHistoryItems[indexPath.row].value)
        if cell.details != nil{
            dateDetailHistoryCard.append( cell.dateCard)
            print("datailDate\(dateDetailHistoryCard)")
        cell.details.tag = indexPath.row
        cell.details.addTarget(self, action: #selector(showDetailHistory), for: .touchUpInside)
   
        }
       // cell.configure(item: sumDataArray[indexPath.row])
       cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
 
    
    
   
}

extension HistoryMetersController : HisotyMetersViewDekegate{
    func showDetaiHistoryDialog(cell: HistoryMettersCollectionViewCell) {
        print("gggggggg")
    }
    
   
    
    
}
//
//extension  Date {
//    var month: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-yy"
//        return dateFormatter.string(from: self)
//    }
//    var year: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy"
//        return dateFormatter.string(from: self)
//    }}









