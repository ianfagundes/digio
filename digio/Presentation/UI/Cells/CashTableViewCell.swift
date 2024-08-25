//
//  CashTableViewCell.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation
import TinyConstraints
import UIKit

protocol CashTableViewCellDelegate: AnyObject {
    func didLoadImage()
}

class CashTableViewCell: UITableViewCell {
    private var cashInfo: CashInfoItem?

    weak var delegate: CashTableViewCellDelegate?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cashImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none 
        setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with cashInfo: CashInfoItem?) {
        self.cashInfo = cashInfo
        setImageView()
    }

    private func setupImageView() {
        contentView.addSubview(containerView)
        containerView.addSubview(cashImageView)
        
        containerView.topToSuperview(offset: 8)
        containerView.leadingToSuperview(offset: 24)
        containerView.trailingToSuperview(offset: 24)
        containerView.height(88)
        
        cashImageView.edgesToSuperview()   
    }

    private func setImageView() {
        guard let imageUrlString = cashInfo?.bannerURL, let url = URL(string: imageUrlString) else {
            return
        }

        cashImageView.load(url: url, withCornerRadius: 10, contentMode: .scaleAspectFill)
    }
}
