//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 09.03.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    
    // MARK: - Properties

    private let tableView = UITableView()
    private var items: [WeatherItemType] = [
        .cardWeather(WeatherItemInfo(weatherImage: UIImage(named: "05.partial-cloudy-light")!, backgraundImage: UIImage(named: "clear-sky")!, currentWeather: "-", cityName: "0", weatherTitle: "0", minTemp: "0", maxTemp: "0")),
        .cardBox(CardBoxItemInfo(boxName: "Ветер", boxValue: "0", boxDescription: "0")),
        .cardBox(CardBoxItemInfo(boxName: "Влажность", boxValue: "1", boxDescription: "1")),
        .cardBox(CardBoxItemInfo(boxName: "Давление", boxValue: "2", boxDescription: "2")),
        .cardBox(CardBoxItemInfo(boxName: "Уровень моря", boxValue: "3", boxDescription: "3"))
        
    ]
    
    
    var secondApiUrl: String = "https://api.openweathermap.org/data/2.5/weather?lat=0&lon=0&appid=292842ad3a54adb663034679ab2a5816&units=metric"
    var currentWeather: String = ""
    var maxTemperature: String = ""
    var minTemperature: String = ""
    var weatherImage = UIImageView(image: UIImage(named: ""))
    var weatherTitle: String = ""
    var backgroundImageView = UIImageView(image: UIImage(named: ""))
    
    private let searchTextField: UITextField = {
       let textField = UITextField()
        textField.text = "Moscow"
        return textField
    }()
    
    private let getWeatherButton: UIButton = {
        let button = UIButton()
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitle("Обновить погоду", for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCityName()
    }
    

}

// MARK: - Private methods

private extension MainViewController{
    func initialize(){
        view.addSubview(tableView)
        tableView.separatorColor = .clear
        tableView.register(WeatherCardCell.self, forCellReuseIdentifier: String(describing: WeatherCardCell.self))
        tableView.register(BoxViewCell.self, forCellReuseIdentifier: String(describing: BoxViewCell.self))
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func getCityName(){
        
        let cityName = searchTextField.text!
        let geoApiUrl = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=5&appid=292842ad3a54adb663034679ab2a5816"
        updateCityName(cityName: cityName)
        
        // First, get the latitude and longitude from the geo API
        if let url = URL(string: geoApiUrl) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                guard let data = data else {
                    print("Error: No data received")
                    return
                }
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        if let firstResult = jsonArray.first,
                           let latitude = firstResult["lat"] as? Double,
                           let longitude = firstResult["lon"] as? Double {
                            self.secondApiUrl =                             "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=292842ad3a54adb663034679ab2a5816&units=metric"
                            // Now you can use the latitude and longitude in the second API
                            // TODO: Perform API call to second API
                            print("Latitude: \(latitude), Longitude: \(longitude)")
                            print("Second API URL: \(self.secondApiUrl)")
                            self.getWeather()
                            
                        }
                    }
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }

    }
    
    private func getWeather(){
        let url = URL(string: secondApiUrl)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let weatherGet = try? JSONDecoder().decode(WeatherDataStruct.self, from: data) {
                DispatchQueue.main.async {
                    self.currentWeather = "\(weatherGet.main.temp)°"
                    
                    self.maxTemperature = "\(weatherGet.main.tempMax)"
                    let tempHigh = String(self.maxTemperature.dropFirst().dropLast())
                    self.maxTemperature = "Max:\(tempHigh)"
                    
                    self.minTemperature = "\(weatherGet.main.tempMin)"
                    let tempLow = String(self.minTemperature.dropFirst().dropLast())
                    self.minTemperature = "Min:\(tempLow)"
                    
                    var descriptionText = "\(weatherGet.weather.description)"
                    self.weatherTitle = "\(weatherGet.weather.description)"
                    if let range = descriptionText.range(of: "description: ") {
                        let description = descriptionText[range.upperBound...]
                            .trimmingCharacters(in: .whitespaces)
                            .prefix(while: { $0 != "," })
                            .trimmingCharacters(in: .punctuationCharacters)
                        print(description)
                        self.weatherTitle = description
                    }
                    self.updateWeatherInfo(weatherImage: UIImage(named: "image"), backgraundImage: self.backgroundImageView.image, currentWeather: self.currentWeather, weatherTitle: self.weatherTitle, minTemp: self.minTemperature, maxTemp: self.maxTemperature)
                    
                    self.initialize()

                }
            } else {
                print("Fail!")
            }
        }
        task.resume()
    }
        
        func updateWeatherInfo(weatherImage: UIImage?, backgraundImage: UIImage?, currentWeather: String?, weatherTitle: String?, minTemp: String?, maxTemp: String?) {
            if case var .cardWeather(itemInfo) = items.first {
                itemInfo.weatherImage = weatherImage ?? itemInfo.weatherImage
                itemInfo.backgraundImage = backgraundImage ?? itemInfo.backgraundImage
                itemInfo.currentWeather = currentWeather ?? itemInfo.currentWeather
                itemInfo.weatherTitle = weatherTitle ?? itemInfo.weatherTitle
                itemInfo.minTemp = minTemp ?? itemInfo.minTemp
                itemInfo.maxTemp = maxTemp ?? itemInfo.maxTemp
                items[0] = .cardWeather(itemInfo)
            }
        }
    func updateCityName(cityName: String?) {
        if case var .cardWeather(itemInfo) = items.first {
            itemInfo.cityName = cityName ?? itemInfo.cityName
            items[0] = .cardWeather(itemInfo)
        }
    }
    }
    
    extension MainViewController: UITableViewDataSource{
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
                
            case .cardBox(let box):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BoxViewCell.self), for: indexPath) as! BoxViewCell; cell.configure(with: box)
                return cell
                
            }
        }
    }

