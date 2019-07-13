//
//  VerticalView.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/12/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import UIKit

class VerticalView: UIView {

    // MARK: -
    // MARK: Properties
    
    @IBOutlet var CurrencyPBTable: UITableView?
    @IBOutlet var CurrencyNBUTable: UITableView?
    @IBOutlet var calendar: UIDatePicker?
    @IBOutlet weak var oneCalendarView: CalendarView!
    @IBOutlet weak var otherCalendarView: CalendarView!
    
    
    
    public var hideCalendar: ( (VerticalView) -> () ) = {view in
        guard view.calendar != nil else {
            return
        }
        view.calendar?.isHidden = true
    }
    
    // MARK: -
    // MARK: Methods
    
    @IBAction func choosenData(_ sender: Any) {
        hideCalendar(self)
        if let date = self.calendar?.date {
            print(date)
        }
    }
    
    @IBAction func otherCalendarButton(_ sender: Any) {
        showCalendar()
    }
    
    @IBAction func oneCalendarButton(_ sender: Any) {
        showCalendar()
    }
    
    public func showCalendar() {
        guard self.calendar != nil else {
            return
        }
        self.calendar?.isHidden = false
        self.calendar?.backgroundColor = .white
    }
    

}
