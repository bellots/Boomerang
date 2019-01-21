//
//  UICollectionView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Boomerang where Base: UICollectionView {
    
    public func configure(with viewModel: ListViewModelType, dataSource: UICollectionViewDataSource? = nil) {
        
        let dataSource = dataSource ?? CollectionViewDataSource(viewModel: viewModel)
        base.dataSource = dataSource
        base.boomerang.internalDataSource = dataSource
        
        viewModel.updates
            .asDriver(onErrorJustReturn: .none)
            .drive(base.rx.dataUpdates())
            .disposed(by: base.boomerang.disposeBag)
//        viewModel.groups
//            .asDriver(onErrorJustReturn: DataGroup.empty)
//            .drive (onNext: {[weak base] _ in
//                base?.reloadData() })
//            .disposed(by: base.boomerang.disposeBag)
        
        
    }
}

extension Reactive where Base: UICollectionView {
    func dataUpdates() -> Binder<DataHolderUpdate> {
        return Binder(base) { base, updates in
            switch updates {
            case .reload :
                print("Reloading")
                base.reloadData()
            case .insertItems(let updates):
                let indexPaths = updates()
                print("Inserting \(indexPaths)")
                base.performBatchUpdates({[weak base] in
                    base?.insertItems(at: indexPaths)
                    }, completion: { (completed) in
                        return
                })
            default: break
            }
        }
    }
}
