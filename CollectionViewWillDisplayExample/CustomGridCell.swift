//
//  CollectionViewCell.swift
//  CollectionViewWillDisplayExample
//
//  Created by 박정하 on 2023/07/25.
//

import UIKit

class CustomGridCell: UICollectionViewCell {
    static var identifier: String = "collectionViewCell"
    
    private let cellTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "초기화"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(cellTitle)
        
        NSLayoutConstraint.activate([
            cellTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cellTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configureCell(source: String) {
        cellTitle.text = "월"
    }
}
