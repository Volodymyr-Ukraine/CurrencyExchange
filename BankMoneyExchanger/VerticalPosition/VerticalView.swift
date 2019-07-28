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
    // MARK: Constants and Constraints
    
    struct offsets {
        static let topHeight = 75
    }

    // MARK: -
    // MARK: Properties
    
    @IBOutlet public var currencyPBTable: UITableView?
    @IBOutlet public var currencyNBUTable: UITableView?
    @IBOutlet public var calendar: UIDatePicker?
    @IBOutlet public var hideCallendarButton: UIButton?
    @IBOutlet public var oneCalendarView: CalendarView?
    @IBOutlet public var otherCalendarView: CalendarView?

    @IBOutlet private var commonViewTop: UIView?
    @IBOutlet private var commonViewPB: UIView?
    @IBOutlet private var commonViewNBU: UIView?
    
    // MARK: -
    // MARK: Methods
    
    public func setDates(date: String){
        self.oneCalendarView?.dateLabel?.text = date
        self.otherCalendarView?.dateLabel?.text = date
    }
    
    public func rotate(){
        guard let topView = self.commonViewTop,
              let pbView = self.commonViewPB,
              let nbuView = self.commonViewNBU
          else { return }
        if UIDevice.current.orientation.isLandscape {
            makeHorisontal(nbuView: nbuView, pbView: pbView, topView: topView)
        } else {
            makeVertical(nbuView: nbuView, pbView: pbView, topView: topView)
        }
    }
    
    private func makeHorisontal(nbuView: UIView, pbView: UIView, topView: UIView) {
        topView.snp.updateConstraints{ (make) -> () in
            make.top.left.right.width.equalToSuperview()
            make.height.equalTo(offsets.topHeight)
        }
        pbView.snp.remakeConstraints{ (make) -> () in
            make.top.equalTo(topView.snp.bottom).offset(0)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(topView.snp.centerX)
        }
        nbuView.snp.remakeConstraints{(make) -> () in
            make.top.equalTo(topView.snp.bottom).offset(0)
            make.left.equalTo(topView.snp.centerX)
            make.right.bottom.equalToSuperview()
        }
    }
    private func makeVertical(nbuView: UIView, pbView: UIView, topView: UIView) {
        topView.snp.updateConstraints{ (make) -> () in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(offsets.topHeight)
        }
        pbView.snp.remakeConstraints{ (make) -> () in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().dividedBy(2)
        }
        nbuView.snp.remakeConstraints{(make) -> () in
            make.top.equalTo(pbView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
    }
}
