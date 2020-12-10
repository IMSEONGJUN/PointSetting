//
//  PointSetViewModel.swift
//  MVL_Assingment
//
//  Created by SEONGJUN on 2020/11/22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

enum Points {
    case PointA
    case PointB
    
    var text: String {
        switch self {
        case .PointA:
            return "A"
        case .PointB:
            return "B"
        }
    }
}

struct PointSetViewModel: PointSetViewBindable {
    
    // Input
    let didTapSetA = PublishRelay<Void>()
    let didTapSetB = PublishRelay<Void>()
    let didTapClear = PublishRelay<Void>()
    let didEndChangeLocation = PublishRelay<CLLocationCoordinate2D>()
    let didTapSETButton = PublishRelay<Void>()
    let didTapBackButton = PublishRelay<Void>()
    
    // Output
    let pointA: Driver<PointInfo?>
    let pointB: Driver<PointInfo?>
    let currentPoint: Driver<PointInfo>
    let canGoToResultView: Signal<Bool>
    let pointNeedToSet = PublishRelay<Points>()
    
    var disposeBag = DisposeBag()
    
    init(_ model: APIManager = .shared) {
        
        // Proxy
        let pointAProxy = PublishRelay<PointInfo?>()
        pointA = pointAProxy.asDriverOnErrorJustComplete()
        
        let pointBProxy = PublishRelay<PointInfo?>()
        pointB = pointBProxy.asDriverOnErrorJustComplete()
        
        let currentPointProxy = PublishRelay<PointInfo>()
        currentPoint = currentPointProxy.asDriverOnErrorJustComplete()

        // Helper
        let isASetted = BehaviorRelay<Bool>(value: false)
        let isBSetted = BehaviorRelay<Bool>(value: false)
        
        
        // MARK: - Input: User action from View -> Output: State to View
        
        // Tap Set A or B on InitialView
        didTapSetA
            .map{ Points.PointA }
            .bind(to: pointNeedToSet)
            .disposed(by: disposeBag)
        
        didTapSetB
            .map{ Points.PointB }
            .bind(to: pointNeedToSet)
            .disposed(by: disposeBag)
        
        
        // Fetch Point Information every time location update on MapView
        let newLocationIncoming = didEndChangeLocation.share()
        
        let address = newLocationIncoming
            .flatMapLatest(model.fetchAddressUsingCoordinate(coordinate:))
            .retry(2)
        
        let airQuality = newLocationIncoming
            .flatMapLatest(model.fetchAirQualityInfo(coordinate:))
            .retry(2)
        
        Observable
            .zip(
                newLocationIncoming,
                address,
                airQuality
            )
            .map{ PointInfo(coordinate: $0, address: $1, air: $2) }
            .bind(to: currentPointProxy)
            .disposed(by: disposeBag)
        
        
        // Tap SET on MapView
        didTapSETButton
            .withLatestFrom(
                Observable.combineLatest(pointNeedToSet, currentPointProxy)
            )
            .subscribe(onNext:{ (pointNeedToSet, currentPointInfo) in
                switch pointNeedToSet {
                case .PointA:
                    pointAProxy.accept(currentPointInfo)
                    isASetted.accept(true)
                case .PointB:
                    pointBProxy.accept(currentPointInfo)
                    isBSetted.accept(true)
                }
            })
            .disposed(by: disposeBag)
            
        canGoToResultView = Observable
            .combineLatest(
                isASetted,
                isBSetted
            ){ $0 && $1 }
            .asSignal(onErrorJustReturn: false)
            
        
        // Tap Clear Button on initialView or Tap Back Button on resultView
        Observable
            .merge(
                didTapClear.asObservable(),
                didTapBackButton.asObservable()
            )
            .subscribe(onNext: {
                pointAProxy.accept(nil)
                pointBProxy.accept(nil)
                isASetted.accept(false)
                isBSetted.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
