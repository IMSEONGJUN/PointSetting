//
//  Reactive+Ext.swift
//  MVL_Assingment
//
//  Created by SEONGJUN on 2020/11/25.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    var setPointInfo: Binder<PointInfo?> {
        return Binder(base) { base, info in
            guard let info = info else {
                base.text = ""
                return
            }
            
            let address = info.address
            let aqi = info.air
            base.text = "주소: \(address)\n공기질: \(aqi)"
        }
    }
    
    var setFullPointInfo: Binder<PointInfo?> {
        return Binder(base) { base, info in
            guard let info = info else {
                base.text = ""
                return
            }
            
            let coordinate = info.coordinate
            let address = info.address
            let aqi = info.air
            base.text = "- 위도: \(coordinate.latitude)\n- 경도: \(coordinate.longitude)\n- 주소: \(address)\n- 공기질: \(aqi)"
        }
    }
}

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
}
