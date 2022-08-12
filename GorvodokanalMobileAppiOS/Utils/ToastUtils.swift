//
//  ToastUtils.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 06.08.2021.
//

import Foundation
import UIKit

class ToastUtils {
    static func showToast(message: String, view: UIView) {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
       
           
       let cellWidth = UIScreen.main.bounds.size.width/2
       let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2, y: view.frame.size.height-100, width: cellWidth, height: 50))
       
        toastLabel.center = CGPoint(x: screenWidth/2, y: screenHeight-100)
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping

       toastLabel.backgroundColor = UIColor.white.withAlphaComponent(1)
       toastLabel.textColor = UIColor.black
        
       toastLabel.textAlignment = .center;
       toastLabel.text =  message
      
       toastLabel.alpha = 1.0
       toastLabel.layer.cornerRadius = 10;
       toastLabel.clipsToBounds  =  true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toastLabel.isHidden = true
        }
       view.addSubview(toastLabel)
//       UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//       }, completion: {(isCompleted) in
//           toastLabel.removeFromSuperview()
//       })
   }}
