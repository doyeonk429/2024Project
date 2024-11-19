//
//  AddNewDrugView.swift
//  DrugBox
//
//  Created by 김도연 on 11/19/24.
//

import UIKit
import SnapKit

class AddNewDrugView: UIView, UITextFieldDelegate {
    
    public var countValue : Int?
    public var dateValue : String?

    // MARK: - UI Elements
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "보관 개수"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    private let countValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0" // 초기 값
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let countStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        stepper.value = 0
        return stepper
    }()

    private var count: Int = 0

    private let expiryDateLabel: UILabel = {
        let label = UILabel()
        label.text = "사용기한"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()

    private var date: String?

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "보관 위치"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()

    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "약을 보관한 위치를 입력하세요"
        return textField
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
        setDefaultDate()
        locationTextField.delegate = self // Delegate 설정
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Add subviews
        addSubview(countLabel)
        addSubview(countValueLabel)
        addSubview(countStepper)
        addSubview(expiryDateLabel)
        addSubview(datePicker)
        addSubview(locationLabel)
        addSubview(locationTextField)

        // Layout constraints
        countLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
        }
        
        countValueLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.top)
            make.leading.equalTo(countLabel.snp.trailing).offset(5)
        }

        countStepper.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.top)
            make.leading.equalTo(countValueLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-10)
        }

        expiryDateLabel.snp.makeConstraints { make in
            make.top.equalTo(countStepper.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(10)
        }

        datePicker.snp.makeConstraints { make in
            make.top.equalTo(expiryDateLabel.snp.top)
            make.leading.equalTo(expiryDateLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-10)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }

        locationTextField.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
    }

    // MARK: - Actions
    private func setupActions() {
        countStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }

    @objc private func stepperValueChanged(_ sender: UIStepper) {
        let newValue = Int(sender.value)
        countValueLabel.text = "\(newValue)" // 라벨에 새로운 값 표시
        countValue = newValue
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        date = formatter.string(from: sender.date)
        print("사용기한: \(date ?? "")")
        dateValue = date
        
        sender.resignFirstResponder()
    }
    
    private func setDefaultDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: Date())
        
        dateValue = todayString
    }
    
    public func returnLocation() -> String? {
        return locationTextField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 닫기
        return true
    }
}
