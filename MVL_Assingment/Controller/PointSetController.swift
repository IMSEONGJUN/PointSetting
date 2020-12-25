//
//  PointSetController.swift
//  MVL_Assingment
//
//  Created by SEONGJUN on 2020/11/22.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

protocol PointSetViewBindable {
    // Input -> ViewModel
    var didTapSetA: PublishRelay<Void> { get }
    var didTapSetB: PublishRelay<Void> { get }
    var didTapClear: PublishRelay<Void> { get }
    
    var didTapSETButton: PublishRelay<Void> { get }
    var didEndChangeLocation: PublishRelay<CLLocationCoordinate2D> { get }
    var didTapBackButton: PublishRelay<Void> { get }
    
    // ViewModel -> Output
    var pointA: Driver<PointInfo?> { get }
    var pointB: Driver<PointInfo?> { get }
    var currentPoint: Driver<PointInfo> { get }
    var pointNeedToSet: PublishRelay<Points> { get }
    var canGoToResultView: Signal<Bool> { get }
    var needToClearLocationInfoBeforeNewOneIncome: Signal<Void> { get }
}

final class PointSetController: UIViewController {
    
    let initialView = InitialView()
    let pointSetMapView = PointSetMapView()
    let pointResultView = PointResultView()
    
    var viewModel: PointSetViewBindable!
    var disposeBag = DisposeBag()
    
    override func loadView() {
        view = initialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PointSetViewModel()
        bind()
    }
    
    func bind() {
        // Input -> ViewModel
        initialView.aPointSetButton.rx.tap
            .bind(to: viewModel.didTapSetA)
            .disposed(by: disposeBag)
        
        initialView.bPointSetButton.rx.tap
            .bind(to: viewModel.didTapSetB)
            .disposed(by: disposeBag)
        
        initialView.clearButton.rx.tap
            .bind(to: viewModel.didTapClear)
            .disposed(by: disposeBag)
        
        pointSetMapView.didUpdateLocation
            .bind(to: viewModel.didEndChangeLocation)
            .disposed(by: disposeBag)
        
        pointSetMapView.pointSetButton.rx.tap
            .bind(to: viewModel.didTapSETButton)
            .disposed(by: disposeBag)
        
        pointResultView.backButton.rx.tap
            .bind(to: viewModel.didTapBackButton)
            .disposed(by: disposeBag)
        
        // ViewModel -> Output
        viewModel.pointNeedToSet
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.pointSetMapView.pointSetButton.setTitle("SET " + $0.text, for: .normal)
                self.view = self.pointSetMapView
            })
            .disposed(by: disposeBag)
        
        viewModel.currentPoint
            .drive(pointSetMapView.pointInfoLabel.rx.setPointInfo)
            .disposed(by: disposeBag)
            
        viewModel.pointA
            .drive(initialView.aPointLabel.rx.setPointInfo)
            .disposed(by: disposeBag)
        
        viewModel.pointB
            .drive(initialView.bPointLabel.rx.setPointInfo)
            .disposed(by: disposeBag)
        
        viewModel.canGoToResultView
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.view = $0 ? self.pointResultView : self.initialView
            })
            .disposed(by: disposeBag)
        
        viewModel.pointA
            .drive(pointResultView.aPointDetailLabel.rx.setFullPointInfo)
            .disposed(by: disposeBag)
        
        viewModel.pointB
            .drive(pointResultView.bPointDetailLabel.rx.setFullPointInfo)
            .disposed(by: disposeBag)
        
        viewModel.needToClearLocationInfoBeforeNewOneIncome
            .emit(onNext: { [weak self] in
                self?.pointSetMapView.pointInfoLabel.text = ""
            })
            .disposed(by: disposeBag)
    }

}
