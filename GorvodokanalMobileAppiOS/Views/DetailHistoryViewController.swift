//
//  DetailHistoryViewController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 12.11.2021.
//

import UIKit
import Alamofire
import  SwiftyJSON

class DetailHistoryViewController: UIViewController {
    var detailHistoryData = [HistoryMetersData]()
    var detailHistoryDataNew = [HistoryMetersData]()
    var dateCardDetailHistory:String = " "
    var index: Int = 0
    let month  = ["JAN":"Январь","FEB":"Февраль","MAR":"Март", "APR":"Апрель","MAY":"Май","JUN":"Июнь","JUL":"Июль","AUG":"Август","SEP":"Сентябрь","OCT":"Октябрь","NOV":"Ноябрь","DEC":"Декабрь"]
  
    @IBOutlet weak var dateCardDetail: UILabel!
    
    @IBAction func closeDialog(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
 
    
    @IBOutlet weak var detailHistoryCollectionView: UICollectionView!
    
    let detailHistoryMetersCellId = "DetailHistoryCollectionViewCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dateCardDetail.text = dateCardDetailHistory
        dateCardDetail.text = dateLabelDetail()
        detailHistoryDataNew.removeAll()
        let nibCell = UINib(nibName: detailHistoryMetersCellId, bundle: nil)

        detailHistoryCollectionView.register(nibCell, forCellWithReuseIdentifier: detailHistoryMetersCellId)
        detailHistoryCollectionView.delegate = self
        detailHistoryCollectionView.dataSource = self
        
        //print("datehHistory11\(detailHistoryData)")
        
        for item in detailHistoryData{
            if (item.dateCurrentCard == dateCardDetailHistory){
                detailHistoryDataNew.append(item)
                
            }
        }
        
        
        print("datehHistory11\(dateCardDetailHistory)")
        
        
        
        print("dateDet\(dateLabelDetail())")
        dateCardDetailHistory = dateLabelDetail()
    }
    func dateLabelDetail() ->String{
        let subString = dateCardDetailHistory.components(separatedBy: "-")
        let monthIndex = subString[1]
        let yearIndex = subString[2]
        print("subString\(monthIndex)")
        print ("index\(index)")
        //let month =    DateInterval.monthByIndex[index]
        print ("index\(String(describing: month[monthIndex]))")
        let date = month[monthIndex]! + " " + "20" + yearIndex
        detailHistoryCollectionView.backgroundColor = .white
        return date
      
        
    }
    

    
    
}

extension  DetailHistoryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailHistoryDataNew.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 0
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let collectionWidth = view.frame.width
        //UIScreen.main.bounds.width,
        let cellWidth = UIScreen.main.bounds.size.width
        return CGSize(width: cellWidth - 20 ,  height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailHistoryMetersCellId, for: indexPath) as! DetailHistoryCollectionViewCell
        cell.configure(item: detailHistoryDataNew[indexPath.row])
      
        //cell.numberCard = indexPath.row
        //let countData = arrayHistoryItems.count
       // print ("countData", countData)
        //cell.setMeters(numb : countData-1)
        
       // cell.configure(item: arrayHistoryItems[indexPath.row].value)
    
       // cell.configure(item: sumDataArray[indexPath.row])
      
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
    
    
   
}
