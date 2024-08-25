//
//  AppCoordinator.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation
import UIKit

import UIKit

class AppCoordinator: CoordinatorProtocol {
    var window: UIWindow
    var navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
    }

    func start() {
        let url = URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
        let client = URLSessionAdapter()
        let repository = RemoteProductRepository(client: client, url: url)
        let viewModel = ProductListViewModel(fetchProductsUseCase: DefaultFetchProductsUseCase(productRepository: repository))

        let productListVC = ProductListViewController(viewModel: viewModel)
        productListVC.delegate = self

        navigationController.viewControllers = [productListVC]

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func navigate(to destination: AppDestination) {
        switch destination {
        case let .detail(item):
            let detailVC = DetailsViewController()
            detailVC.configure(with: item)
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}

extension AppCoordinator: ProductListViewControllerDelegate {
    func didSelectItem(_ item: DetailItemType) {
        navigate(to: .detail(item))
    }
}
