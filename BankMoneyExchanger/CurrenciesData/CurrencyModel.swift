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
        self.data = self.initReadFileJSON(from: self.pathCurrency)
        self.nameCurrency = self.initReadFileJSON(from: self.pathCurrencyNames) ?? []
        prepareCells()
    }
    
    // MARK: -
    // MARK: Methods
    
    private func initReadFileJSON<T: Decodable>(from path: String) -> T? {
        let text = self.pathToText(inputString: path)
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: text.data(using: .utf8)!)
        } catch {
            print("error in decoding JSON")
            return nil
        }
    }
    
    private func pathToText(inputString str: String) -> String{
        guard let path = Bundle.main.path(forResource: "\(str)", ofType: "json") else {
            print("File JSON not found")
            return ""
        }
        let expandedPath = URL(fileURLWithPath: path)
        return try! String(contentsOf: expandedPath)
    }
    
    private func preparePBcells() {
        guard self.data != nil else {
            print("there is no data in preparePBcells()!!!")
            return
        }
        let filteredData = self.data?.exchangeRate.filter { currency in
            return (currency.purchaseRate != nil) && (currency.currency != nil)
        }
        guard filteredData != nil else {
            print("there is no filteredData in  preparePBcells()")
            return
        }
        self.dataPBCells = []
        filteredData?.forEach{ currency in
            let cell: CellPB = CellPB(currency: currency.currency ?? "!!!",
                    buying: "\(currency.purchaseRate ?? 0)",
                    selling: "\(currency.saleRate ?? 0)",
                    jumpTo: nil)
            self.dataPBCells.append(cell)
        }
    }
    
    private func prepareNBUCells() {
        guard self.data != nil else {
            print("there is no data in preparePBcells()!!!")
            return
        }
        let filteredData = self.data?.exchangeRate.filter{ currency in
            return (currency.currency != nil)
        }
        guard filteredData != nil else {
            print("there is no filteredData in  prepareNBUcells()")
            return
        }
        self.dataNBUCells = []
        filteredData?.forEach{ currency in
            let curAtr = currency.currency ?? " "
            let currencyName: String = self.nameCurrency.filter{ curr in
                return curr.attr == curAtr
            }.first?.name ?? "Unknown currency"
            var count = 1
            var value = currency.purchaseRateNB
            while value < 1 {
                value = value * 10
                count = count * 10
            }
            let cell: CellNBU = CellNBU(currencyName: currencyName,
                            currency: curAtr,
                            value: "\(value)",
                            count: "\(count) \(curAtr)",
                            jumpTo: nil)
            self.dataNBUCells.append(cell)
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
    
    public func reloadData(on date: Date, refresh: @escaping ()->()) {
            self.refreshSelfFromHTTP (at: date)
            refresh()
        }
    
    
    private func refreshSelfFromHTTP (at date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: date)
        Alamofire.request(
            "https://api.privatbank.ua/p24api/exchange_rates",
                          method: .get,
                          parameters: ["json" : "", "date" : dateString])
            .responseString{ [weak self] response in
                guard let this = self else { return }
                switch response.result {
                case .success:
                    guard let rawJSON = response.value else { return }
                    let decoderNames = JSONDecoder()
                    do {
                        this.data = try decoderNames.decode(CurrenciesData.self, from: rawJSON.data(using: .utf8)!)
                    } catch {
                        print("error in decoding JSON")
                    }
                this.prepareCells()
            case .failure:
                print(response)
            }
        }
    }
}
