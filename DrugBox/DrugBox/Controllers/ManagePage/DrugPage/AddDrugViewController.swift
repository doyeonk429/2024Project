//
//  AddDrugViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/13/24.
//

import UIKit
import SnapKit
import Moya

class AddDrugViewController: UIViewController {
    
    public var drugName: String?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "의약품 등록하기"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let drugNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "의약품 이름 :"
        label.font = UIFont.ptdRegularFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let drugNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.ptdMediumFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("등록", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appGreen
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var addNewDrugViews: [AddNewDrugView] = [] // 저장된 AddNewDrugView 배열
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        guard let drugname = drugName else {return}
        self.drugNameLabel.text = drugName
        
        setupUI()
        setupActions()
        scrollView.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = false
        contentView.isExclusiveTouch = false
        contentView.clipsToBounds = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visualizeScrollviewArea()
        print("ScrollView Content Size: \(scrollView.contentSize)") // 디버깅용
        print("ScrollView visible Size: \(scrollView.visibleSize)") // 디버깅용
        
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        visualizeScrollviewArea()
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(drugNameTitleLabel)
        view.addSubview(drugNameLabel)
        view.addSubview(scrollView)
        view.addSubview(addButton)
        view.addSubview(removeButton)
        view.addSubview(registerButton)
        
        scrollView.addSubview(contentView)
        
        // Add the first AddNewDrugView
        let initialDrugView = AddNewDrugView()
        addNewDrugViews.append(initialDrugView)
        updateDrugViewsLayout()
        
        // Set constraints for title label
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // Set constraints for drugNameTitleLabel and drugNameLabel
        drugNameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        drugNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(drugNameTitleLabel.snp.trailing).offset(20)
            make.centerY.equalTo(drugNameTitleLabel)
        }
        
        // Set constraints for scrollView
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(drugNameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(registerButton.snp.top).offset(-20) // 스크롤뷰 위로 "등록" 버튼 간격
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(addNewDrugViews.count*220)
        }
        
        // Set constraints for initial AddNewDrugView
        initialDrugView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        // Set constraints for + and - buttons (aligned in a row)
        addButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalTo(registerButton.snp.top).offset(-20) // "등록" 버튼 위로 간격
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        removeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalTo(registerButton.snp.top).offset(-20)
            make.width.height.equalTo(addButton) // 동일한 너비/높이
        }
        
        // Set constraints for register button
        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func updateDrugViewsLayout() {
        for (index, view) in addNewDrugViews.enumerated() {
            contentView.addSubview(view) // 항상 contentView에 추가
            view.snp.remakeConstraints { make in
                view.frame.size.height = 200
                if index == 0 {
                    make.top.equalToSuperview().inset(10)
                } else {
                    make.top.equalTo((index - 1)*220)
                }
                make.leading.trailing.equalToSuperview().inset(10)
            }
        }
        
        // 마지막 뷰 기준으로 contentView 높이 업데이트
        if let lastView = addNewDrugViews.last {
            contentView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(scrollView.snp.width)
                make.height.equalTo(addNewDrugViews.count*220)
            }
        } else {
            // 배열이 비어있을 경우 contentView 초기화
            contentView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(scrollView.snp.width)
                make.height.equalTo(addNewDrugViews.count*220 + 100)
            }
        }
    }
    
    private func visualizeScrollviewArea() {
        self.scrollView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.3) // 반투명한 파란색
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addNewDrugViewTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeLastDrugViewTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    
    @objc private func addNewDrugViewTapped() {
        let newDrugView = AddNewDrugView()
        addNewDrugViews.append(newDrugView) // 배열에 추가
        updateDrugViewsLayout() // 배열 기반으로 재배치
    }

    @objc private func removeLastDrugViewTapped() {
        guard !addNewDrugViews.isEmpty else { return } // 배열이 비어있으면 종료

        let lastView = addNewDrugViews.removeLast() // 배열에서 제거
        lastView.removeFromSuperview() // 뷰 삭제
        updateDrugViewsLayout() // 배열 기반으로 재배치
    }
    
    // "등록" 버튼 눌렀을 때
    @objc private func registerButtonTapped() {
        print("등록 버튼 클릭됨")
        // 여기서 등록 처리 로직 추가 가능
    }
}
