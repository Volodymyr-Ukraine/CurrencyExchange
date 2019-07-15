//
//  CalendarViewController.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/12/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import UIKit
import SnapKit

class CalendarViewController: UIViewController {
    
    // MARK: -
    // MARK: Properties
    
    public var viewCalendar: CalendarView?
 
    
    // MARK: -
    // MARK: Init and Deinit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCalendar = CalendarView()
    }
    
    override func loadView() {
        
        self.view = self.viewCalendar
    }

}
