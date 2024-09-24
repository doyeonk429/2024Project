//
//  MenuSelect.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//
import UIKit
import SnapKit
import SafariServices

class MenuSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // UI Components
    private let manageButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    private let searchButton = UIButton(type: .system)
    private let alarmButton = UIBarButtonItem()
    private let accountButton = UIBarButtonItem()
    
    private var AdContents: [String] = ["ad1", "ad1", "ad1"]
    private var AdLinks: [String] = [
        "https://www.nongmin.com/article/20240317500011",
        "https://gonggam.korea.kr/newsContentView.es?mid=a10205000000&news_id=9d913168-51b4-4802-867e-c14de8940f18&pWise=Letter",
        "https://www.newspenguin.com/news/articleView.html?idxno=10776"
    ]
    
    // ScrollView and ContentView
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    // Ad Image CollectionView
    private lazy var AdImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(AdImageCollectionViewCell.self, forCellWithReuseIdentifier: "AdImageCollectionViewCell")
        cv.delegate = self
        cv.dataSource = self
        cv.tag = 1
        
        cv.backgroundColor = .clear
        cv.layer.cornerRadius = 16
        cv.layer.shadowOpacity = 0.3
        cv.layer.shadowColor = UIColor.black.cgColor
        cv.layer.shadowOffset = CGSize(width: 0, height: 2)
        cv.layer.shadowRadius = 5
        cv.layer.masksToBounds = false
        
        return cv
    }()
    
    // Page Control for CollectionView
    private lazy var pageControl: UIPageControl = {
        let p = UIPageControl()
        p.pageIndicatorTintColor = UIColor(hex: "#D9D9D9")
        p.currentPageIndicatorTintColor = UIColor(hex: "#FF7A6D")
        return p
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "   DrugBox"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        // Configure Alarm and Account buttons
        alarmButton.image = UIImage(systemName: "bell.fill")
        alarmButton.tintColor = .systemYellow
        alarmButton.target = self
        alarmButton.action = #selector(alarmButtonPressed)
        
        accountButton.image = UIImage(systemName: "person.fill")
        accountButton.tintColor = .lightGray
        accountButton.target = self
        accountButton.action = #selector(accountButtonPressed)
        
        self.navigationItem.rightBarButtonItems = [accountButton, alarmButton]
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        // Add UI components to the view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(AdImageCollectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(manageButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(searchButton)
        
        // Set up constraints
        setupConstraints()
        
        // Configure buttons
        configureButton(manageButton, title: "Manage", action: #selector(manageButtonPressed))
        configureButton(deleteButton, title: "Delete", action: #selector(deleteButtonPressed))
        configureButton(searchButton, title: "Search", action: #selector(searchButtonPressed))
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        AdImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(AdImageCollectionView.snp.width).multipliedBy(247.0/356.0)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(AdImageCollectionView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // Button Layouts
        manageButton.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(manageButton.snp.bottom).offset(10)
            make.leading.trailing.height.equalTo(manageButton)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(deleteButton.snp.bottom).offset(10)
            make.leading.trailing.height.equalTo(manageButton)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
    
    private func configureButton(_ button: UIButton, title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // Set bold font with size 20
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc private func alarmButtonPressed() {
        let alarmListViewController = AlarmListViewController()
        navigationController?.pushViewController(alarmListViewController, animated: true)
    }
    
    @objc private func accountButtonPressed() {
        let alarmListViewController = AlarmListViewController()
        navigationController?.pushViewController(alarmListViewController, animated: true)
    }
    
    @objc private func manageButtonPressed() {
        let defaultBoxViewController = DefaultBoxViewController()
        navigationController?.pushViewController(defaultBoxViewController, animated: true)
    }
    
    @objc private func deleteButtonPressed() {
        let deleteVC = MainDeleteViewController()
        navigationController?.pushViewController(deleteVC, animated: true)
    }
    
    @objc private func searchButtonPressed() {
        // Handle search button action
        print("Search button pressed.")
    }
    
    // MARK: - UICollectionView DataSource & Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            pageControl.numberOfPages = AdContents.count
            return AdContents.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdImageCollectionViewCell", for: indexPath) as! AdImageCollectionViewCell
            cell.configure(image: AdContents[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            if let adURL = URL(string: AdLinks[indexPath.row]) {
                let adSafariView = SFSafariViewController(url: adURL)
                self.present(adSafariView, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        return CGSize.zero
    }
}
