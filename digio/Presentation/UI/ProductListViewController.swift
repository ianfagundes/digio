//
//  ProductListViewController.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation
import TinyConstraints
import UIKit

protocol ProductListViewControllerDelegate: AnyObject {
    func didSelectItem(_ item: DetailItemType)
}

class ProductListViewController: UIViewController, ProductListViewModelDelegate {
    var viewModel: ProductListViewModelProtocol
    weak var delegate: ProductListViewControllerDelegate?

    private let productsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.register(SpotlightCarouselTableViewCell.self, forCellReuseIdentifier: ProductListCellType.spotlight.identifier)
        tv.register(CashTableViewCell.self, forCellReuseIdentifier: ProductListCellType.cash.identifier)
        tv.register(ProductsCarouselTableViewCell.self, forCellReuseIdentifier: ProductListCellType.productsCarousel.identifier)
        return tv
    }()

    private let cashTitle: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.textAlignment = .left
        return lb
    }()

    private let productsTitle: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.textAlignment = .left
        return lb
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
        setupLayout()
        viewModel.fetchProducts()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(productsTableView)
        view.addSubview(cashTitle)
        view.addSubview(productsTitle)
        productsTableView.delegate = self
        productsTableView.dataSource = self
    }

    private func setupLayout() {
        productsTableView.topToSuperview(usingSafeArea: true)
        productsTableView.bottomToSuperview()
        productsTableView.leadingToSuperview(offset: 16)
        productsTableView.trailingToSuperview(offset: 16)
    }

    internal func getCellType(for indexPath: IndexPath) -> ProductListCellType? {
        return ProductListCellType(rawValue: indexPath.row)
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

// MARK: - Extensions

// implementando o protocolo CashTableViewCellDelegate para fazer o reload dos dados da tableView.

extension ProductListViewController: CashTableViewCellDelegate {
    func didLoadImage() {
        DispatchQueue.main.async {
            self.productsTableView.reloadData()
        }
    }
}

extension ProductListViewController: ProductsCarouselTableViewCellDelegate {
    func productsCarouselTableViewCell(_ cell: ProductsCarouselTableViewCell, didSelectItem item: ProductItem) {
        let selectedItem = DetailItemType.product(item)
        delegate?.didSelectItem(selectedItem)
    }
}
