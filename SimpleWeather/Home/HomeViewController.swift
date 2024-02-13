//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Seryun Chun on 2024/02/10.
//

import UIKit
import SnapKit
import Kingfisher

class HomeViewController: UIViewController {
    
    var foreCastList: [ForeCast] = []
    
    // MARK: - UI Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 위치"
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    let titleCityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 72)
        label.textAlignment = .center
        return label
    }()
    
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    let maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    let minTempLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    lazy var tempStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [maxTempLabel, minTempLabel])
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .color)
        
        getData()
        configureTableView()
        render()
    }
}

// MARK: - Networking

extension HomeViewController {
    private func getData() {
        // SEOUL Code: 1835847
        // JEJU  Code: 1846266
        let group = DispatchGroup()
    
        group.enter()
        DispatchQueue.global().async {
            fetchCurrentWeather(cityID: 1835847) { currentModel in
                
                // [ 현재 날씨를 구성 ] : 첫 진입 시 서울을 기준으로 모든 데이터를 구성
                
                // 도시 이름
                self.titleCityLabel.text = currentModel.name
                
                // 현재 기온
                self.tempLabel.text = MeasurementFormatter.convertTemperature(currentModel.main.temp)
                
                // 날씨 표시
                self.weatherLabel.text = currentModel.weather.first?.description
                
                // 최고 최저 온도
                self.minTempLabel.text = MeasurementFormatter.convertTemperature(currentModel.main.temp_min)
                self.maxTempLabel.text = MeasurementFormatter.convertTemperature(currentModel.main.temp_max)
                
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async {
            fetchForecast(cityID: 1835847) { list in
                self.foreCastList = list
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableView Delegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            // [1] 3시간 간격 일기 예보
        case HomeSection.timeForeCast.rawValue:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TimeForeCastTableViewCell.identifier,
                for: indexPath) as? TimeForeCastTableViewCell else { return UITableViewCell() }
            
            cell.backgroundColor = .systemGray
            
            // 셀 안에 컬렉션 뷰에 태그 설정
            cell.timeCollectionView.tag = indexPath.row
            
            cell.timeCollectionView.dataSource = self
            cell.timeCollectionView.delegate = self
            cell.timeCollectionView.register(
                TimeForeCastCollectionViewCell.self,
                forCellWithReuseIdentifier: TimeForeCastCollectionViewCell.identifier)
            
            cell.timeCollectionView.reloadData()
            
            return cell
            
            // [2] 5일 주간 예보
        case HomeSection.weeklyForeCast.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeeklyForeCastTableViewCell.identifier, for: indexPath) as? WeeklyForeCastTableViewCell else { return UITableViewCell() }
            
            cell.backgroundColor = .systemGray2
            
            // 셀 안 컬렉션 뷰에 태그 설정
            cell.weekCollectionView.tag = indexPath.row
            
            // 셀 안 컬렉션 뷰에 delegate 설정
            cell.weekCollectionView.dataSource = self
            cell.weekCollectionView.delegate = self
            cell.weekCollectionView.register(WeekForeCastCollectionViewCell.self, forCellWithReuseIdentifier: WeekForeCastCollectionViewCell.identifier)
            
            cell.weekCollectionView.reloadData()
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

// MARK: - UITableView Configuration Method

extension HomeViewController {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            TimeForeCastTableViewCell.self,
            forCellReuseIdentifier: TimeForeCastTableViewCell.identifier)
        tableView.register(WeeklyForeCastTableViewCell.self, forCellReuseIdentifier: WeeklyForeCastTableViewCell.identifier)
    }
}

// MARK: - UICollectionView Delegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case HomeSection.timeForeCast.rawValue:
            return foreCastList.count
        case HomeSection.weeklyForeCast.rawValue:
            return foreCastList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case HomeSection.timeForeCast.rawValue:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TimeForeCastCollectionViewCell.identifier,
                for: indexPath) as? TimeForeCastCollectionViewCell else { return UICollectionViewCell() }
            
            let dt = Date(timeIntervalSince1970: TimeInterval(foreCastList[indexPath.item].dt))
            cell.timeLabel.text = DateFormatter.convertTime(dt)
            
            let iconName = foreCastList[indexPath.item].weather.first!.icon
            if let urlString = URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png") {
                cell.weatherImageView.kf.setImage(with: urlString)
            }
            
            cell.tempLabel.text = MeasurementFormatter.convertTemperature(foreCastList[indexPath.item].main.temp)
            
            return cell
            
        case HomeSection.weeklyForeCast.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekForeCastCollectionViewCell.identifier, for: indexPath) as? WeekForeCastCollectionViewCell else { return UICollectionViewCell() }
            
            // 요일
            let dtString = foreCastList[indexPath.item].dt_txt
            cell.dayLabel.text = DateFormatter.convertDay(dtString)
            
            // 아이콘 이미지
            let iconName = foreCastList[indexPath.item].weather[0].icon
            if let urlString = URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png") {
                cell.iconImageView.kf.setImage(with: urlString)
            }
            
            // 최저 최고 온도
            cell.minTempLabel.text = MeasurementFormatter.convertTemperature(foreCastList[indexPath.item].main.temp_min)
            cell.maxTempLabel.text = MeasurementFormatter.convertTemperature(foreCastList[indexPath.item].main.temp_max)
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
  
    }
}

// MARK: - UI Configuration Method

extension HomeViewController {
    private func render() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(22)
        }
        
        view.addSubview(titleCityLabel)
        titleCityLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(14)
        }
        
        view.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(titleCityLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(72)
        }
        
        view.addSubview(weatherLabel)
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(10)
            make.centerX.equalTo(titleCityLabel)
            make.height.equalTo(20)
        }
        
        view.addSubview(tempStackView)
        tempStackView.snp.makeConstraints { make in
            make.top.equalTo(weatherLabel.snp.bottom).offset(8)
            make.centerX.equalTo(weatherLabel)
            make.height.equalTo(20)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tempStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

