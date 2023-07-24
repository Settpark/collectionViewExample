//
//  DiffableDataSource.swift
//  CollectionViewWillDisplayExample
//
//  Created by 박정하 on 2023/07/25.
//

import UIKit

protocol DiffableDatasourceManagable {
    var diffableDatasource: UICollectionViewDiffableDataSource<Section, Model>? { get }
}


class DiffableDataSource: NSObject,
                          DiffableDatasourceManagable,
                          UICollectionViewDelegate {
    var diffableDatasource: UICollectionViewDiffableDataSource<Section, Model>?
    private var snapShot: NSDiffableDataSourceSnapshot<Section, Model>
    
    override init() {
        snapShot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapShot.appendSections([.main])
    }
    
    func bindingDatasource(collectionView: UICollectionView) {
        self.diffableDatasource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                                     cellProvider: { (collectionView: UICollectionView,
                                                                                      indexPath: IndexPath,
                                                                                      itemIdentifier: Model) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        })
    }
    
    func updateDatasource(_ source: [Model]) {
        snapShot.appendItems(source)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.diffableDatasource?.apply(self.snapShot, animatingDifferences: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? CollectionViewCell {
            cell.configureCell(source: "업데이트됨")
        }
    }
}

enum Section {
    case recommand
    case week
    case main
}

struct Model: Hashable {
    var id: Int
    var title: String
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
