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
    
    private let timezoneAbbreviationLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let winddirectionBox: BoxView = {
        let view = BoxView()
        return view
    }()
    
    private let winddirectionBox2: BoxView = {
        let view = BoxView()
        return view
    }()
    
    private let winddirectionBox3: BoxView = {
        let view = BoxView()
        return view
    }()
    
    private let winddirectionBox4: BoxView = {
        let view = BoxView()
        return view
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
        
        self.backgroundImageView.image = UIImage(named: "hard-cloudy")
        self.view.addSubview(self.backgroundImageView)
        self.view.sendSubviewToBack(self.backgroundImageView)
        self.backgroundImageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
        view.addSubview(weatherImageView)
        view.addSubview(weatherLabel)
        view.addSubview(decodingTheWeatherLabel)
        view.addSubview(windspeedLabel)
        view.addSubview(timezoneAbbreviationLabel)
        view.addSubview(cityLabel)
        view.addSubview(winddirectionBox)
        view.addSubview(winddirectionBox2)
        view.addSubview(winddirectionBox3)
        view.addSubview(winddirectionBox4)

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
        
        timezoneAbbreviationLabel.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.top.equalTo(windspeedLabel.snp.bottom).offset(20)
        }
        
        winddirectionBox.snp.makeConstraints { make in
            make.top.equalTo(timezoneAbbreviationLabel).inset(20)
            make.left.equalTo(20)
        }
        
        winddirectionBox2.snp.makeConstraints { make in
            make.top.equalTo(timezoneAbbreviationLabel).inset(20)
            make.right.equalTo(20)
        }
        
        winddirectionBox3.snp.makeConstraints { make in
            make.top.equalTo(winddirectionBox).inset(20)
            make.left.equalTo(20)
        }
        
        winddirectionBox4.snp.makeConstraints { make in
            make.top.equalTo(winddirectionBox2).inset(20)
            make.right.equalTo(20)
        }
        
    }
    
    private func getWeather(){
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
                    self.maxTemperatureLabel.text = "Макс:\(tempHigh)"
                    
                    self.minTemperatureLabel.text = "\(weather.daily.temperature2MMin)"
                    let tempLow = String(self.minTemperatureLabel.text!.dropFirst().dropLast())
                    self.minTemperatureLabel.text = "Мин:\(tempLow)"

                    
                    let icon = IconWithString(date: weather.currentWeather.weathercode)
                    let image = icon.getImageForWeatherCode(weather.currentWeather.weathercode)
                    self.weatherImageView.image = UIImage(named: image)
                    
                    let decodWeatherCode = DecodingTheWeatherString(date: weather.currentWeather.weathercode)
                    let textDecode = decodWeatherCode.getTextFromWeatherCode(weather.currentWeather.weathercode)
                    self.decodingTheWeatherLabel.text = textDecode
                    
                    let imageWeatherCode = DataBackgraundImage(date: weather.currentWeather.weathercode)
                    let imageBackgraundString = imageWeatherCode.getBGImageFromWeatherCode(weather.currentWeather.weathercode)
                    let imageBackgraund = UIImage(named: imageBackgraundString)
                    self.backgroundImageView = UIImageView(image: imageBackgraund)
                    self.view.addSubview(self.backgroundImageView)
                    self.view.sendSubviewToBack(self.backgroundImageView)
                    self.backgroundImageView.snp.makeConstraints { make in
                        make.width.height.equalToSuperview()
                    }
                }
            } else {
                print("Fail!")
            }
        }
        task.resume()
    }
}
