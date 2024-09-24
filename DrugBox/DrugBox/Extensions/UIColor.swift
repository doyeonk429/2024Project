//
//  UIColor.swift
//  DrugBox
//
//  Created by 김도연 on 9/24/24.
//

import UIKit

extension UIColor {
    // Helper initializer for UIColor from hex string
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

public func createCustomSearchBar(placeholder: String, delegate: UISearchBarDelegate?) -> UISearchBar {
    let searchBar = UISearchBar()
    searchBar.delegate = delegate
    searchBar.searchBarStyle = .minimal
    searchBar.layer.cornerRadius = 8
    searchBar.layer.masksToBounds = true

    if let searchIcon = UIImage(named: "icon_search") {
        searchBar.setImage(searchIcon, for: .search, state: .normal)
    }

    if let textField = searchBar.value(forKey: "searchField") as? UITextField {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hue: 0, saturation: 0, brightness: 0.45, alpha: 1.0),
            .font: UIFont.boldSystemFont(ofSize: 12)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
    
    searchBar.searchTextField.backgroundColor = UIColor(hex: "#E5E5E5")
    
    return searchBar
}
