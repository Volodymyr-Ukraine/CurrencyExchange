//
//  CurrencyData.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/11/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import Foundation

struct CurrencyData: Decodable {
    var baseCurrency: String
    var currency: String?
    var saleRateNB: Float
    var purchaseRateNB: Float
    var saleRate: Float?
    var purchaseRate: Float?
}
