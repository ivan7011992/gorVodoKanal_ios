//
//  ContactsViewController.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 07.10.2021.
//

import UIKit

class ContactsViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var installLabel: UILabel!
    
    @IBOutlet weak var cdsLabel: UILabel!
    
    @IBOutlet weak var sideMenu: UIBarButtonItem!
    
    @IBAction func showSettingDialog(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsControllerId") as! SettingsController
       self.present(viewController, animated: true)  
        
    }
    
    override func viewDidLoad() {
        sideMenu.target = self.revealViewController()
        sideMenu.action = #selector(self.revealViewController()?.revealSideMenu)
        super.viewDidLoad()
        installLabel.minimumScaleFactor = 0.2
        installLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.2
        questionLabel.adjustsFontSizeToFitWidth = true
        cdsLabel.minimumScaleFactor = 0.2
        cdsLabel.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
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
