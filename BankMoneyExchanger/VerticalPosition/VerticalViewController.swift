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
        let _ = self.unwrapOrInitModel()
        guard let viewForced = self.viewFormated
            else {
                print("Error in init View")
                return
        }
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
        let day = 24*60*60
        let year = 365*day
        calendar.maximumDate = Date.init(timeIntervalSinceNow: TimeInterval(-day))
        calendar.minimumDate = Date.init(timeIntervalSinceNow: TimeInterval(-4*year))
    }
    
    // MARK: -
    // MARK: Table View Delegats
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.viewFormated?.currencyPBTable {
            return self.model?.dataPBCells.count ?? 1
        } else if tableView == self.viewFormated?.currencyNBUTable {
            return self.model?.dataNBUCells.count ?? 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.viewFormated?.currencyPBTable {
            return constants.tablePBCellHeight
        } else if tableView == self.viewFormated?.currencyNBUTable {
            return constants.tableNBUCellHeight
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.viewFormated?.currencyPBTable {
            guard indexPath.item < (self.model?.dataPBCells.count ?? 0) else {
                return UITableViewCell()
            }
            let cellInfo = self.model?.dataPBCells[indexPath.item] ?? CurrencyModel.CellPB(currency: "-", buying: "-", selling: "-", jumpTo: nil)
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PBCell") as? PBCell {
                cell.changeData(cellInfo.currency, cellInfo.buying, cellInfo.selling)
                return cell
            }
        } else if tableView == self.viewFormated?.currencyNBUTable {
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
        guard let viewForce = self.view as? VerticalView,
              let model = self.model
            else { return }
        
        if tableView == self.viewFormated?.currencyPBTable {
            guard indexPath.item < model.dataPBCells.count,
                  let cellJump = model.dataPBCells[indexPath.item].jumpTo,
                  let tablePB = self.viewFormated?.currencyNBUTable
                else { return }
            tablePB.selectRow(at: IndexPath(item: cellJump, section: 0), animated: true, scrollPosition: .middle)
        }
        if tableView == self.viewFormated?.currencyNBUTable {
            guard indexPath.item < model.dataNBUCells.count,
                  let tablePB = self.viewFormated?.currencyPBTable
                else { return }
            
            if let cellJump = model.dataNBUCells[indexPath.item].jumpTo {
                tablePB.selectRow(at: IndexPath(item: cellJump, section: 0), animated: true, scrollPosition: .middle)
            } else {
                guard let tableNBU = viewForce.currencyNBUTable
                    else { return }
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
    
    private func unwrapOrInitModel() -> CurrencyModel {
        if let model = self.model {
            return model
        } else {
            self.model = CurrencyModel()
            return self.model!
        }
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
        unwrapOrInitModel().reloadData(on: choosenDate) {
                tablePB.reloadData()
                tableNBU.reloadData()
        }
    }
}

