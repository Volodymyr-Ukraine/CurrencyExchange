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

    @IBOutlet var commonViewTop: UIView?
    @IBOutlet var commonViewPB: UIView?
    @IBOutlet var commonViewNBU: UIView?
    
    // MARK: -
    // MARK: Methods
    
    public func rotate(){
        guard let topView = self.commonViewTop,
        let pbView = self.commonViewPB,
        let nbuView = self.commonViewNBU
        
        else {
            return
        }
        
        topView.snp.updateConstraints{ (make) -> () in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(75)
        }
        if UIDevice.current.orientation.isLandscape {
            pbView.snp.remakeConstraints{ (make) -> () in
                make.top.equalTo(topView.snp.bottom).offset(0)
                make.left.equalToSuperview()
                make.right.equalTo(topView.snp.centerX)
                make.bottom.equalToSuperview()
                make.height.equalToSuperview().offset(-75)
            }
            nbuView.snp.remakeConstraints{(make) -> () in
                make.top.equalTo(topView.snp.bottom).offset(0)
                make.left.equalTo(topView.snp.centerX)
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalToSuperview().offset(-75)
            }
        } else {
            pbView.snp.remakeConstraints{ (make) -> () in
                make.top.equalTo(topView.snp.bottom)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview().dividedBy(2)
            }
            nbuView.snp.remakeConstraints{(make) -> () in
                make.top.equalTo(pbView.snp.bottom)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalToSuperview().dividedBy(2)
            }
        }
    }
    
}
