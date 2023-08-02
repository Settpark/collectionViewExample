//
//  CustomRecommandCell.swift
//  CollectionViewWillDisplayExample
//
//  Created by temp_name on 2023/08/01.
//

import UIKit

class CustomRecommandCell: UICollectionViewCell {
    static var identifier: String = "collectionViewCell"
    
    private let cellTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "초기화"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
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
        self.contentView.addSubview(cellTitle)
        
        NSLayoutConstraint.activate([
            cellTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cellTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configureCell(source: String) {
        cellTitle.text = "월"
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.contentView.backgroundColor = .red
    }
}
