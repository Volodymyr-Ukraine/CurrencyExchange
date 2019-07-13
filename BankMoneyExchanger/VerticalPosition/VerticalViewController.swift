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
    //private var exchangeValuesArray: [CurrencyData] = []
    //private var currenciesNames: [CurrencyName] = []
    
    // MARK: -
    // MARK: Init and Deinit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CurrencyNBUTable.delegate = self
        self.CurrencyNBUTable.dataSource = self
        self.CurrencyPBTable.delegate = self
        self.CurrencyPBTable.dataSource = self
        
        self.model = CurrencyModel()
        
        self.CurrencyPBTable.register(UINib(nibName: "PBCell", bundle: nil), forCellReuseIdentifier: "PBCell")
        self.CurrencyNBUTable.register(UINib(nibName: "NBUCell", bundle: nil), forCellReuseIdentifier: "NBUCell")
    }
    
    // MARK: -
    // MARK: Table View Delegats
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model else {
            return 1
        }
        if tableView == CurrencyPBTable {
            return model.dataPBCells.count
        } else if tableView == CurrencyNBUTable {
            return model.dataNBUCells.count
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
            guard let model = self.model else {
                return UITableViewCell()
            }
            guard indexPath.item < model.dataPBCells.count else {
                return UITableViewCell()
            }
            let cellInfo = model.dataPBCells[indexPath.item]
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PBCell") as? PBCell {
                cell.currencyLabel.text = cellInfo.currency
                cell.currencyType = cellInfo.currency // ToDo: deprecated
                cell.buyingLabel.text = cellInfo.buying
                cell.sellingLabel.text = cellInfo.selling
                return cell
            }
        } else if tableView == CurrencyNBUTable {
            guard let model = self.model else {
                return UITableViewCell()
            }
            guard indexPath.item < model.dataNBUCells.count else {
                return UITableViewCell()
            }
            let cellInfo = model.dataNBUCells[indexPath.item]
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NBUCell") as? NBUCell {
                cell.currencyNameLabel.text = cellInfo.currencyName
                cell.valueLabel.text = cellInfo.value
                cell.countLabel.text = cellInfo.count
                cell.currencyAttr = cellInfo.currency
                cell.backgroundColor = ((indexPath.item % 2) == 0) ? colorWhiteCell : colorGreenCell
                return cell
            } else {return UITableViewCell()}
            
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == CurrencyPBTable {
            guard let model = self.model else {
                return
            }
            guard indexPath.item < model.dataPBCells.count else {
                return
            }
            guard let cellJump = model.dataPBCells[indexPath.item].jumpTo else {
                return
            }
            self.CurrencyNBUTable.selectRow(at: IndexPath(item: cellJump, section: 0), animated: true, scrollPosition: .middle)
        }
        if tableView == CurrencyNBUTable {
            guard let model = self.model else {
                return
            }
            guard indexPath.item < model.dataNBUCells.count else {
                return
            }
            guard let cellJump = model.dataNBUCells[indexPath.item].jumpTo else {
                self.CurrencyNBUTable.deselectRow(at: IndexPath(item: indexPath.item, section: 0), animated: true)
                self.CurrencyPBTable.selectRow(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .none)
                self.CurrencyPBTable.deselectRow(at:  IndexPath(item: 0, section: 0), animated: false)
                return
            }
            self.CurrencyPBTable.selectRow(at: IndexPath(item: cellJump, section: 0), animated: true, scrollPosition: .middle)
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

