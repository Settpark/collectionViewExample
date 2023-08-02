//
//  ViewController.swift
//  CollectionViewWillDisplayExample
//
//  Created by 박정하 on 2023/07/25.
//

import UIKit

class ViewController: UIViewController {
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    private let myModelData: [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q"]
    private let imageList: [UIImage] = [UIImage(systemName: "xmark")!,
                                        UIImage(systemName: "eraser")!,
                                        UIImage(systemName: "xmark")!]
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    private let recommadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Model>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDataSource()
    }
    
    private func setupViews() {
        view.addSubview(recommadImageView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            recommadImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            recommadImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            recommadImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            recommadImageView.heightAnchor.constraint(equalToConstant: 245)
        ])
        collectionView.delegate = self
        recommadImageView.image = imageList[0]
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionLayoutKind = Section(rawValue: sectionIndex) else { return nil }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupHeight: NSCollectionLayoutDimension
            if sectionLayoutKind == .recommand {
                groupHeight = NSCollectionLayoutDimension.absolute(300)
            } else {
                groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.2)
            }
            let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                           heightDimension: groupHeight)
            
            let group: NSCollectionLayoutGroup
            if sectionLayoutKind == .recommand {
                group = self.createRecommandGroup()
            } else if sectionLayoutKind == .week {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 7)
            } else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            }
            
            let section = NSCollectionLayoutSection(group: group)
            if sectionLayoutKind == .recommand {
                section.orthogonalScrollingBehavior = .groupPagingCentered
            }
            if sectionLayoutKind == .week {
                section.orthogonalScrollingBehavior = .continuous
            }
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return section
        }
        return layout
    }
    
    private func createRecommandGroup() -> NSCollectionLayoutGroup {
        let titleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                  heightDimension: .absolute(45)))
        titleItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        titleItem.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil,
                                                              top: NSCollectionLayoutSpacing.fixed(135),
                                                              trailing: nil,
                                                              bottom: nil)
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                                       heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: titleItem, count: 1)
        return group
    }
    
    private func setupDataSource() {
        let horizontalScrollConfiguration = UICollectionView.CellRegistration<CustomRecommandCell, Model> { cell, indexPath, itemIdentifier in
            cell.configureCell(source: itemIdentifier.title)
        }
        
        let girdConfiguration = UICollectionView.CellRegistration<CustomGridCell, Model> { cell, indexPath, itemIdentifier in
            cell.configureCell(source: itemIdentifier.title)
            cell.backgroundColor = .systemPink
        }
        
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                                                cellProvider: { collectionView, indexPath, itemIdentifier in
            if Section(rawValue: indexPath.section) == .recommand {
                return collectionView.dequeueConfiguredReusableCell(using: horizontalScrollConfiguration, for: indexPath, item: itemIdentifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: girdConfiguration, for: indexPath, item: itemIdentifier)
            }
        })
        
        let itemsPerSection = 10 // 섹션당 아이템 수
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>() // 스냅샷 초기화
        Section.allCases.forEach { //섹션을 foreach문으로 전부 돌면서
            snapshot.appendSections([$0]) //스냅샷에 추가하고
            var items: [Model] = []
            let itemOffset = $0.rawValue * itemsPerSection //아이템 오프셋은 섹션의 로우벨류(==Int) * itemSection(==10)
            let itemUpperbound = itemOffset + itemsPerSection
            for i in itemOffset..<itemUpperbound {
                items.append(Model(id: i, title: String(i)+"abab"))
            }
            snapshot.appendItems(items)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}
