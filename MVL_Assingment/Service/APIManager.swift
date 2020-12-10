//
//  APIManager.swift
//  MVL_Assingment
//
//  Created by SEONGJUN on 2020/11/24.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import MapKit
import SwiftyJSON
import SwiftyLRUCache

final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    let airQualityPlatformToken = "325bdc66f0bf0489499c1d2e232fdf304f5de046"
    let addressCache = SwiftyLRUCache<String, String>(capacity: 30)
    let airQualityCache = SwiftyLRUCache<String, String>(capacity: 30)
 
    
    func fetchAddressUsingCoordinate(coordinate: CLLocationCoordinate2D) -> Observable<String> {
        let reverseGeocodeEndPoint = "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=\(coordinate.latitude)&longitude=\(coordinate.longitude)&localityLanguage=ko"
        
        let key = "\(coordinate.latitude)\(coordinate.longitude)"
        
        if let address = addressCache.getValue(forKey: key) {
            return .just(address)
        }
        
        return Observable.create { (observer) -> Disposable in
            AF.request(reverseGeocodeEndPoint)
              .responseDecodable(of: LocationData.self) { [weak self] response in
                    switch response.result {
                    case .success(let locationData):
                        var admin = locationData.localityInfo.administrative.sorted()
                        let secondText = admin.popLast()?.name ?? ""
                        let firstText = admin.popLast()?.name ?? ""
                        let address = firstText + ", " + secondText
                        self?.addressCache.setValue(value: address, forKey: key)
                        observer.onNext(address)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchAirQualityInfo(coordinate: CLLocationCoordinate2D) -> Observable<String> {
        let endPoint = "https://api.waqi.info/feed/geo:\(coordinate.latitude);\(coordinate.longitude)/?token=\(airQualityPlatformToken)"
        
        let key = "\(coordinate.latitude)\(coordinate.longitude)"
        
        if let aqi = airQualityCache.getValue(forKey: key) {
            return .just(aqi)
        }
        
        return Observable.create { (observer) -> Disposable in
            AF.request(endPoint)
              .responseJSON { [weak self] response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let data = json["data"]
                        let aqi = data["aqi"].intValue
                        let result = String(aqi)
                        self?.airQualityCache.setValue(value: result, forKey: key)
                        observer.onNext(result)
                        observer.onCompleted()
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
