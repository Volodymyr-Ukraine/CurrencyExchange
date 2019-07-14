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
    
    @IBOutlet public var currencyPBTable: UITableView?
    @IBOutlet public var currencyNBUTable: UITableView?
    @IBOutlet var calendar: UIDatePicker?
    @IBOutlet var hideCallendarButton: UIButton?
    @IBOutlet var oneCalendarView: CalendarView?
    @IBOutlet var otherCalendarView: CalendarView?
    
    
    
    public var hideCalendar: ( (VerticalView) -> () ) = {view in
        guard view.calendar != nil else {
            return
        }
        view.calendar?.isHidden = true
        
    }

}
