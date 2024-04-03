//
//  OnboardingViewController.swift
//  DrugBox
//
//  Created by 김도연 on 3/30/24.
//  아직 수정 중

import UIKit

class OnboardingViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - Properties
    var onboardingData: [String] = []
        var currentPage: Int = 0 {
            didSet {
                pageControl.currentPage = currentPage
                if currentPage == onboardingData.count - 1 {
                    pageButton.setTitle("Start", for: .normal)
                } else {
                    pageButton.setTitle("Next", for: .normal)
                }
            }
        }
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setCollectionView()
        setOnboardingData()
    }
    
    // MARK: - Next Btn Actions
    @IBAction func pageButtonPressed(_ sender: UIButton) {
        if currentPage == onboardingData.count - 1 {
            self.performSegue(withIdentifier: K.onboardingSegue, sender: self)
//            print("go to main")
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        //temp code
        self.performSegue(withIdentifier: K.onboardingSegue, sender: self)
    }
    
    
}

extension OnboardingViewController {
    private func setUI() {
        pageButton.layer.cornerRadius = 10
        pageControl.isUserInteractionEnabled = false
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        let onboardingNib = UINib(nibName: OnboardingCollectionViewCell.cellId, bundle: nil)
//        collectionView.register(onboardingNib, forCellWithReuseIdentifier: OnboardingCollectionViewCell.cellId)
    }
    
    private func setOnboardingData() {
        onboardingData.append(contentsOf: [
        ])
    }
}

// MARK: - CollectionView Delegate, DataSource
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell else { return UICollectionViewCell() }
//        cell.setOnboardingSlides(onboardingData[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

// MARK: - CollectionView Delegate Flow Layout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
