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

    public var calendarButton: UIButton?
    public var dateLabel: UILabel?
    
    // public var hello: String = "hello"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(imageLiteralResourceName: "calendar-1_32")
        self.calendarButton = UIButton()
        self.calendarButton?.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        self.calendarButton?.setImage(image, for: .normal)
        //self.calendarButton.addTarget(self, action: #selector(onDataPick), for: .touchDown)
        self.dateLabel = UILabel()
        self.dateLabel?.text = "10.07.2019"
        self.dateLabel?.frame = CGRect(x: 0,y: 0,width: 50,height: 50)
        if self.dateLabel != nil {
            self.addSubview(self.dateLabel!)
        }
        if self.calendarButton != nil {
            self.addSubview(self.calendarButton!)
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    }
    //*/
    
    override func layoutSubviews() {
        if self.dateLabel != nil {
            self.dateLabel?.snp.makeConstraints{ (make) -> () in
                make.right.equalToSuperview().offset(-5)
                make.centerY.equalToSuperview()
            }
        }
        if self.calendarButton != nil {
            self.calendarButton?.snp.makeConstraints{ (make) -> Void in
                make.right.equalTo(self.dateLabel?.snp.left ?? self.snp.left).offset(-5)
                make.centerY.equalToSuperview()
            }
        }
    }
    

}
