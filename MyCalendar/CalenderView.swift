//
//  CalenderView.swift
//  MyCalendar
//
//  Created by Manjunath Shivakumara on 27/11/18.
//  Copyright © 2018 Manjunath Shivakumara. All rights reserved.
//

import UIKit

struct Colors {
    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
    static var selectedColor = UIColor(red: 66.0/255.0, green: 173.0/255.0, blue: 161.0/255.0, alpha: 1.0)
    static var todayColor = UIColor.orange
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    var todayIndexPath : IndexPath!
    
    let monthView: MonthView = {
        let v=MonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v=WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    public var someDate: Date! {
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 2
        dateComponents.day = 15
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let setDate = userCalendar.date(from: dateComponents)
        return setDate
    }
    
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView=UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: Colors.screenWidth - 32.0, height: 380.0), collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        myCollectionView.scrollsToTop = true
        myCollectionView.isScrollEnabled = false
        return myCollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
        self.addSubview(myCollectionView)
        self.bringSubviewToFront(myCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            cell.lbl.textColor = UIColor.white
            
            let calendar = NSCalendar.current
            let day = calendar.component(.day, from: Date())
            let month = calendar.component(.month, from: Date())
            let year = calendar.component(.year, from: Date())
            cell.isUserInteractionEnabled = false
            
            let someMonth = calendar.component(.month, from: self.someDate)
            let someDate = calendar.component(.day, from: self.someDate)
            let someYear = calendar.component(.year, from: self.someDate)
            
            if calcDate == day && month == currentMonthIndex && year == currentYear {
                cell.backgroundColor=Colors.todayColor
                todayIndexPath = IndexPath(row: indexPath.row, section: indexPath.section)
            } else if month < currentMonthIndex && year == currentYear {
                cell.layer.backgroundColor = UIColor.clear.cgColor
                cell.isUserInteractionEnabled = false
            } else if calcDate >= day && month == currentMonthIndex && year == currentYear {
                cell.layer.backgroundColor = UIColor.clear.cgColor
                cell.isUserInteractionEnabled = false
            } else if year<currentYear {
                cell.layer.backgroundColor = UIColor.clear.cgColor
                cell.isUserInteractionEnabled = false
            } else if someYear <= currentYear && someMonth <= currentMonthIndex {
                if (someDate <= calcDate && someMonth == currentMonthIndex) || (someMonth < currentMonthIndex && month >= someMonth) {
                    cell.layer.backgroundColor = UIColor.white.withAlphaComponent(0.16).cgColor
                    cell.isUserInteractionEnabled = true
                } else {
                    cell.layer.backgroundColor = UIColor.clear.cgColor
                    cell.isUserInteractionEnabled = false
                }
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=Colors.selectedColor
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor=UIColor.white
        
        let startWeek = Date().startOfWeek
        let endWeek = Date().endOfWeek
        
        print(startWeek)
        print(endWeek)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = UIColor.white
        
        let calcDate = indexPath.row-firstWeekDayOfMonth+2
        
        let calendar = NSCalendar.current
        let day = calendar.component(.day, from: Date())
        let month = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        
        if calcDate == day && month == currentMonthIndex && year == currentYear{
            cell?.backgroundColor=Colors.todayColor
        } else {
            cell?.layer.backgroundColor = UIColor.white.withAlphaComponent(0.16).cgColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex+1
        currentYear = year

        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end

        firstWeekDayOfMonth=getFirstWeekDay()
        myCollectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius = frame.size.width / 2.0
        layer.masksToBounds=true
        setupViews()
    }
    
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 18)
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

extension Date {
    var startOfWeek: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
    }
}












