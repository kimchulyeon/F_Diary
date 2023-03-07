//
//  StartViewController.swift
//  F_Diary
//
//  Created by chulyeon kim on 2023/03/06.
//

import UIKit

class StarViewController: UIViewController {
	//MARK: - properties ==================
	@IBOutlet weak var collectionView: UICollectionView!

	private var diaryList = [Diary]()

	//MARK: - lifecycle ==================
	override func viewDidLoad() {
		super.viewDidLoad()

		self.configureCollectionView()
		self.loadStarDiaryList()
		
		NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: NSNotification.Name("editDiary"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNotification(_:)), name: NSNotification.Name("starDiary"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(deleteDiaryNotification(_:)), name: NSNotification.Name("deleteDiary"), object: nil)
	}
//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(animated)
//
//		self.loadStarDiaryList()
//	}

	//MARK: - func ==================
	private func loadStarDiaryList() {
		let userDefaults = UserDefaults.standard
		guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
		
		self.diaryList = data.compactMap {
			guard let uuidString = $0["uuidString"] as? String else { return nil }
			guard let title = $0["title"] as? String else { return nil }
			guard let contents = $0["contents"] as? String else { return nil }
			guard let date = $0["date"] as? Date else { return nil }
			guard let isStar = $0["isStar"] as? Bool else { return nil }

			return Diary(uuidString: uuidString ,title: title, contents: contents, date: date, isStar: isStar)
		}.filter({
			$0.isStar == true
		}).sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
		//self.collectionView.reloadData()
	}
	private func configureCollectionView() {
		self.collectionView.collectionViewLayout = UICollectionViewFlowLayout() // 코드로 collectionView를 구성하려면 작성해줘야한다.
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
	
	//MARK: - @objc ==================
	@objc func editDiaryNotification(_ noti: Notification) {
		guard let diary = noti.object as? Diary else { return }
		//guard let row = noti.userInfo?["indexPath.row"] as? Int else { return }
		guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else { return }
		
		self.diaryList[index] = diary
		self.diaryList = self.diaryList.sorted(by: {
			$0.date.compare($1.date) == .orderedDescending
		})
		self.collectionView.reloadData()
	}
	@objc func starDiaryNotification(_ noti: Notification) {
		guard let data = noti.object as? [String: Any] else { return }
		guard let isStar = data["isStar"] as? Bool else { return }
		//guard let indexPath = data["indexPath"] as? IndexPath else { return }
		guard let uuidString = data["uuidString"] as? String else { return }
		guard let diary = data["diary"] as? Diary else { return }
		
		if isStar {
			self.diaryList.append(diary)
			self.diaryList = self.diaryList.sorted(by: {
				$0.date.compare($1.date) == .orderedDescending
			})
			self.collectionView.reloadData()
		} else {
			guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
			self.diaryList.remove(at: index)
			self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
		}
	}
	@objc func deleteDiaryNotification(_ noti: Notification) {
		//guard let indexPath = noti.object as? IndexPath else { return }
		guard let uuidString = noti.object as? String else { return }
		guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
		self.diaryList.remove(at: index)
		self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
	}
}

//MARK: - UICollectionViewDelegateFlowLayout ==================
extension StarViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
	}
}
//MARK: - UICollectionViewDelegate ==================
extension StarViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let vc = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
		let diary = self.diaryList[indexPath.row]
		vc.diary = diary
		vc.indexPath = indexPath
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
//MARK: - UICollectionViewDataSource ==================
extension StarViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.diaryList.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as? StarCell else { return UICollectionViewCell() }
		let diary = self.diaryList[indexPath.row]
		cell.titleLabel.text = diary.title
		cell.dateLabel.text = self.dateToString(date: diary.date)
		return cell
	}
}
