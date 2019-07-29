//
//  NBUCell.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/11/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import UIKit

class NBUCell: UITableViewCell {
    
    // MARK: -
    // MARK: Properties

    @IBOutlet var currencyNameLabel: UILabel?
    @IBOutlet var valueLabel: UILabel?
    @IBOutlet var countLabel: UILabel?
    
    // MARK: -
    // MARK: Init and Deinit
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: -
    // MARK: Methods
    
    public func changeData(_ currency: String, _ value: String, _ count: String) {
        zip([self.currencyNameLabel, self.valueLabel, self.countLabel],
            [currency, value, count])
            .forEach{ (label, info) in
                label?.text = info
            }
    }
}
