# F_Diary

## 🟢 NotificationCenter

---

- .post() : 노티피케이션 등록
- .addObserver() : 노티피케이션 발생

[1] 등록
```

@IBAction func tapAddButton(_ sender: Any) { 
  let newDiary = Diary(uuid: UUID().uuidString, title: titleLabel.text, content: contentLabel.text)
  // 📌 Notification "AddDiary"이름으로 등록
  NotificationCenter.default.post(name: NSNotification.Name("AddDiary"), object: newDiary, userInfo: nil)
}
```

[2] 발생
```
override func viewDidLoad() {
  super.viewDidLoad()
  
  // 📌 "AddDiary"로 된 Notification 실행
  NotificationCenter.default.addObserver(self, selector: #selector(addDiaryNotification(_:)), name: NSNotification.Name("AddDiary"), object: nil)
}

@objc func addDiaryNotification(_ notification: Notification) {
  // 📌 notification 등록할 때 object 파라미터 넣어보낸 다이어리 데이터를 받아서 사용
  guard let diary = notification.object as? Diary else { return }
  self.diaryList.append(diary)
}
```
