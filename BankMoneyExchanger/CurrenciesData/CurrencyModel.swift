//
//  CurrencyModel.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/11/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import Foundation
import SwiftyJSON

class CurrencyModel {
    
    // MARK: -
    // MARK: Properties
    
    public var data: CurrenciesData? = nil
    public var nameCurrency: [CurrencyName] = []
    private let pathCurrency = "CurrensyRawJSON"
    private let pathCurrencyNames = "CurrencyNamesRuJSON"
    
    // MARK: -
    // MARK: Init
    
    init() {
        let text = self.pathToText(inputString: pathCurrency)
        let decoder = JSONDecoder()
        do {
            self.data = try decoder.decode(CurrenciesData.self, from: text.data(using: .utf8)!)
        } catch {
            print("error in decoding JSON")
        }
    //print(data)
        let textCurrenyNames = self.pathToText(inputString: pathCurrencyNames)
        let decoderNames = JSONDecoder()
        do {
            self.nameCurrency = try decoderNames.decode([CurrencyName].self, from: textCurrenyNames.data(using: .utf8)!)
        } catch {
            print("error in decoding JSON")
        }
    //print(nameCurrency)
    }
    
    // MARK: -
    // MARK: Methods
    
    private func pathToText(inputString str: String) -> String{
        guard let path = Bundle.main.path(forResource: "\(str)", ofType: "json") else {
            print("File JSON not found")
            return ""
        }
        let expandedPath = URL(fileURLWithPath: path)
        return try! String(contentsOf: expandedPath)
    }
}
