//
//  CurrencyModel.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/11/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class CurrencyModel {
    
    // MARK: -
    // MARK: Constants

    struct moneyConstants {
        static let minimalValueInHrivnaForCurrency : Float = 1
        static let currencyMultiplier = 10
    }
    private let pathCurrency = "CurrensyRawJSON"
    private let pathCurrencyNames = "CurrencyNamesRuJSON"
    private let httpRequestPath = "https://api.privatbank.ua/p24api/exchange_rates"
    
    // MARK: -
    // MARK: Internal Structures
    
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
    private var obtainerJSON = DataObtainer()
    
    // MARK: -
    // MARK: Init
    
    init() {
        self.data = self.obtainerJSON.readFileJSON(from: self.pathCurrency)
        self.nameCurrency = self.obtainerJSON.readFileJSON(from: self.pathCurrencyNames) ?? []
        self.prepareCells()
    }
    
    // MARK: -
    // MARK: Methods
    
    private func filteredDataArray(test: (CurrencyData) -> Bool) -> [CurrencyData]? {
        return self.data?.exchangeRate.filter { currency in
            return test(currency)
        }
    }
    
    private func currencyAbbreviated(_ data: CurrencyData?) -> String {
        return data?.currency ?? "!!!"
    }
    
    private func preparePBCells() {
        guard let filteredData = (self.filteredDataArray{ currency in
            return (currency.purchaseRate != nil) && (currency.currency != nil)
        }) else {
            print("there is no filteredData in  preparePBcells()")
            return
        }
        
        self.dataPBCells = []
        filteredData.forEach{ currency in
            let cell: CellPB = CellPB(currency: self.currencyAbbreviated(currency),
                    buying: "\(currency.purchaseRate ?? 0)",
                    selling: "\(currency.saleRate ?? 0)",
                    jumpTo: nil)
            self.dataPBCells.append(cell)
        }
    }
    
    private func prepareNBUCells() {
        guard let filteredData = (self.filteredDataArray{ currency in
            return (currency.currency != nil)
        }) else {
            print("there is no filteredData in  prepareNBUcells()")
            return
        }
        self.dataNBUCells = []
        filteredData.forEach{ currency in
            let curAbbr = self.currencyAbbreviated(currency)
            let currencyName: String = self.nameCurrency.filter{ curr in
                return curr.attr == curAbbr
            }.first?.name ?? "Unknown currency"
            var count = 1
            var value = currency.purchaseRateNB
            while value < moneyConstants.minimalValueInHrivnaForCurrency {
                value = value * Float( moneyConstants.currencyMultiplier)
                count = count * moneyConstants.currencyMultiplier
            }
            let cell: CellNBU = CellNBU(currencyName: currencyName,
                            currency: curAbbr,
                            value: "\(value)",
                            count: "\(count) \(curAbbr)",
                            jumpTo: nil)
            self.dataNBUCells.append(cell)
        }
    }
    
    private func prepareCells() {
        guard self.data != nil else {
            print("there is no Data")
            return
        }
        self.preparePBCells()
        self.prepareNBUCells()
        
        let currenciesAbbr = self.dataPBCells.map{ data in
            return data.currency
        }
        currenciesAbbr.forEach{ abbr in
            guard let indexCellNBU = (self.dataNBUCells.firstIndex{
                return $0.currency == abbr
            }) else {return}
            
            guard let indexCellPB = (self.dataPBCells.firstIndex{
                return $0.currency == abbr
            }) else {return}
            
            self.dataNBUCells[indexCellNBU].jumpTo = indexCellPB
            self.dataPBCells[indexCellPB].jumpTo = indexCellNBU
        }
    }
    
    public func reloadData(on date: Date, refresh: @escaping ()->()) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: date)
        self.obtainerJSON.readHttpData(
            site: self.httpRequestPath,
            at: dateString){[weak self] newData in
                guard let this = self else {return}
                this.data = newData
                this.prepareCells()
                refresh()
        }
    }
    
}
