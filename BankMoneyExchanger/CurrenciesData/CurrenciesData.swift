//
//  CurrenciesData.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/11/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import Foundation

struct CurrenciesData: Decodable {
    public var date: String
    private var bank: String
    var baseCurrency: Int
    var baseCurrencyLit: String
    var exchangeRate: [CurrencyData]
}
