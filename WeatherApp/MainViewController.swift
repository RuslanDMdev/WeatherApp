//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 09.03.2023.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}
//MARK: private methods

private extension MainViewController {
    
    func initialize(){
        view.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1882352941, alpha: 1)
        
    }
}
