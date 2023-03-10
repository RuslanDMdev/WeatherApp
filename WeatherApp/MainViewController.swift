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
        view.image = UIImage(named: "WeatherIcon2")
        view.image?.withTintColor(UIColor.black)
        return view
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
    
    private let timezoneAbbreviationLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    
    
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
        
        let backgroundImage = UIImage(named: "background.jpg")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        view.addSubview(weatherImageView)
        view.addSubview(weatherLabel)
        view.addSubview(windspeedLabel)
        view.addSubview(timezoneAbbreviationLabel)
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
        
            weatherLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weatherImageView.snp.bottom).offset(20)
        }
        
        let temperatureStack = UIStackView()
        temperatureStack.addArrangedSubview(minTemperatureLabel)
        temperatureStack.addArrangedSubview(maxTemperatureLabel)
        view.addSubview(temperatureStack)
        temperatureStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weatherLabel.snp.bottom).offset(10)        }

        
        windspeedLabel.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.top.equalTo(temperatureStack.snp.bottom).offset(10)
        }
        
        timezoneAbbreviationLabel.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.top.equalTo(windspeedLabel.snp.bottom).offset(20)
        }
        
    }
    
    func getWeather(){
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=55.75&longitude=37.62&daily=temperature_2m_max,temperature_2m_min&current_weather=true&forecast_days=1&timezone=Europe%2FMoscow"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    self.weatherLabel.text = "\(weather.currentWeather.temperature)°"
                    self.windspeedLabel.text = "Скорость ветра = \(weather.currentWeather.windspeed) м/с"
                    self.timezoneAbbreviationLabel.text = "\(weather.timezoneAbbreviation)"
                    
                    self.maxTemperatureLabel.text = "\(weather.daily.temperature2MMax)"
                    let tempHigh = String(self.maxTemperatureLabel.text!.dropFirst().dropLast())
                    self.maxTemperatureLabel.text = "H:\(tempHigh)"
                    
                    self.minTemperatureLabel.text = "\(weather.daily.temperature2MMin)"
                    let tempLow = String(self.minTemperatureLabel.text!.dropFirst().dropLast())
                    self.minTemperatureLabel.text = "L:\(tempLow)"

                }
            } else {
                print("Fail!")
            }
        }
        task.resume()
    }
}
