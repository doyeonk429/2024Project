import UIKit
import SnapKit

class BoxSettingView: UIView {
    // UI 요소 정의
    let boxNameLabel: UILabel = {
        let label = UILabel()
        label.text = "박스 이름"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    let settingLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()

    let tableTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "구성원"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    let boxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .white
        return imageView
    }()

    let memberAddButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        $0.tintColor = .lightGray
    }

    let nameLabelEditButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        $0.tintColor = .lightGray
    }

    let imageChangeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        $0.tintColor = .lightGray
        $0.setTitle("사진 바꾸기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        return tableView
    }()

    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI 구성
    private func setupViews() {
        addSubview(boxNameLabel)
        addSubview(settingLabel)
        addSubview(nameLabelEditButton)
        addSubview(boxImageView)
        addSubview(imageChangeButton)
        addSubview(tableTitleLabel)
        addSubview(memberAddButton)
        addSubview(tableView)
    }

    // 제약 설정
    private func setupConstraints() {
        boxNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }

        settingLabel.snp.makeConstraints { make in
            make.top.equalTo(boxNameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }

        nameLabelEditButton.snp.makeConstraints { make in
            make.centerY.equalTo(boxNameLabel)
            make.leading.equalTo(boxNameLabel.snp.trailing).offset(8)
        }

        boxImageView.snp.makeConstraints { make in
            make.top.equalTo(settingLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(boxImageView.snp.width).multipliedBy(0.75)
        }

        imageChangeButton.snp.makeConstraints { make in
            make.top.equalTo(boxImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        tableTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageChangeButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
        }

        memberAddButton.snp.makeConstraints { make in
            make.centerY.equalTo(tableTitleLabel)
            make.leading.equalTo(tableTitleLabel.snp.trailing).offset(8)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(tableTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
}
