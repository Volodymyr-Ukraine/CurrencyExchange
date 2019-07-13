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
    struct CellPB {
        public var currency: String
        public var buying: String
        public var selling: String
        public var jumpTo: Int?
    }
    struct CellNBU {
        public var currencyName: String
        public var currency: String
        public var value: String
        public var count: String
        public var jumpTo: Int?
    }
    // MARK: -
    // MARK: Properties
    
    public var data: CurrenciesData? = nil
    public var dataPBCells: [CellPB] = []
    public var dataNBUCells: [CellNBU] = []
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
        prepareCells()
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
    
    private func preparePBcells() {
        
        if self.data == nil {
            print("there is no data in preparePBcells()!!!")
            return
        }
        let filteredData = self.data?.exchangeRate.filter{ currency in
            return (currency.purchaseRate != nil) && (currency.currency != nil)
        }
        if filteredData == nil {
            print("there is no filteredData in  preparePBcells()")
            return
        }
        filteredData?.forEach{ currency in
            let cell: CellPB = CellPB(currency: currency.currency ?? "!!!",
                    buying: "\(currency.purchaseRate ?? 0)",
                    selling: "\(currency.saleRate ?? 0)",
                    jumpTo: nil)
            dataPBCells.append(cell)
        }
    }
    
    private func prepareNBUCells() {
        
        if self.data == nil {
            print("there is no data in preparePBcells()!!!")
            return
        }
        let filteredData = self.data?.exchangeRate.filter{ currency in
            return (currency.currency != nil)
        } // todo - simplify
        if filteredData == nil {
            print("there is no filteredData in  prepareNBUcells()")
            return
        }
        filteredData?.forEach{ currency in
            let curAtr = currency.currency ?? " "
            let currencyName: String = self.nameCurrency.filter{ curr in
                return curr.attr == curAtr
            }.first?.name ?? "Unknown currency"
            let cell: CellNBU = CellNBU(currencyName: currencyName,
                            currency: curAtr,
                            value: "\(currency.purchaseRateNB)",
                            count: "1 UAH",
                            jumpTo: nil)
            dataNBUCells.append(cell)
        }
    }
    
    private func prepareCells() {
        preparePBcells()
        prepareNBUCells()
        dataPBCells.enumerated().forEach{ (n, data) in
            let indexCellNBU = dataNBUCells.firstIndex{ dataNBU in
                return dataNBU.currency == data.currency
            }
            self.dataPBCells[n].jumpTo = indexCellNBU
            if indexCellNBU != nil {
                self.dataNBUCells[indexCellNBU!].jumpTo = n
            }
        }
    }
}
