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
    // MARK: Constants and Constraints
    
    struct constants {
        static let tablePBCellHeight: CGFloat = 50
        static let tableNBUCellHeight: CGFloat = 45
        static let day = 24*60*60
        static let year = 365*day
    }
    
    // MARK: -
    // MARK: Properties
    
    private var model: CurrencyModel?
    private var viewFormated: VerticalView? {
        get {
            return self.view as? VerticalView
        }
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.all
        }
    }

    // MARK: -
    // MARK: Init and Deinit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = CurrencyModel()
        guard let viewForced = self.viewFormated
            else {
                print("Error in init View")
                return
        }
        viewForced.setDates(date: self.model?.data?.date ?? "???")
        self.initTables(viewForced: viewForced)
        self.initCalendar(viewForced: viewForced)
    }
    
    override func viewWillLayoutSubviews() {
        self.viewFormated?.rotate()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.viewFormated?.rotate()
    }
    
    private func initTables(viewForced: VerticalView){
        self.initTable(table: &viewForced.currencyPBTable, name: "PBCell")
        self.initTable(table: &viewForced.currencyNBUTable, name: "NBUCell")
    }
    
    private func initTable(table: inout UITableView?, name: String) {
        if table == nil {
            table = UITableView()
        }
        table?.dataSource = self
        table?.delegate = self
        table?.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    private func initCalendar(viewForced: VerticalView){
        guard let calendar = viewForced.calendar
            else { return }
        calendar.maximumDate = Date.init(timeIntervalSinceNow: TimeInterval(-constants.day))
        calendar.minimumDate = Date.init(timeIntervalSinceNow: TimeInterval(-4*constants.year))
    }
    
    // MARK: -
    // MARK: Table View Delegats
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.choosenPBTableView(tableView) {
            return self.model?.dataPBCells.count ?? 1
        } else if self.choosenNBUTableView(tableView) {
            return self.model?.dataNBUCells.count ?? 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.choosenPBTableView(tableView) {
            return constants.tablePBCellHeight
        } else if self.choosenNBUTableView(tableView) {
            return constants.tableNBUCellHeight
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.choosenPBTableView(tableView) {
            guard indexPath.item < (self.model?.dataPBCells.count ?? 0) else {
                return UITableViewCell()
            }
            let cellInfo = self.model?.dataPBCells[indexPath.item] ?? CurrencyModel.CellPB(currency: "-", buying: "-", selling: "-", jumpTo: nil)
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PBCell") as? PBCell {
                cell.changeData(cellInfo.currency, cellInfo.buying, cellInfo.selling)
                return cell
            }
        } else if self.choosenNBUTableView(tableView) {
            guard indexPath.item < (self.model?.dataNBUCells.count ?? 0) else {
                return UITableViewCell()
            }
            let cellInfo = self.model?.dataNBUCells[indexPath.item] ?? CurrencyModel.CellNBU(currencyName: "-", currency: "-", value: "-", count: "-", jumpTo: nil)
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NBUCell") as? NBUCell {
                cell.changeData(cellInfo.currencyName, cellInfo.value, cellInfo.count)
                cell.backgroundColor = ((indexPath.item % 2) == 0) ? colorWhiteCell : colorGreenCell
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let tableNBU = self.viewFormated?.currencyNBUTable
        else { return }
        
        if self.choosenPBTableView(tableView) {
            guard indexPath.item < (self.model?.dataPBCells.count ?? 0),
                  let cellJump = self.model?.dataPBCells[indexPath.item].jumpTo
            else { return }
                
            tableNBU.selectRow(at: IndexPath(item: cellJump, section: 0), animated: true, scrollPosition: .middle)
        } else
        if self.choosenNBUTableView(tableView) {
            guard indexPath.item < (self.model?.dataNBUCells.count ?? 0),
                  let tablePB = self.viewFormated?.currencyPBTable
                else { return }
            
            if let cellJump = self.model?.dataNBUCells[indexPath.item].jumpTo {
                tablePB.selectRow(at: IndexPath(item: cellJump, section: 0), animated: true, scrollPosition: .middle)
            } else {
                tableNBU.deselectRow(at: IndexPath(item: indexPath.item, section: 0), animated: true)
                tablePB.selectRow(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .none)
                tablePB.deselectRow(at:  IndexPath(item: 0, section: 0), animated: false)
                return
            }
        }
    }
    
    // MARK: -
    // MARK: Actions
    
    @IBAction func showOneCalendarButton(_ sender: Any) {
        self.showCalendar()
    }
    
    @IBAction func showOtherCalendarButton(_ sender: Any) {
        self.showCalendar()
    }
    
    @IBAction func hideCalendarButton(_ sender: Any) {
        self.hideCalendar()
    }
    
    // MARK: -
    // MARK: Checking Methods
    
    private func choosenPBTableView(_ tableView: UITableView) -> Bool {
        return tableView == self.viewFormated?.currencyPBTable
    }
    
    private func choosenNBUTableView(_ tableView: UITableView) -> Bool {
        return tableView == self.viewFormated?.currencyNBUTable
    }
    
    // MARK: -
    // MARK: Methods
    
    private func showCalendar() {
        self.viewFormated?.calendar?.isHidden = false
        self.viewFormated?.calendar?.backgroundColor = .white
        self.viewFormated?.hideCallendarButton?.isHidden = false
    }
    
    private func hideCalendar() {
        self.viewFormated?.calendar?.isHidden = true
        self.viewFormated?.hideCallendarButton?.isHidden = true
        if let date = self.viewFormated?.calendar?.date {
            self.refreshDate(choosenDate: date)
        }
    }
    
    private func refreshDate(choosenDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        self.viewFormated?.setDates(date: formatter.string(from: choosenDate))
        
        guard let tablePB = self.viewFormated?.currencyPBTable,
              let tableNBU = self.viewFormated?.currencyNBUTable
            else { return }
        self.model?.reloadData(on: choosenDate) {
                tablePB.reloadData()
                tableNBU.reloadData()
        }
    }
}

