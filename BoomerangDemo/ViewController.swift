//
//  ViewController.swift
//  BoomerangDemo
//
//  Created by Stefano Mondino on 03/11/16.
//
//

import UIKit
import Boomerang
import ReactiveSwift


class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, RouterDestination, ViewModelBindable  {
    @IBOutlet weak var collectionView:UICollectionView?
    @IBOutlet weak var tableView: UITableView!
    var viewModel:TestViewModel?
    var disposable: CompositeDisposable?
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.viewModel == nil) {
            self.bind(ViewModelFactory.anotherTestViewModel())
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return collectionView.autosizeItemAt(indexPath: indexPath, constrainedToWidth: 140)
        return collectionView.autosizeItemAt(indexPath: indexPath, itemsPerLine: 3)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.from(self, viewModel: self.viewModel!.select(selection: indexPath)).execute()
        
    }
    
    func bind(_ viewModel: ViewModelType?) {
        
        guard let vm = viewModel as? TestViewModel else {
            return
        }
        self.viewModel = vm
        self.collectionView?.delegate = self
        self.collectionView?.bind(self.viewModel)
        self.viewModel?.reload()
        
    }
}






