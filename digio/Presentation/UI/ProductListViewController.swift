//
//  ProductListViewController.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation
import UIKit
import TinyConstraints

class ProductListViewController: UIViewController, ProductListViewModelDelegate {
    
    var viewModel: ProductListViewModelProtocol
    
    private let productsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(SpotlightTableViewCell.self, forCellReuseIdentifier: "SpotlightCell")
        tv.register(CashTableViewCell.self, forCellReuseIdentifier: "CashCell")
        tv.register(CarouselTableViewCell.self, forCellReuseIdentifier: "CarouselCell")
        return tv
    }()
    
    init(viewModel: ProductListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchProducts()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(productsTableView)
        productsTableView.edgesToSuperview()
        productsTableView.delegate = self
        productsTableView.dataSource = self
    }
    
    internal func getCellType(for indexPath: IndexPath) -> ProductListCellType {
        switch indexPath.row {
        case 0:
            return .spotlight
        case 1:
            return .cash
        default:
            return .carousel
        }
    }
    
    // MARK: - ProductListViewModelDelegate
        
        func didFetchProductsSuccessfully() {
            DispatchQueue.main.async {
                self.productsTableView.reloadData()
            }
        }
        
        func didFailToFetchProducts(with error: Error) {
            showError(error)
        }
        
        private func showError(_ error: Error) {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}
