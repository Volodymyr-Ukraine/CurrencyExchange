//
//  PBCell.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/11/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import UIKit

class PBCell: UITableViewCell {
    
    // MARK: -
    // MARK: Properties
    
    @IBOutlet public var currencyLabel: UILabel?
    @IBOutlet public var buyingLabel: UILabel?
    @IBOutlet public var sellingLabel: UILabel?
    
    // MARK: -
    // MARK: Init and Deinit
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: -
    // MARK: Methods
    
    public func changeData(_ currency: String, _ buying: String, _ selling: String) {
        zip([self.currencyLabel, self.buyingLabel, self.sellingLabel],
            [currency, buying, selling])
            .forEach{ (label, info) in
                label?.text = info
            }
    }
    
}
