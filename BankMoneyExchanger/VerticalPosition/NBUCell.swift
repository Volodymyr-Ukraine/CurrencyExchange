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

    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    public var currencyAttr: String = ""
    
    // MARK: -
    // MARK: Init and Deinit
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: -
    // MARK: Methods
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
