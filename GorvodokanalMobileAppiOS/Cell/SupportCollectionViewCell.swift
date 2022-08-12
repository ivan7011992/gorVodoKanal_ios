//
//  SupportItemsCollectionViewCell.swift
//  GorvodokanalMobileAppiOS
//
//  Created by AppMobile on 09.09.2021.
//

import UIKit

class SupportCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var dateAppeal: UILabel!
    @IBOutlet weak var question: UILabel!
   
    
    @IBOutlet weak var answer: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }
    
    func configure (item: SupportData){
        dateAppeal.text = String(item.dateAppeal)
        question.text = String(item.question)
      
    
      
        answer.text = String(item.answer)
      
 
    }
}
