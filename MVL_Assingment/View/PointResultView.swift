//
//  SettedPointInfoView.swift
//  MVL_Assingment
//
//  Created by SEONGJUN on 2020/11/23.
//

import UIKit
import Then

final class PointResultView: UIView {
    
    let aPointTitleLabel = UILabel().then {
        $0.text = "Point A"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = #colorLiteral(red: 0.2197080255, green: 0.2173088193, blue: 0.9980503917, alpha: 1)
        $0.backgroundColor = .white
    }
    
    let aPointDetailLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.backgroundColor = .white
    }
    
    let bPointTitleLabel = UILabel().then {
        $0.text = "Point B"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = #colorLiteral(red: 0.2197080255, green: 0.2173088193, blue: 0.9980503917, alpha: 1)
        $0.backgroundColor = .white
    }
    
    let bPointDetailLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.backgroundColor = .white
    }
    
    let backButton = UIButton().then {
        $0.setTitle("Back", for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.2197080255, green: 0.2173088193, blue: 0.9980503917, alpha: 1)
        $0.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 23)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.backgroundColor = .darkGray
        
        addSubview(aPointTitleLabel)
        aPointTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.leading.equalToSuperview().inset(50)
            $0.width.equalTo(150)
            $0.height.equalTo(44)
        }
        
        addSubview(aPointDetailLabel)
        aPointDetailLabel.snp.makeConstraints {
            $0.top.equalTo(aPointTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(150)
        }
        
        addSubview(bPointTitleLabel)
        bPointTitleLabel.snp.makeConstraints {
            $0.top.equalTo(aPointDetailLabel.snp.bottom).offset(50)
            $0.leading.equalToSuperview().inset(50)
            $0.width.equalTo(150)
            $0.height.equalTo(44)
        }
        
        addSubview(bPointDetailLabel)
        bPointDetailLabel.snp.makeConstraints {
            $0.top.equalTo(bPointTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(150)
        }
        
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
}
