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
    
    @IBOutlet public var currencyLabel: UILabel?//! = UILabel()
    @IBOutlet public var buyingLabel: UILabel?//! = UILabel()
    @IBOutlet public var sellingLabel: UILabel?//! = UILabel()
    
    // MARK: -
    // MARK: Init and Deinit
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        
        //Bundle.main.loadNibNamed("PBCell", owner: self)
        super.awakeFromNib()
        
        //super.contentView.addSubview(currencyLabel)
        // Initialization code
    }
    
    // MARK: -
    // MARK: Methods

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func changeData(_ currency: String, _ buying: String, _ selling: String) {
        guard let cur = self.currencyLabel else {
            return
        }
        cur.text = currency
        guard let buy = self.buyingLabel else {
            return
        }
        buy.text = buying
        guard let sel = self.sellingLabel else {
            return
        }
        sel.text = selling
    }
    
}
