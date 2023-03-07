//
//  AddDiaryViewController.swift
//  F_Diary
//
//  Created by chulyeon kim on 2023/03/06.
//

import UIKit

protocol AddDiaryViewDelegate: AnyObject {
	func didSelectAdd(diary: Diary)
}

enum DiaryEditorMode {
	case new
	case edit(IndexPath, Diary)
}

class AddDiaryViewController: UIViewController {

	//MARK: - properties ============================================
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var contentsTextView: UITextView! {
		didSet {
			contentsTextView.delegate = self
		}
	}
	@IBOutlet weak var dateTextField: UITextField!
	@IBOutlet weak var addButton: UIBarButtonItem!
	
	private let datePicker = UIDatePicker()
	private var diaryDate: Date?
	
	weak var delegate: AddDiaryViewDelegate?
	
	var diaryEditorMode: DiaryEditorMode = .new
	
	//MARK: - lifecycle ============================================
	override func viewDidLoad() {
		super.viewDidLoad()

		self.configureContentsTextView()
		self.configureDatePicker()
		self.configureInputField()
		self.addButton.isEnabled = false
		self.configureEditMode()
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	
	//MARK: - func ============================================
	/// contentsTextView 테투리선
	private func configureContentsTextView() {
		self.contentsTextView.layer.borderColor = UIColor(red: 180/225, green: 180/225, blue: 180/225, alpha: 1.0).cgColor
		self.contentsTextView.layer.borderWidth = 0.5
		self.contentsTextView.layer.cornerRadius = 5.0
	}
	private func configureDatePicker() {
		self.datePicker.datePickerMode = .date
		self.datePicker.preferredDatePickerStyle = .wheels
		self.datePicker.locale = Locale(identifier: "ko_KR")
		self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
		
		self.dateTextField.inputView = self.datePicker
	}
	private func validateInputField() {
		self.addButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !(self.contentsTextView.text.isEmpty)
	}
	private func configureInputField() {
		self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
		self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
	}
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yy년 MM월 dd일 (EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
	private func configureEditMode() {
		switch self.diaryEditorMode {
		case let .edit(_, diary):
			self.titleTextField.text = diary.title
			self.contentsTextView.text = diary.contents
			self.dateTextField.text = self.dateToString(date: diary.date)
			self.diaryDate = diary.date
			self.addButton.title = "수정"
		default:
			break
		}
	}
	
	
	//MARK: - selector ============================================
	@objc func datePickerValueDidChange(_ datePicker: UIDatePicker) {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy년 MM월 dd일 (EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		
		self.diaryDate = datePicker.date
		self.dateTextField.text = formatter.string(from: datePicker.date)
		// 📌 datePicker에서 날짜를 바꿀 때마다 .editingchanged로 등록된 메서드를 동작시킨다
		self.dateTextField.sendActions(for: .editingChanged)
	}
	@objc private func titleTextFieldDidChange(_ textField: UITextField) {
		self.validateInputField()
	}
	@objc private func dateTextFieldDidChange(_ textField: UITextField) {
		self.validateInputField()
	}
	
	//MARK: - action ============================================
	@IBAction func tapAddButton(_ sender: Any) {
		guard let title = self.titleTextField.text else { return }
		guard let contents = self.contentsTextView.text else { return }
		guard let date = self.diaryDate else { return }
		let newDiary = Diary(title: title, contents: contents, date: date, isStar: false)
		
		switch self.diaryEditorMode {
		case .new: // 새로 생성모드
			self.delegate?.didSelectAdd(diary: newDiary)
		case let .edit(indextPath, _): // 편집모드
			NotificationCenter.default.post(name: NSNotification.Name("editDiary"), object: newDiary, userInfo: ["indexPath.row": indextPath.row])
		}
		
		self.navigationController?.popViewController(animated: true)
	}
}

//MARK: - UITextViewDelegate
extension AddDiaryViewController: UITextViewDelegate {
	// 내용 입력될 때마다 메소드 호출
	func textViewDidChange(_ textView: UITextView) {
		self.validateInputField()
	}
}
