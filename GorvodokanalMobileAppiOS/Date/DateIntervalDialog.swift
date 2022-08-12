//
//  ChangeDateViewControllerHistoryMeters.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 10.07.2021.
//

import UIKit
import Toaster



var dateArray: [String:String] = ["beginMonth" : "", "beginYear":"","endMonth" : "", "endYear" : ""]


class DateIntervalDialog: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    var datesValue = DateInterval()
    var delegate : ((DateInterval) -> Void)? = nil
          
    @IBOutlet weak var changePeriodLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var beforeLabel: UILabel!
    @IBAction func getHistoryaData(_ sender: Any) {
        if(!datesValue.isValid()) {
            Toast(text: "Дата начала периода не может быть больше даты конца периода").show()
            
            return
        }
        self.dismiss(animated: true, completion: nil)
        if delegate != nil {
        self.delegate!(datesValue)
        }
        
           }
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pikerView1: UIPickerView!
    @IBOutlet weak var pikerView2: UIPickerView!
    @IBOutlet weak var changeDateView: UIView!
    @IBOutlet weak var closeDialog: UIImageView!
    
       
 
    override func viewDidLoad() {
        super.viewDidLoad()
        pikerView1.delegate = self
        pikerView1.dataSource =  self
        pikerView2.delegate = self
        pikerView2.dataSource = self
        changeDateView.layer.cornerRadius = 10
        
       
      let selectedBeginYear =   DateInterval.indexByYear(year: datesValue.beginYear)
        let selectedEndYear =   DateInterval.indexByYear(year: datesValue.endYear)
        pikerView1.selectRow(selectedBeginYear, inComponent: 1, animated: false)
        pikerView2.selectRow(selectedEndYear, inComponent: 1, animated: false)
        
        pikerView1.selectRow(datesValue.beginMonth, inComponent: 0, animated: false)
        pikerView2.selectRow(datesValue.endMonth, inComponent: 0, animated: false)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        closeDialog.isUserInteractionEnabled = true
        closeDialog.addGestureRecognizer(tapGestureRecognizer)
        
        changePeriodLabel.adjustsFontSizeToFitWidth = true
        changePeriodLabel.minimumScaleFactor = 0.5
        fromLabel.adjustsFontSizeToFitWidth = true
        fromLabel.minimumScaleFactor = 0.5
        beforeLabel.adjustsFontSizeToFitWidth = true
        beforeLabel.minimumScaleFactor = 0.5
        pikerView1.setValue(UIColor.black, forKeyPath: "textColor")
        pikerView2.setValue(UIColor.black, forKeyPath: "textColor")
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dissmissDialog(_ sender: Any) {
        self.changeDateView.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if  pickerView  == pikerView1{
            return 2}
        else if pickerView == pikerView2 {
            return 2
        }
        return 0
    }
    
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pikerView1{
            if component == 0 {
                return DateInterval.month.count
            }else   {
                return DateInterval.years.count
            }
        }
        else if pickerView == pikerView2{
            if component == 0 {
                return DateInterval.month.count
            }else  {
                return DateInterval.years.count
            }
        }
        return 0
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pikerView1{
            if component == 0 {
                
                return DateInterval.monthByIndex[row]
            }else {
                
                return String(DateInterval.years[row])
            }
            
        } else if pickerView == pikerView2{
                if component == 0 {
                    
                    return DateInterval.monthByIndex[row]
                }else {
                    
                    return String(DateInterval.years[row])
                }
            
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pikerView1{
            if component == 0 {
        
                datesValue.beginMonth = row
               
            
            } else {
                datesValue.beginYear  =  DateInterval.years[row]
            }
        } else if pickerView == pikerView2{
            if component == 0{
                datesValue.endMonth = row
            }else {
                datesValue.endYear = DateInterval.years[row]
            }
            
        }
    }
    
    
    
    
    
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


