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
    // MARK: Properties
    
    private var model: CurrencyModel?
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.all;
        }
    }

    // MARK: -
    // MARK: Init and Deinit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = CurrencyModel()
        if let viewForced = self.view as? VerticalView {
            if viewForced.currencyPBTable == nil {
                viewForced.currencyPBTable = UITableView()
            }
            if viewForced.currencyNBUTable == nil {
                viewForced.currencyNBUTable = UITableView()
            }
            viewForced.currencyNBUTable?.delegate = self
            viewForced.currencyPBTable?.delegate = self
            viewForced.currencyPBTable?.dataSource = self
            viewForced.currencyNBUTable?.dataSource = self
            viewForced.currencyPBTable?.register(UINib(nibName: "PBCell", bundle: nil), forCellReuseIdentifier: "PBCell")
            viewForced.currencyNBUTable?.register(UINib(nibName: "NBUCell", bundle: nil), forCellReuseIdentifier: "NBUCell")
            guard let calendar = viewForced.calendar else {
                return
            }
            let day = 24*60*60
            calendar.maximumDate = Date.init(timeIntervalSinceNow: TimeInterval(-day))
            
            let year = 365*day
            calendar.minimumDate = Date.init(timeIntervalSinceNow: TimeInterval(-4*year))
            viewForced.rotate()
        }
    }
    
    // MARK: -
    // MARK: Table View Delegats
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model else {
            return 1
        }
        
        guard let viewForce = self.view as? VerticalView else {
            return 1
        }
        
        if tableView == viewForce.currencyPBTable {
            return model.dataPBCells.count
        } else if tableView == viewForce.currencyNBUTable {
            return model.dataNBUCells.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewForce = self.view as? VerticalView else {
            return 10
        }
        if tableView == viewForce.currencyPBTable {
            return 50
        } else if tableView == viewForce.currencyNBUTable {
            return 45
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewForce = self.view as? VerticalView else {
            return UITableViewCell()
        }
        
        guard let model = self.model else {
            return UITableViewCell()
        }
        
        if tableView == viewForce.currencyPBTable {
            guard indexPath.item < model.dataPBCells.count else {
                return UITableViewCell()
            }
            let cellInfo = model.dataPBCells[indexPath.item]
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PBCell") as? PBCell {
                cell.changeData(cellInfo.currency, cellInfo.buying, cellInfo.selling)
                return cell
            }
        } else if tableView == viewForce.currencyNBUTable {
            
            guard indexPath.item < model.dataNBUCells.count else {
                return UITableViewCell()
            }
            let cellInfo = model.dataNBUCells[indexPath.item]
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NBUCell") as? NBUCell {
                cell.changeData(cellInfo.currencyName, cellInfo.value, cellInfo.count)
                cell.backgroundColor = ((indexPath.item % 2) == 0) ? colorWhiteCell : colorGreenCell
                return cell
            } else {
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewForce = self.view as? VerticalView else {
            return
        }
        guard let model = self.model else {
            return
        }
        if tableView == viewForce.currencyPBTable {
            guard indexPath.item < model.dataPBCells.count else {
                return
            }
            guard let cellJump = model.dataPBCells[indexPath.item].jumpTo else {
                return
            }
            guard let tablePB = viewForce.currencyNBUTable else {
                return
            }
            tablePB.selectRow(at: IndexPath(item: cellJump, section: 0), animated: true, scrollPosition: .middle)
        }
        if tableView == viewForce.currencyNBUTable {
            guard indexPath.item < model.dataNBUCells.count else {
                return
            }
            guard let tablePB = viewForce.currencyPBTable else {
                return
            }
            guard let cellJump = model.dataNBUCells[indexPath.item].jumpTo else {
                guard let tableNBU = viewForce.currencyNBUTable else {
                    return
                }
                tableNBU.deselectRow(at: IndexPath(item: indexPath.item, section: 0), animated: true)
                tablePB.selectRow(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .none)
                tablePB.deselectRow(at:  IndexPath(item: 0, section: 0), animated: false)
                return
            }
            tablePB.selectRow(at: IndexPath(item: cellJump, section: 0), animated: true, scrollPosition: .middle)
        }
    }
    
    // MARK: -
    // MARK: Actions
    
    @IBAction func showOneCalendarButton(_ sender: Any) {
        showCalendar()
    }
    
    @IBAction func showOtherCalendarButton(_ sender: Any) {
        showCalendar()
    }
    
    @IBAction func hideCalendarButton(_ sender: Any) {
        hideCalendar()
    }
    
    
    // MARK: -
    // MARK: Methods
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let viewForced = self.view as? VerticalView else {
            return
        }
        viewForced.rotate()
    }
    
    public func showCalendar() {
        guard let viewForced = self.view as? VerticalView else {
            return
        }
        guard let calendar = viewForced.calendar else {
            return
        }
        calendar.isHidden = false
        calendar.backgroundColor = .white
        
        guard let hideButton = viewForced.hideCallendarButton else {
            return
        }
        hideButton.isHidden = false
    }
    
    public func hideCalendar() {
        guard let viewForced = self.view as? VerticalView else {
            return
        }
        guard let calendar = viewForced.calendar else {
            return
        }
        calendar.isHidden = true
        guard let hideButton = viewForced.hideCallendarButton else {
            return
        }
        hideButton.isHidden = true
        refreshDate(choosenDate: calendar.date)
    }
    
    private func refreshDate(choosenDate: Date) {
        guard let viewForced = self.view as? VerticalView else {
            return
        }
        guard let oneCalendar = viewForced.oneCalendarView else {
            return
        }
        guard let oneDate = oneCalendar.dateLabel else {
            return
        }
        guard let otherCalendar = viewForced.otherCalendarView else {
            return
        }
        guard let otherDate = otherCalendar.dateLabel else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        oneDate.text = formatter.string(from: choosenDate)
        otherDate.text = oneDate.text
        
        guard let model = self.model else {
            return
        }
        
        guard let tablePB = viewForced.currencyPBTable else {
            return
        }
        guard let tableNBU = viewForced.currencyNBUTable else {
            return
        }
        model.reloadData(on: choosenDate) {
                tablePB.reloadData()
                tableNBU.reloadData()
        }
    }

    
}

