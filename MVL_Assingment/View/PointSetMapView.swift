//
//  PointSetMapView.swift
//  MVL_Assingment
//
//  Created by SEONGJUN on 2020/11/23.
//

import UIKit
import GoogleMaps
import Then
import RxSwift
import RxCocoa

final class PointSetMapView: UIView {

    private let mapView = GMSMapView()
    private let manager = CLLocationManager()
    
    let didUpdateLocation = PublishRelay<CLLocationCoordinate2D>()
    
    let pointInfoLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    let pointSetButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = #colorLiteral(red: 0.9798753858, green: 0.8809804916, blue: 0.004552591592, alpha: 1)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureLocationManager()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLocationManager() {
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func configureUI() {
        self.addSubview(mapView)
        mapView.delegate = self
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        let marker = UIImageView(image: UIImage(named: "marker"))
        marker.contentMode = .scaleAspectFill
        mapView.addSubview(marker)
        marker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(44)
            $0.centerY.equalToSuperview().offset(-22)
        }
        
        mapView.addSubview(pointInfoLabel)
        pointInfoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(marker.snp.top).offset(-5)
            $0.width.equalTo(210)
            $0.height.equalTo(40)
        }
        
        mapView.addSubview(pointSetButton)
        pointSetButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(80)
            $0.leading.trailing.equalToSuperview().inset(80)
            $0.height.equalTo(50)
        }
    }
}

extension PointSetMapView: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.pointInfoLabel.isHidden = true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.pointInfoLabel.isHidden = false
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.didUpdateLocation.accept(coordinate)
    }
}

extension PointSetMapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude:location.coordinate.longitude, zoom:14)
        mapView.animate(to: camera)
        manager.stopUpdatingLocation()
    }
}
