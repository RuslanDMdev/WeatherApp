//
//  ThirdViewController.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 14.03.2023.
//


import UIKit
import SnapKit

class ThirdViewController: UIViewController {
    
    // MARK: - Private properties
        
    private var backgroundImageView = UIImageView()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
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
    
    private let decodingTheWeatherLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 18, weight: .regular)
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
    

    
    private let boxHumidity = BoxView()
    
    private let boxPressure = BoxView()

    private let boxFeels_like = BoxView()
    
    private let boxWind = BoxView()
    
    private let searchTextField: UITextField = {
       let textField = UITextField()
        textField.text = "Madrid"
        return textField
    }()
    
    private let getWeatherButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitle("Обновить погоду", for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    var latitudeCity = "45"
    var longitudeCity = "34"
    
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        getCityName()

    }
    
    var secondApiUrl: String = ""

    @objc func buttonTapped(){
        backgroundImageView.image = UIImage(named: "")
        getCityName()
        searchTextField.text = ""

    }
 
    func getCityName(){
        
        let cityName = searchTextField.text!
        let geoApiUrl = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=5&appid=292842ad3a54adb663034679ab2a5816"
        cityLabel.text = cityName
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
                            self.secondApiUrl = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_max,temperature_2m_min&current_weather=true&forecast_days=1&timezone=Europe%2FMoscow"

                        
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
    
    func getWeather(){
        
        let url = URL(string: secondApiUrl)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    self.weatherLabel.text = "\(weather.currentWeather.temperature)°"
                    
                    self.maxTemperatureLabel.text = "\(weather.daily.temperature2MMax)"
                    let tempHigh = String(self.maxTemperatureLabel.text!.dropFirst().dropLast())
                    self.maxTemperatureLabel.text = "H:\(tempHigh)"
                    
                    self.minTemperatureLabel.text = "\(weather.daily.temperature2MMin)"
                    let tempLow = String(self.minTemperatureLabel.text!.dropFirst().dropLast())
                    self.minTemperatureLabel.text = "L:\(tempLow)"

                    
                    let icon = IconWithString(date: weather.currentWeather.weathercode)
                    let image = icon.getImageForWeatherCode(weather.currentWeather.weathercode)
                    self.weatherImageView.image = UIImage(named: image)
                    
                    let decodWeatherCode = DecodingTheWeatherString(date: weather.currentWeather.weathercode)
                    let textDecode = decodWeatherCode.getTextFromWeatherCode(weather.currentWeather.weathercode)
                    self.decodingTheWeatherLabel.text = textDecode
                    
                    let imageWeatherCode = DataBackgraundImage(date: weather.currentWeather.weathercode)
                    let imageBackgraundString = imageWeatherCode.getBGImageFromWeatherCode(weather.currentWeather.weathercode)
                    print(imageBackgraundString)
                    let imageBackgraund = UIImage(named: imageBackgraundString)
                    self.backgroundImageView = UIImageView(image: imageBackgraund)
                    print(self.backgroundImageView)
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

// MARK: - Private methods

private extension ThirdViewController{
    func initialize(){
        let scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1200)

        scrollView.addSubview(searchTextField)
        scrollView.addSubview(weatherImageView)
        scrollView.addSubview(decodingTheWeatherLabel)
        scrollView.addSubview(weatherLabel)
        scrollView.addSubview(cityLabel)
        scrollView.addSubview(getWeatherButton)
        let temperatureStack = UIStackView()
        scrollView.addSubview(temperatureStack)
        scrollView.addSubview(boxHumidity)
        scrollView.addSubview(boxPressure)
        scrollView.addSubview(boxFeels_like)
        scrollView.addSubview(boxWind)

        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        

        searchTextField.layer.borderWidth = 1
        searchTextField.placeholder = "Поиск"
        searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
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
        
        temperatureStack.addArrangedSubview(minTemperatureLabel)
        temperatureStack.addArrangedSubview(maxTemperatureLabel)
        temperatureStack.spacing = 5
        temperatureStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weatherLabel.snp.bottom).offset(10)
        }

        boxHumidity.setLabels(title: "000", value: "000", info: "000")
        boxPressure.setLabels(title: "111", value: "111", info: "111")
        
        boxHumidity.snp.makeConstraints { make in
//            make.left.equalToSuperview().inset(20)
            make.top.equalTo(temperatureStack.snp.bottom).offset(30)
        }
        
        boxPressure.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(temperatureStack.snp.bottom).offset(30)
        }
        
        boxFeels_like.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(boxHumidity.snp.bottom).offset(10)
        }
        
        boxWind.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(boxPressure.snp.bottom).offset(10)
        }
        
        getWeatherButton.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1882352941, alpha: 0.404318399)
        getWeatherButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(boxWind.snp.bottom).offset(120)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
    }
}

