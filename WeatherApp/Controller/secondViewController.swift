//
//  secondViewController.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 11.03.2023.
//

import UIKit
import SnapKit

class secondViewController: UIViewController{
    
    var currentWeather: String = "111"
    var maxTemperature: String = ""
    var minTemperature: String = ""
    var weatherImage = UIImageView(image: UIImage(named: "05.partial-cloudy-light"))
    var weatherTitle: String = ""
    var backgroundImageView = UIImageView(image: UIImage(named: "clear-sky"))

    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()

    }
    
    // MARK: - Properties

    private let tableView = UITableView()
    private var items: [WeatherItemType] = [
        .cardWeather(WeatherItemInfo(weatherImage: UIImage(named: "05.partial-cloudy-light")!, backgraundImage: UIImage(named: "clear-sky")!, currentWeather: "-", cityName: "0", weatherTitle: "0", minTemp: "0", maxTemp: "0"))
    ]
}

// MARK: - Private methods

private extension secondViewController {
    func initialize(){
        view.addSubview(tableView)
        tableView.separatorColor = .clear
        tableView.register(WeatherCardCell.self, forCellReuseIdentifier: String(describing: WeatherCardCell.self))
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func getWeather(){
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=55.75&longitude=37.62&daily=temperature_2m_max,temperature_2m_min&current_weather=true&forecast_days=1&timezone=Europe%2FMoscow"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    self.currentWeather = "\(weather.currentWeather.temperature)°"

                    self.maxTemperature = "\(weather.daily.temperature2MMax)"
                    let tempHigh = String(self.maxTemperature.dropFirst().dropLast())
                    self.maxTemperature = "Макс:\(tempHigh)"
                    
                    self.minTemperature = "\(weather.daily.temperature2MMin)"
                    let tempLow = String(self.minTemperature.dropFirst().dropLast())
                    self.minTemperature = "Мин:\(tempLow)"
                    
                    let icon = IconWithString(date: weather.currentWeather.weathercode)
                    let image = icon.getImageForWeatherCode(weather.currentWeather.weathercode)
                    self.weatherImage.image = UIImage(named: image)
                    
                    let decodWeatherCode = DecodingTheWeatherString(date: weather.currentWeather.weathercode)
                    let textDecode = decodWeatherCode.getTextFromWeatherCode(weather.currentWeather.weathercode)
                    self.weatherTitle = textDecode
                    
                    let imageWeatherCode = DataBackgraundImage(date: weather.currentWeather.weathercode)
                    let imageBackgraundString = imageWeatherCode.getBGImageFromWeatherCode(weather.currentWeather.weathercode)
                    let imageBackgraund = UIImage(named: imageBackgraundString)
                    self.backgroundImageView = UIImageView(image: imageBackgraund)

                    self.updateWeatherInfo(weatherImage: UIImage(named: image), backgraundImage: self.backgroundImageView.image, currentWeather: self.currentWeather, cityName: self.weatherTitle, weatherTitle: self.weatherTitle, minTemp: self.minTemperature, maxTemp: self.maxTemperature)
                    
                    self.initialize()
                }
            } else {
                print("Fail!")
            }
        }
        task.resume()
    }
    
    
    func updateWeatherInfo(weatherImage: UIImage?, backgraundImage: UIImage?, currentWeather: String?, cityName: String?, weatherTitle: String?, minTemp: String?, maxTemp: String?) {
        if case var .cardWeather(itemInfo) = items.first {
            itemInfo.weatherImage = weatherImage ?? itemInfo.weatherImage
            itemInfo.backgraundImage = backgraundImage ?? itemInfo.backgraundImage
            itemInfo.currentWeather = currentWeather ?? itemInfo.currentWeather
            itemInfo.cityName = cityName ?? itemInfo.cityName
            itemInfo.weatherTitle = weatherTitle ?? itemInfo.weatherTitle
            itemInfo.minTemp = minTemp ?? itemInfo.minTemp
            itemInfo.maxTemp = maxTemp ?? itemInfo.maxTemp
            items[0] = .cardWeather(itemInfo)
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
            
        case .cardBox(let box):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BoxViewCell.self), for: indexPath) as! BoxViewCell; cell.configure(with: box)
            return cell
        }
    }
}
