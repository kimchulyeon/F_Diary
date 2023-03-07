//
//  DiaryDetailViewController.swift
//  F_Diary
//
//  Created by chulyeon kim on 2023/03/06.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
	//func didSelectDelete(indexPath: IndexPath)
	// func didSelectStar(indexPath: IndexPath, isStar: Bool)
}

class DiaryDetailViewController: UIViewController {
	//MARK: - properties ==================
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentsTextView: UITextView!
	@IBOutlet weak var dateLabel: UILabel!

	var diary: Diary?
	var indexPath: IndexPath?
	var delegate: DiaryDetailViewDelegate?

	var starButton: UIBarButtonItem?

	//MARK: - lifecycle ==================
	override func viewDidLoad() {
		super.viewDidLoad()

		self.configureView()
		NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNotification(_:)), name: NSNotification.Name("starDiary"), object: nil)
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

		self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
		self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
		self.starButton?.tintColor = .orange
		self.navigationItem.rightBarButtonItem = self.starButton
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
		//guard let indexPath = self.indexPath else { return }
		//self.delegate?.didSelectDelete(indexPath: indexPath)
		guard let uuidString = self.diary?.uuidString else { return }
		
		NotificationCenter.default.post(name: NSNotification.Name("deleteDiary"), object: uuidString)

		self.navigationController?.popViewController(animated: true)
	}

	//MARK: - @objc ==================
	@objc func editDiaryNotification(_ notification: Notification) {
		guard let diary = notification.object as? Diary else { return }

		self.diary = diary
		self.configureView()
	}
	@objc func tapStarButton() {
		guard let isStar = self.diary?.isStar else { return }

		self.starButton?.image = isStar ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")
		self.diary?.isStar = !isStar

		//self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false)
		guard let isStar = self.diary?.isStar else { return }
		guard let uuid = self.diary?.uuidString else { return }
		guard let diary = self.diary else { return }
		NotificationCenter.default.post(name: NSNotification.Name("starDiary"), object: ["diary": diary, "isStar": isStar, "uuidString": uuid])
	}
	@objc func starDiaryNotification(_ noti: Notification) {
		guard let starDiary = noti.object as? [String: Any] else { return }
		guard let isStar = starDiary["isStar"] as? Bool else { return }
		guard let uuidString = starDiary["uuidString"] as? String else { return }
		guard let diary = self.diary else { return }
		
		if diary.uuidString == uuidString {
			self.diary?.isStar = isStar
			self.configureView()
		}
	}
}
