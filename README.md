# F_Diary

## π’ NotificationCenter

---

- .post() : λΈν°νΌμΌμ΄μ λ±λ‘
- .addObserver() : λΈν°νΌμΌμ΄μ λ°μ

[1] λ±λ‘
```

@IBAction func tapAddButton(_ sender: Any) { 
  let newDiary = Diary(uuid: UUID().uuidString, title: titleLabel.text, content: contentLabel.text)
  // π Notification "AddDiary"μ΄λ¦μΌλ‘ λ±λ‘
  NotificationCenter.default.post(name: NSNotification.Name("AddDiary"), object: newDiary, userInfo: nil)
}
```

[2] λ°μ
```
override func viewDidLoad() {
  super.viewDidLoad()
  
  // π "AddDiary"λ‘ λ Notification μ€ν
  NotificationCenter.default.addObserver(self, selector: #selector(addDiaryNotification(_:)), name: NSNotification.Name("AddDiary"), object: nil)
}

@objc func addDiaryNotification(_ notification: Notification) {
  // π notification λ±λ‘ν  λ object νλΌλ―Έν° λ£μ΄λ³΄λΈ λ€μ΄μ΄λ¦¬ λ°μ΄ν°λ₯Ό λ°μμ μ¬μ©
  guard let diary = notification.object as? Diary else { return }
  self.diaryList.append(diary)
}
```
