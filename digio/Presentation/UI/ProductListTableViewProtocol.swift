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
        let cellType = getCellType(for: indexPath)

        switch cellType {
        case .spotlight:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpotlightCell", for: indexPath) as! SpotlightTableViewCell
            cell.configure(with: viewModel.spotlightItems)
            return cell

        case .cash:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CashCell", for: indexPath) as! CashTableViewCell
            cell.configure(with: viewModel.cashInfo)
            return cell

        case .carousel:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarouselCell", for: indexPath) as! CarouselTableViewCell
            cell.configure(with: viewModel.products)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
