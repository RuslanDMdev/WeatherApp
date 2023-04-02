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
    
    private let winddirectionBox: BoxView = {
        let view = BoxView()
        view.boxNamelabel
        return view
    }()
    
    private let feelsLikeBox: BoxView = {
        let view = BoxView()
        return view
    }()
    
    private let humidityBox: BoxView = {
        let view = BoxView()
        return view
    }()
    
    private let pressureBox: BoxView = {
        let view = BoxView()
        return view
    }()
    
    private let seaLevelBox: BoxView = {
        let view = BoxView()
        return view
    }()
    
    private let grndLevelBox: BoxView = {
        let view = BoxView()
        return view
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
        contentView.addSubview(winddirectionBox)
        
        contentView.snp.makeConstraints { make in 
            make.width.equalToSuperview()
            make.height.equalTo(1000)
        }

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
        
        winddirectionBox.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        
        self.contentView.addSubview(self.backgroundImageView)
        self.contentView.sendSubviewToBack(self.backgroundImageView)
        self.backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
