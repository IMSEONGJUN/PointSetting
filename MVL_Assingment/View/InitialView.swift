//
//  InitialView.swift
//  MVL_Assingment
//
//  Created by SEONGJUN on 2020/11/23.
//

import UIKit
import GoogleMaps
import SnapKit
import Then

final class InitialView: UIView {
    
    let aPointLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.numberOfLines = 3
        $0.minimumScaleFactor = 0.5
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    
    let bPointLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.numberOfLines = 3
        $0.minimumScaleFactor = 0.5
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    
    let aPointSetButton = UIButton().then {
        $0.setTitle("Set A", for: .normal)
        $0.backgroundColor = .blue
    }
    
    let bPointSetButton = UIButton().then {
        $0.setTitle("Set B", for: .normal)
        $0.backgroundColor = .blue
    }
    
    let clearButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setTitle("Clear", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        $0.backgroundColor = #colorLiteral(red: 0.9798753858, green: 0.8809804916, blue: 0.004552591592, alpha: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        let aPointStack = UIStackView(arrangedSubviews: [aPointLabel, aPointSetButton])
        let bPointStack = UIStackView(arrangedSubviews: [bPointLabel, bPointSetButton])
        let pointsStack = UIStackView(arrangedSubviews: [aPointStack, bPointStack, clearButton])
        
        [aPointStack, bPointStack].forEach{
            $0.spacing = 10
        }
        
        [aPointSetButton, bPointSetButton].forEach{
            $0.snp.makeConstraints {
                $0.width.equalTo(100)
            }
        }
        
        addSubview(pointsStack)
        pointsStack.axis = .vertical
        pointsStack.distribution = .fillEqually
        pointsStack.spacing = 30
        pointsStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(210)
        }
    }
    
}

