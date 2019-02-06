//
//  ViewController.swift
//  MyCalendar
//
//  Created by Manjunath Shivakumara on 27/11/18.
//  Copyright © 2018 Manjunath Shivakumara. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MonthViewDelegate {
    func didChangeMonth(monthIndex: Int, year: Int) {
        calendarView.didChangeMonth(monthIndex: monthIndex, year: year)
    }
    
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    let returnButton: UIButton = {
        let but = UIButton(frame: CGRect(x: 16.0, y: Colors.screenHeight - 80.0, width: Colors.screenWidth - 32.0, height: 48.0))
        but.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        but.setTitle("Return to today", for: .normal)
        but.addTarget(self, action: #selector(btnReturnToToday), for: .touchUpInside)
        return but
    }()

    var backgroundImage : UIImageView!
    let monthView = MonthView()
    let calendarView = CalenderView()
    let weekDaysView = WeekdaysView()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.title = "My Calender"
        self.navigationController?.navigationBar.isTranslucent=false
        
        backgroundImage = UIImageView(frame: self.view.frame)
        backgroundImage.image = UIImage.init(named: "TrackingImage")
        view.addSubview(backgroundImage)
        
        self.monthView.frame = CGRect(x: 16.0, y: 70.0, width: screenWidth - 32.0, height: 30.0)
        self.weekDaysView.frame = CGRect(x: 16.0, y: (self.monthView.frame.origin.y+self.monthView.frame.height + 30.0), width: screenWidth - 32.0, height: 30.0)
        self.calendarView.frame = CGRect(x: 16.0, y: (self.weekDaysView.frame.origin.y+self.weekDaysView.frame.height), width: screenWidth - 32.0, height: 370.0)
        self.calendarView.initializeView()
        
        self.view.addSubview(calendarView)
        self.view.addSubview(weekDaysView)
        self.view.addSubview(monthView)
        self.view.addSubview(returnButton)
        monthView.delegate = self
        
        
    }
    
    @objc func btnReturnToToday() {
        print("Return to today button tapped")
        let currentMonthIndex = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        monthView.currentMonthIndex = currentMonthIndex
        monthView.currentYear = currentYear
        monthView.btnLeftRightAction(sender: returnButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    var calenderView: CalenderView = {
        let v=CalenderView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()

}

