//
//  PointInfo.swift
//  MVL_Assingment
//
//  Created by SEONGJUN on 2020/11/23.
//

import Foundation
import MapKit

// MARK: - Point Information
struct PointInfo {
    let coordinate: CLLocationCoordinate2D
    let address: String
    let air: String
}


// MARK: - LocationData
struct LocationData: Codable {
    let localityInfo: LocalityInfo
}

struct LocalityInfo: Codable {
    let administrative: [Administrative]
}

struct Administrative: Codable, Comparable {
    let order: Int
    let name: String
    
    static func < (lhs: Administrative, rhs: Administrative) -> Bool {
        return lhs.order < rhs.order
    }
}
