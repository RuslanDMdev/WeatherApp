//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 09.03.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Private properties
        
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Moscow"
        label.font = .systemFont(ofSize: 45, weight: .bold)
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let view = UIImageView()
        view.image?.withTintColor(UIColor.black)
        return view
    }()
    
    private let decodingTheWeatherLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    
    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let windspeedLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    

    
    var backgroundImageView = UIImageView()

    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        getWeather()
    }
}

// MARK: - Private methods

private extension MainViewController{
    func initialize(){
        
        view.backgroundColor = #colorLiteral(red: 0.403601592, green: 0.7426822547, blue: 0.7328542402, alpha: 1)
        view.addSubview(weatherImageView)
        view.addSubview(weatherLabel)
        view.addSubview(decodingTheWeatherLabel)
        view.addSubview(windspeedLabel)
        view.addSubview(cityLabel)
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityLabel.snp.bottom).offset(30)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
        
        decodingTheWeatherLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weatherImageView.snp.bottom).offset(5)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(decodingTheWeatherLabel.snp.bottom).offset(10)
        }
        
        let temperatureStack = UIStackView()
        temperatureStack.addArrangedSubview(minTemperatureLabel)
        temperatureStack.addArrangedSubview(maxTemperatureLabel)
        view.addSubview(temperatureStack)
        temperatureStack.spacing = 5
        temperatureStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weatherLabel.snp.bottom).offset(10)
        }

        
        windspeedLabel.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.top.equalTo(temperatureStack.snp.bottom).offset(10)
        }
        
        
    }
    
    private func getWeather(){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=292842ad3a54adb663034679ab2a5816"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let weatherGet = try? JSONDecoder().decode(WeatherDataStruct.self, from: data) {
                DispatchQueue.main.async {
                    self.weatherLabel.text = "\(weatherGet.main.temp)°"
                    
                    self.windspeedLabel.text = "Скорость ветра = \(weatherGet.wind.speed) м/с"
                    
                    self.maxTemperatureLabel.text = "\(weatherGet.main.tempMax)"
                    let tempHigh = String(self.maxTemperatureLabel.text!.dropFirst().dropLast())
                    self.maxTemperatureLabel.text = "Макс:\(tempHigh)"
                    
                    self.minTemperatureLabel.text = "\(weatherGet.main.tempMin)"
                    let tempLow = String(self.minTemperatureLabel.text!.dropFirst().dropLast())
                    self.minTemperatureLabel.text = "Мин:\(tempLow)"

                    var descriptionText = "\(weatherGet.weather.description)"
                    self.decodingTheWeatherLabel.text = "\(weatherGet.weather.description)"
                    if let range = descriptionText.range(of: "description: ") {
                        let description = descriptionText[range.upperBound...]
                            .trimmingCharacters(in: .whitespaces)
                            .prefix(while: { $0 != "," })
                            .trimmingCharacters(in: .punctuationCharacters)
                        print(description)
                        self.decodingTheWeatherLabel.text = description

                    }
                    

                }
            } else {
                print("Fail!")
            }
        }
        task.resume()
    }
}
