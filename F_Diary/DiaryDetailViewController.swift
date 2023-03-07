//
//  DiaryDetailViewController.swift
//  F_Diary
//
//  Created by chulyeon kim on 2023/03/06.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
	func didSelectDelete(indexPath: IndexPath)
}

class DiaryDetailViewController: UIViewController {
	//MARK: - properties ==================
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentsTextView: UITextView!
	@IBOutlet weak var dateLabel: UILabel!
	
	var diary: Diary?
	var indexPath: IndexPath?
	var delegate: DiaryDetailViewDelegate?
	
	//MARK: - lifecycle ==================
    override func viewDidLoad() {
        super.viewDidLoad()

		self.configureView()
    }
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	//MARK: - func ==================
	private func configureView() {
		guard let diary = self.diary else { return }
		self.titleLabel.text = diary.title
		self.contentsTextView.text = diary.contents
		self.dateLabel.text = self.dateToString(date: diary.date)
	}
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yy년 MM월 dd일 (EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
	
	//MARK: - action ==================
	@IBAction func tapEditButton(_ sender: Any) {
		guard let vc = self.storyboard?.instantiateViewController(identifier: "AddDiaryViewController") as? AddDiaryViewController else { return }
		guard let indexPath = self.indexPath else { return }
		guard let diary = self.diary else { return }
		vc.diaryEditorMode = .edit(indexPath, diary)
		
		NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: NSNotification.Name("editDiary"), object: nil)
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
	@IBAction func tapDeleteButton(_ sender: Any) {
		guard let indexPath = self.indexPath else { return }
		self.delegate?.didSelectDelete(indexPath: indexPath)
		self.navigationController?.popViewController(animated: true)
	}
	
	//MARK: - selector ==================
	@objc func editDiaryNotification(_ notification: Notification) {
		guard let diary = notification.object as? Diary else { return }
		
		self.diary = diary
		self.configureView()
	}
}
