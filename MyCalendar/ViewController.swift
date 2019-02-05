//
//  ViewController.swift
//  MyCalendar
//
//  Created by Manjunath Shivakumara on 27/11/18.
//  Copyright © 2018 Manjunath Shivakumara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    var backgroundImage : UIImageView!
    let monthView = MonthView()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.title = "My Calender"
        self.navigationController?.navigationBar.isTranslucent=false
        
        backgroundImage = UIImageView(frame: self.view.frame)
        backgroundImage.image = UIImage.init(named: "TrackingImage")
        view.addSubview(backgroundImage)
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 520).isActive=true
    
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

