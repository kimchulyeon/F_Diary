//
//  StarCell.swift
//  F_Diary
//
//  Created by chulyeon kim on 2023/03/06.
//

import UIKit

class StarCell: UICollectionViewCell {
    
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		self.contentView.layer.cornerRadius = 3
		self.contentView.layer.borderWidth = 1
		self.contentView.layer.borderColor = UIColor.black.cgColor
	}
}
