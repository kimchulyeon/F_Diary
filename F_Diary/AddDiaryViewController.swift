//
//  AddDiaryViewController.swift
//  F_Diary
//
//  Created by chulyeon kim on 2023/03/06.
//

import UIKit

class AddDiaryViewController: UIViewController {

	//MARK: - properties ============================================
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var contentsTextView: UITextView!
	@IBOutlet weak var dateTextField: UITextField!
	@IBOutlet weak var addButton: UIBarButtonItem!
	
	private let datePicker = UIDatePicker()
	private var diaryDate: Date?
	
	//MARK: - lifecycle ============================================
	override func viewDidLoad() {
		super.viewDidLoad()

		self.configureContentsTextView()
		self.configureDatePicker()
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
	
	//MARK: - selector ============================================
	@objc func datePickerValueDidChange(_ datePicker: UIDatePicker) {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy년 MM월 dd일 (EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		
		self.diaryDate = datePicker.date
		self.dateTextField.text = formatter.string(from: datePicker.date)
	}
	
	//MARK: - action ============================================
	@IBAction func tapAddButton(_ sender: Any) {
		
	}
	
	
}
