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
    
    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    } // */
    
    public func changeData(_ currency: String, _ value: String, _ count: String) {
        self.currencyNameLabel?.text = currency
        self.valueLabel?.text = value
        self.countLabel?.text = count
    }
}
