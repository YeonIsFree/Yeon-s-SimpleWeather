//
//  WeekForeCastCollectionViewCell.swift
//  SimpleWeather
//
//  Created by Seryun Chun on 2024/02/11.
//

import UIKit

class WeekForeCastCollectionViewCell: UICollectionViewCell {
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.backgroundColor = .systemTeal
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "sun.dust")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemMint
        return imageView
    }()
    
    let minTempLabel: UILabel = {
        let label = UILabel()
        label.text = "-5"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        return label
    }()
    
    let maxTempLabel: UILabel = {
        let label = UILabel()
        label.text = "7"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.backgroundColor = .systemCyan
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayLabel, iconImageView, minTempLabel, maxTempLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
//        contentView.addSubview(dayLabel)
//        dayLabel.snp.makeConstraints { make in
//            make.top.leading.bottom.equalTo(contentView)
//            make.width.equalTo(100)
//        }
//        
//        contentView.addSubview(iconImageView)
//        iconImageView.snp.makeConstraints { make in
//            make.leading.equalTo(dayLabel.snp.trailing).offset(20)
//            make.width.equalTo(100)
//            make.top.bottom.equalTo(contentView)
//        }
//        
//        contentView.addSubview(minTempLabel)
//        minTempLabel.snp.makeConstraints { make in
//            make.leading.equalTo(iconImageView.snp.trailing).offset(20)
//            make.width.equalTo(50)
//            make.top.bottom.equalTo(contentView)
//        }
//        
//        contentView.addSubview(maxTempLabel)
//        maxTempLabel.snp.makeConstraints { make in
//            make.leading.equalTo(minTempLabel.snp.trailing)
//            make.width.equalTo(50)
//            make.top.bottom.equalTo(contentView)
//        }
    }
}
