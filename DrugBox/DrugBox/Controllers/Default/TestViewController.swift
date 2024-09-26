//
//  TestViewController.swift
//  DrugBox
//
//  Created by 김도연 on 9/24/24.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {
    
    // Create the button
    private let pushButton = UIButton(type: .system).then {
        $0.setTitle("Go to Login", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(hex: "169F00")
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButton()
    }
    
    private func setupButton() {
        view.addSubview(pushButton)
        
        // Set constraints using SnapKit
        pushButton.snp.makeConstraints { make in
            make.center.equalToSuperview() // Center the button in the view
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        // Add button action
        pushButton.addTarget(self, action: #selector(pushButtonTapped), for: .touchUpInside)
    }
    
    @objc private func pushButtonTapped() {
        // Initialize and push the LoginViewController
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}

