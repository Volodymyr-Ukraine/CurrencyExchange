//
//  CalendarView.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/12/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import UIKit
import SnapKit

class CalendarView: UIView {

    // MARK: -
    // MARK: Properties
    
    public var calendarButton: UIButton?
    public var dateLabel: UILabel = UILabel()
    
    // MARK: -
    // MARK: Init and Deinit
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initCalendarIco()
        self.initDateLabel()
    }
    
    override func layoutSubviews() {
        self.dateLabel.snp.makeConstraints{ (make) -> () in
                make.right.equalToSuperview().offset(-5)
                make.centerY.equalToSuperview()
        }
        if self.calendarButton != nil {
            self.calendarButton?.snp.makeConstraints{ (make) -> Void in
                make.right.equalTo(self.dateLabel.snp.left).offset(-5)
                make.centerY.equalToSuperview()
                make.height.equalTo(24)
                make.width.equalTo(24)
            }
        }
    }
    
    // MARK: -
    // MARK: Methods
    
    private func initCalendarIco() {
        let image = UIImage(imageLiteralResourceName: "calendar-1_32")
        self.calendarButton = UIButton()
        self.calendarButton?.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        self.calendarButton?.setImage(image, for: .normal)
        if self.calendarButton != nil {
            self.addSubview(self.calendarButton!)
        }
    }
    
    private func initDateLabel() {
        self.dateLabel.attributedText = NSAttributedString(string: "...", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        self.dateLabel.textColor = colorGoldFont
        self.dateLabel.frame = CGRect(x: 0,y: 0,width: 50,height: 50)
        self.addSubview(self.dateLabel)
    }

}
