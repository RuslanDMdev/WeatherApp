//
//  BoxViewCell.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 24.03.2023.
//

import UIKit
import SnapKit

class BoxViewCell: UITableViewCell {
    
    func configure(with info: CardBoxItemInfo){
        boxNameLabel.text = info.boxName
        numLabel.text = info.boxValue
        descriptionLabel.text = info.boxDescription
        
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private constants
    
    private enum UIConstants {
        static let boxSize: CGFloat = UIScreen.main.bounds.width / 2 - 25
//        static let boxSize: CGFloat = 150

        
    }

    
}
// MARK: - Private properties
    private let squareOfBox: UIView = {
        let view  = UIView()
        return view
    }()

    private let boxNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ветер"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let numLabel: UILabel = {
        let label = UILabel()
        label.text = "25м/с"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Северо-западный"
        label.font = UIFont.systemFont(ofSize: 8)
        label.numberOfLines = 4
        return label
    }()
    
// MARK: - Private methods

private extension BoxViewCell{
    func initialize(){
        addSubview(squareOfBox)
        squareOfBox.addSubview(boxNameLabel)
        squareOfBox.addSubview(numLabel)
        squareOfBox.addSubview(descriptionLabel)
        
        squareOfBox.layer.cornerRadius = 15
        squareOfBox.backgroundColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 0.2496832033)
        squareOfBox.snp.makeConstraints { make in
            make.width.height.equalTo(UIConstants.boxSize)
        }
        
        boxNameLabel.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(10)
        }
        
        numLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(UIConstants.boxSize - 10)
            make.left.equalTo(5)
            make.bottom.equalTo(squareOfBox.snp.bottom).inset(10)
        }
        
    }
}
