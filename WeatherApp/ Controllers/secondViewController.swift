//
//  secondViewController.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 11.03.2023.
//

import UIKit
import SnapKit

class secondViewController: UIViewController{
    
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "N/a"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize ()
        

    }
    
    // MARK: - Feed properties

    private let tableView = UITableView()
    private var items: [WeatherItemType] = [
        .cardWeather(WeatherItemInfo(weatherImage: UIImage(named: "05.partial-cloudy-light")!, backgraundImage: UIImage(named: "clear-sky")!, currentWeather: "0", cityName: "0", weatherTitle: "0", minTemp: "0", maxTemp: "0"))
    ]
}

// MARK: - Private methods

private extension secondViewController {
    func initialize(){
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.separatorColor = .clear
        tableView.register(WeatherCardCell.self, forCellReuseIdentifier: String(describing: WeatherCardCell.self))
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    
}

// MARK: - UITableViewDataSource

extension secondViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        switch item {
            
        case .cardWeather(let cardWeather):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherCardCell.self), for: indexPath) as! WeatherCardCell;
            cell.configure(with: cardWeather)
            return cell
            
        }
    }
}
