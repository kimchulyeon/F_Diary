//
//  DiaryCell.swift
//  F_Diary
//
//  Created by chulyeon kim on 2023/03/06.
//

import UIKit

class DiaryCell: UICollectionViewCell {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		self.contentView.layer.cornerRadius = 3.0
		self.contentView.layer.borderWidth = 1.0
		self.contentView.layer.borderColor = UIColor.black.cgColor
	}
}
