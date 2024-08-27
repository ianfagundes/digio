//
//  ProductListTableViewProtocol.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation
import UIKit

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductListCellType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = getCellType(for: indexPath) else {
            return UITableViewCell()
        }

        switch cellType {
        case .spotlight:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCellType.spotlight.identifier, for: indexPath) as? SpotlightCarouselTableViewCell {
                cell.delegate = self
                cell.configure(with: viewModel.spotlightItems)
                return cell
            }

        case .cashTitle:
            let cell = UITableViewCell()
            if let digioCashText = viewModel.cashTitle {
                cell.textLabel?.attributedText = configureCashTitleText(digioCashText)
            }
            cell.selectionStyle = .none
            return cell

        case .cash:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCellType.cash.identifier, for: indexPath) as? CashTableViewCell {
                cell.configure(with: viewModel.cashInfo)
                return cell
            }

        case .productsTitle:
            let cell = UITableViewCell()
            let productsText = "Produtos"
            cell.textLabel?.attributedText = configureProductTitleText(productsText)
            cell.selectionStyle = .none
            return cell

        case .productsCarousel:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCellType.productsCarousel.identifier, for: indexPath) as? ProductsCarouselTableViewCell {
                cell.delegate = self
                cell.configure(with: viewModel.products)
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellType = getCellType(for: indexPath) else { return }

        var selectedItem: DetailItemType?

        switch cellType {
        case .spotlight:
            if let item = viewModel.spotlightItems.first {
                selectedItem = .banner(item)
            }
        case .cash:
            if let item = viewModel.cashInfo {
                selectedItem = .service(item)
            }
        case .productsCarousel:
            if let item = viewModel.products.first {
                selectedItem = .product(item)
            }
        default:
            break
        }

        if let selectedItem = selectedItem {
            delegate?.didSelectItem(selectedItem)
        }
    }
}

extension ProductListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = getCellType(for: indexPath)

        switch cellType {
        case .spotlight:
            return 144
        case .cash:
            return 104
        case .productsCarousel:
            return 160
        default:
            return UITableView.automaticDimension
        }
    }
}

extension ProductListViewController: SpotlightCarouselTableViewCellDelegate {
    func spotlightCarouselTableViewCell(_ cell: SpotlightCarouselTableViewCell, didSelectItem item: SpotlightItem) {
        let selectedItem = DetailItemType.banner(item)
        delegate?.didSelectItem(selectedItem)
    }
}

extension ProductListViewController {
    private func configureText(_ text: String, styles: [(text: String, color: UIColor)]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let boldFont = UIFont.boldSystemFont(ofSize: 24)

        for style in styles {
            let range = (text as NSString).range(of: style.text)
            attributedString.addAttributes([.font: boldFont, .foregroundColor: style.color], range: range)
        }

        return attributedString
    }
}

extension ProductListViewController {
    private func configureCashTitleText(_ text: String) -> NSAttributedString {
        let blueColor = UIColor(red: 0.078, green: 0.163, blue: 0.337, alpha: 1.0)
        let grayColor = UIColor.gray

        let words = text.split(separator: " ")
        guard words.count >= 2 else { return NSAttributedString(string: text) }

        return configureText(text, styles: [
            (text: String(words[0]), color: blueColor),
            (text: String(words[1]), color: grayColor)
        ])
    }

    private func configureProductTitleText(_ text: String) -> NSAttributedString {
        let blueColor = UIColor(red: 0.078, green: 0.163, blue: 0.337, alpha: 1.0)
        return configureText(text, styles: [(text: text, color: blueColor)])
    }
}
