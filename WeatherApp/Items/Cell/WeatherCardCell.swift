//
//  WeatherCardCell.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 28.03.2023.
//

import UIKit
import SnapKit

class WeatherCardCell: UITableViewCell {
        

    // MARK: - Private properties
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "N/a"
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
        label.text = "N/a"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "N/a"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    
    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "N/a"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "N/a"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    
    var backgroundImageView = UIImageView()

    // MARK: - Public
    func configure(with info: WeatherItemInfo){
        weatherImageView.image = info.weatherImage 
        backgroundImageView.image = info.backgraundImage
        weatherLabel.text = info.currentWeather
        cityLabel.text = info.cityName
        decodingTheWeatherLabel.text = info.weatherTitle
        minTemperatureLabel.text = info.minTemp
        maxTemperatureLabel.text = info.maxTemp
    }
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private constants
    
    private enum UIConstants{
        static let userImageSize: CGFloat = 150
        static let contentInset: CGFloat = 12
        static let userImageTopInset: CGFloat = 6
        static let userNameStackToPrifilieImageOffset: CGFloat = 12
        static let postImageToUserImageOffset: CGFloat = 6

        //MARK: - Fonts
        static let userPostNameFontSize: CGFloat = 14
        static let subtitleFontSize: CGFloat = 11

    }

    

    
}
// MARK: - Private methods
private extension WeatherCardCell{
    func initialize(){
        selectionStyle = .none
        contentView.addSubview(weatherImageView)
        contentView.addSubview(weatherLabel)
        contentView.addSubview(decodingTheWeatherLabel)
        contentView.addSubview(cityLabel)

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
        contentView.addSubview(temperatureStack)
        temperatureStack.spacing = 5
        temperatureStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weatherLabel.snp.bottom).offset(10)
        }
        
        func getWeather(){
            let urlString = "https://api.open-meteo.com/v1/forecast?latitude=55.75&longitude=37.62&daily=temperature_2m_max,temperature_2m_min&current_weather=true&forecast_days=1&timezone=Europe%2FMoscow"
            let url = URL(string: urlString)!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data, let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    DispatchQueue.main.async {
                        self.weatherLabel.text = "\(weather.currentWeather.temperature)°"
                        
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
                        self.contentView.addSubview(self.backgroundImageView)
                        self.contentView.sendSubviewToBack(self.backgroundImageView)
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
}
