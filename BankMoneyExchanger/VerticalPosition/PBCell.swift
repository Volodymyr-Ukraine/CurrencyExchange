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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: -
    // MARK: Methods

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func changeData(_ currency: String, _ buying: String, _ selling: String) {
        if let cur = self.currencyLabel {
            cur.text = currency
        }
        if let buy = self.buyingLabel {
            buy.text = buying
        }
        if let sel = self.sellingLabel {
            sel.text = selling
        }
    }
    
}
