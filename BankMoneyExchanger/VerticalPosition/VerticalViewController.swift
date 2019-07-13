//
//  VerticalViewController.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/11/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import UIKit
import SnapKit

class VerticalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet weak var CurrencyPBTable: UITableView!
    @IBOutlet weak var CurrencyNBUTable: UITableView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var oneCalendarView: UIView!
    @IBOutlet weak var otherCalendarView: UIView!
    
    // MARK: -
    // MARK: Properties
    
    private var model: CurrencyModel?
    private var exchangeValuesArray: [CurrencyData] = []
    private var currenciesNames: [CurrencyName] = []
    
    // MARK: -
    // MARK: Init and Deinit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CurrencyNBUTable.delegate = self
        self.CurrencyNBUTable.dataSource = self
        self.CurrencyPBTable.delegate = self
        self.CurrencyPBTable.dataSource = self
        
        self.model = CurrencyModel()
        if let exchangeArray = self.model!.data?.exchangeRate {
            // print(exchangeArray)
            self.exchangeValuesArray = exchangeArray
        } else {
            print("some error in reading ExchangeValuesArray")
            return
        }
        self.currenciesNames = self.model!.nameCurrency
        
        self.CurrencyPBTable.register(UINib(nibName: "PBCell", bundle: nil), forCellReuseIdentifier: "PBCell")
        self.CurrencyNBUTable.register(UINib(nibName: "NBUCell", bundle: nil), forCellReuseIdentifier: "NBUCell")
    }
    
    // MARK: -
    // MARK: Table View Delegats
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == CurrencyPBTable {
            let count = self.exchangeValuesArray.count
            let filteredData = self.exchangeValuesArray.filter{ currency in
                return (currency.purchaseRate != nil)
            }
            return filteredData.count
        } else if tableView == CurrencyNBUTable {
            return self.exchangeValuesArray.filter{ currency in
                return currency.currency != nil
                }.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == CurrencyPBTable {
            return 50
        } else if tableView == CurrencyNBUTable {
            return 45
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == CurrencyPBTable {
            let filteredData = self.exchangeValuesArray.filter{ currency in
                return (currency.purchaseRate != nil) && (currency.currency != nil)
            }
            let cellData = filteredData[indexPath.item]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PBCell") as? PBCell {
                cell.currencyLabel.text = cellData.currency
                cell.currencyType = cellData.currency
                cell.buyingLabel.text = "\(cellData.purchaseRate ?? 0)"
                cell.sellingLabel.text = "\(cellData.saleRate ?? 0)"
                return cell
            }
        } else if tableView == CurrencyNBUTable {
            let filteredData = self.exchangeValuesArray.filter{ currency in
                return (currency.currency != nil)
            }
            let cellData = filteredData[indexPath.item]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NBUCell") as? NBUCell {
                cell.currencyNameLabel.text = currenciesNames.filter{ currency in
                    return currency.attr == (cellData.currency ?? "")
                }.first?.name ?? "not found"
                cell.valueLabel.text = "\(cellData.purchaseRateNB)"
                cell.countLabel.text = "1 UAH"
                cell.currencyAttr = cellData.currency ?? "???"
                return cell
            } else {return UITableViewCell()}
            
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == CurrencyPBTable {
            guard let cell = self.CurrencyPBTable.cellForRow(at: indexPath) as? PBCell else {
                return
            }
            let currentAttr = cell.currencyType ?? "???"
            
            let filteredData = self.exchangeValuesArray.filter{ currency in
                return (currency.currency != nil)
            }
            let itemIndex = filteredData.firstIndex{ currency in
                return currency.currency == currentAttr
            } ?? 1
            var newIndexPath = indexPath
            newIndexPath.item = itemIndex
            self.CurrencyNBUTable.selectRow(at: newIndexPath, animated: true, scrollPosition: .middle)
        }
        if tableView == CurrencyNBUTable {
            guard let cell = self.CurrencyNBUTable.cellForRow(at: indexPath) as? NBUCell else {
                return
            }
            let currentAttr = cell.currencyAttr
            
            let filteredData = self.exchangeValuesArray.filter{ currency in
                return (currency.purchaseRate != nil)
            }
            let itemIndex = filteredData.firstIndex{ currency in
                return currency.currency == currentAttr
                }
            if itemIndex == nil {
                self.CurrencyPBTable.selectRow(at: IndexPath(item: 1, section: 0), animated: false, scrollPosition: .none)
                self.CurrencyPBTable.deselectRow(at: IndexPath(item: 1, section: 0), animated: false)
                return
            }
            let newIndexPath = IndexPath(item: itemIndex!, section: 0)
            self.CurrencyPBTable.selectRow(at: newIndexPath, animated: true, scrollPosition: .middle)
        }
    }
    
    // MARK: -
    // MARK: Methods
    
    @IBAction func calendarButton(_ sender: Any) {
        //popover()
    }
    @IBAction func secondCalendarButton(_ sender: Any) {
       // popover()
    }
    
    override func viewWillLayoutSubviews() {
        /* self.CurrencyPBTable.snp.makeConstraints{ (make) -> () in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualToSuperview().dividedBy(3)
            make.top.equalTo(self.oneCalendarView.snp.bottom).offset(70)
        }
        self.CurrencyNBUTable.snp.makeConstraints{ (make) -> () in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualToSuperview().dividedBy(3)
            make.bottom.equalToSuperview().offset(50)
        } // */
    }
    
    func popover() {
        let actionController = UIAlertController(title: " ", message: " ", preferredStyle: .alert)
        
        let data = UIDatePicker.init(frame: CGRect(x:0, y: 0, width: 270, height: 80))
        data.maximumDate = Date(timeIntervalSinceNow: 0)
        let time = TimeInterval(exactly: -2*(365*24*60*60))
        data.minimumDate = Date(timeIntervalSinceNow: time ?? -5000)
        data.datePickerMode = .date
        actionController.view.addSubview(data)
        
        let popover = actionController.popoverPresentationController
        popover?.sourceView = view
        //popover?.sourceRect = CGRect(x: 0, y: 0, width: 300, height: 500)
        present(actionController, animated: true){
            
        }
    }
    
}

