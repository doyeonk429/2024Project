//
//  ShowDrugDetailViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/13/24.
//

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class ShowDrugDetailViewController: UIViewController {
    
    let provider = MoyaProvider<DrugService>(plugins: [BearerTokenPlugin()])
    
    public var boxId: Int?
    public var drugName: String?
    public var drugEffect: String?
    public var drugDetail : DrugModel?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.ptdBoldFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "로딩 중 ..."
        textView.font = UIFont.ptdRegularFont(ofSize: 16)
        textView.textColor = .black
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let countValueLabel: UILabel = {
        let label = UILabel()
        label.text = "보관 개수: " // 초기값 예시
        label.font = UIFont.ptdRegularFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let dateValueLabel: UILabel = {
        let label = UILabel()
        label.text = "사용기한: 없음" // 초기값 예시
        label.font = UIFont.ptdRegularFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let textViewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "의약품 정보" // 초기값 예시
        label.font = UIFont.ptdBoldFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let trashButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let trashImage = UIImage(systemName: "trash", withConfiguration: symbolConfig)
        button.setImage(trashImage, for: .normal)
        button.tintColor = .appGrey // 이미지 색상 설정
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Set Navigation Title
        navigationItem.title = "의약품 상세 정보"
        guard let drugdetail = drugDetail else { return }
        titleLabel.text = drugdetail.drugName
        descriptionTextView.text = drugEffect
        countValueLabel.text = "보관 개수 : \(drugdetail.drugCount)개"
        dateValueLabel.text = "사용 기한 : \(drugdetail.expDate)"
        
        
        // Add UI
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Add Subviews
        view.addSubview(titleLabel)
        view.addSubview(countValueLabel)
        view.addSubview(dateValueLabel)
        view.addSubview(trashButton)
        view.addSubview(textViewTitleLabel)
        view.addSubview(descriptionTextView)
        
        // Set Constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        countValueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        dateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(countValueLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
        }
        
        trashButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateValueLabel)
            make.leading.equalTo(dateValueLabel.snp.trailing).offset(10)
        }
        
        textViewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(trashButton.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(20)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(textViewTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    func callPatchtrash(boxId: Int, drugId: Int) {
        provider.request(.patchDrugDisposal(boxId: boxId, drugid: drugId)) { result in
            switch result {
            case .success:
                // 요청 성공 시 Alert 표시
                DispatchQueue.main.async {
                    self.showConfirmationAlert()
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showConfirmationAlert() {
        // Alert 생성
        let alert = UIAlertController(
            title: "폐기 대상 의약품 목록을 확인하시겠습니까?",
            message: "해당 의약품이 제거되기 전까지는 폐기 대상 의약품 목록에서 확인할 수 있습니다.",
            preferredStyle: .alert
        )
        
        // Yes 버튼
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            // Yes 선택 시 동작 (의약품 목록 화면으로 이동)
            let disposalListVC = InfoViewController() // 대상 뷰컨트롤러 생성
            self.navigationController?.pushViewController(disposalListVC, animated: true)
        }
        
        // No 버튼
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        // 버튼 추가
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        // Alert 표시
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func trashButtonTapped() {
        guard let boxId = self.boxId, let drugId = self.drugDetail?.id else { return }
        callPatchtrash(boxId: boxId, drugId: drugId)
    }
}

