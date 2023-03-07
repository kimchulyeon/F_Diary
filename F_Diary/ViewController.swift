//
//  ViewController.swift
//  F_Diary
//
//  Created by chulyeon kim on 2023/03/06.
//

import UIKit

class ViewController: UIViewController {

	//MARK: - properties ============================================
	@IBOutlet weak var collectionView: UICollectionView!

	private var diaryList = [Diary]() {
		didSet {
			self.saveDiaryList()
		}
	}

	//MARK: - lifecycle ============================================
	override func viewDidLoad() {
		super.viewDidLoad()

		self.configureCollectionView()
		self.loadDiaryList()
		
		NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: NSNotification.Name("editDiary"), object: nil)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let addDiaryVC = segue.destination as? AddDiaryViewController else { return }
		addDiaryVC.delegate = self
	}

	//MARK: - func
	private func configureCollectionView() {
		self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
		self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
	}
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yy년 MM월 dd일 (EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
	private func saveDiaryList() {
		let data = self.diaryList.map { diary in
			return [
				"title": diary.title,
				"contents": diary.contents,
				"date": diary.date,
				"isStar": diary.isStar,
			]
		}
		let userDefaults = UserDefaults.standard
		userDefaults.set(data, forKey: "diaryList")
	}
	private func loadDiaryList() {
		let userDefaults = UserDefaults.standard
		guard let diaryList = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
		self.diaryList = diaryList.compactMap({ diary in
			guard let title = diary["title"] as? String else { return nil }
			guard let contents = diary["contents"] as? String else { return nil }
			guard let date = diary["date"] as? Date else { return nil }
			guard let isStar = diary["isStar"] as? Bool else { return nil }

			return Diary(title: title, contents: contents, date: date, isStar: isStar)
		})
		self.diaryList = self.diaryList.sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
	}
	
	//MARK: - selector ==================
	@objc func editDiaryNotification(_ notification: Notification) {
		guard let diary = notification.object as? Diary else { return }
		guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
		
		self.diaryList[row] = diary
		self.diaryList = self.diaryList.sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
		self.collectionView.reloadData()
	}
}

//MARK: - AddDiaryViewDelegate
extension ViewController: AddDiaryViewDelegate {
	func didSelectAdd(diary: Diary) {
		self.diaryList.append(diary)
		self.diaryList = self.diaryList.sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
		self.collectionView.reloadData()
	}
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
	}
}

//MARK: - UICollectionViewDelegate ==================
extension ViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let vc = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
		
		vc.delegate = self
		
		let diary = self.diaryList[indexPath.row]
		vc.diary = diary
		vc.indexPath = indexPath

		self.navigationController?.pushViewController(vc, animated: true)
	}
}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return diaryList.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
		let diary = self.diaryList[indexPath.row]
		cell.titleLabel.text = diary.title
		cell.dateLabel.text = self.dateToString(date: diary.date)
		return cell
	}
}

//MARK: - DiaryDetailViewDelegate ==================
extension ViewController: DiaryDetailViewDelegate {
	func didSelectDelete(indexPath: IndexPath) {
		self.diaryList.remove(at: indexPath.row)
		self.collectionView.deleteItems(at: [indexPath])
		//self.collectionView.reloadData()
	}
}
