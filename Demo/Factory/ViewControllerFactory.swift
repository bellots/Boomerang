//
//  ViewControllerFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang

enum SceneIdentifier: String, LayoutIdentifier {
    case schedule
    case todo
    case showDetail

    var identifierString: String {
        switch self {
        default: return rawValue
        }
    }
}

protocol ViewControllerFactory {
    func root() -> UIViewController
    func schedule(viewModel: ListViewModel & NavigationViewModel) -> UIViewController
    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController
}

class DefaultViewControllerFactory: ViewControllerFactory {
    let container: AppDependencyContainer

    init(container: AppDependencyContainer) {
        self.container = container
    }

    private func name(from layoutIdentifier: LayoutIdentifier) -> String {
        let identifier = layoutIdentifier.identifierString
        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ViewController"
    }

    func todo(viewModel: ListViewModel & NavigationViewModel) -> UIViewController {
        return TodoViewController(nibName: name(from: viewModel.layoutIdentifier), viewModel: viewModel, tableViewCellFactory: container.tableViewCellFactory)
    }
    
    func schedule(viewModel: ListViewModel & NavigationViewModel) -> UIViewController {
        return ScheduleViewController(nibName: name(from: viewModel.layoutIdentifier),
                                      viewModel: viewModel,
                                      collectionViewCellFactory: container.collectionViewCellFactory)
    }

    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController {
        return ShowDetailViewController(nibName: name(from: viewModel.layoutIdentifier),
                                        viewModel: viewModel,
                                        collectionViewCellFactory: container.collectionViewCellFactory)
    }

    func root() -> UIViewController {
        let classic = self.schedule(viewModel: container.sceneViewModelFactory.schedule())
        let viewModelFactory = container.itemViewModelFactory
        let reactive = self.schedule(viewModel: RxScheduleViewModel(itemViewModelFactory: viewModelFactory,
                                                                    routeFactory: container.routeFactory))
        let todos = self.todo(viewModel: container.sceneViewModelFactory.todo())
        todos.tabBarItem.title = "Todos"
        classic.tabBarItem.title = "Schedule"
        reactive.tabBarItem.title = "RxSchedule"
        let viewControllers = [todos, classic, reactive].compactMap { $0 }

        let root = UITabBarController()
        root.viewControllers = viewControllers
        return root
    }

}
