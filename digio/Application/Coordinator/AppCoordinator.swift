//
//  AppCoordinator.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation
import UIKit

class AppCoordinator: CoordinatorProtocol {
    
    var window: UIWindow
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        
        let url = URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
        let client = URLSessionAdapter()
        let repository = RemoteProductRepository(client: client, url: url)
        let viewModel = ProductListViewModel(fetchProductsUseCase: DefaultFetchProductsUseCase(productRepository: repository))
        let productListVC = ProductListViewController(viewModel: viewModel)
        
        navigationController.viewControllers = [productListVC]
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
