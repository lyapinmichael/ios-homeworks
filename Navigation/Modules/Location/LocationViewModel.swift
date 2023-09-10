//
//  LocationViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 08.09.2023.
//

import Foundation
import CoreLocation
import MapKit

protocol LocationViewModelProtocol: ViewModelProtocol {
    
    var onStateDidChange: ((LocationViewModel.State) -> Void)? { get set }

    func updateState(with input: LocationViewModel.ViewInput)
}

final class LocationViewModel: NSObject, LocationViewModelProtocol {
    
    // MARK: - Enums
    
    enum State {
        case initial(CLAuthorizationStatus, CLLocationCoordinate2D?)
        case didUpdateLocation(CLLocationCoordinate2D)
        case didAuthorizeLocationUse
        case didReceiveRoute(MKRoute)
    }
    
    enum ViewInput {
        case requestLocation
        case requestLocationAuthorization
        case requestRouteTo(CLLocationCoordinate2D)
    }
    
    // MARK: - Public properties
    
    private(set) var state: State {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    weak var coordinator: LocationCoordinator?
    
    // MARK: - Private properties
    
    private var locationManager = CLLocationManager()
    
    // MARK: - Init
    
    override init() {
        
        
        let authorizationStatus = locationManager.authorizationStatus
        let currentLocationCoordinate = locationManager.location?.coordinate
        
        state = .initial(authorizationStatus, currentLocationCoordinate)
        
        
        super.init()
        
        locationManager.delegate = self
    
    }
    
    // MARK: - Public methods
    
    func updateState(with input: ViewInput) {
        switch input {
        case .requestLocation:
            guard let coordinate = locationManager.location?.coordinate else { return }
            state = .didUpdateLocation(coordinate)
            
        case .requestLocationAuthorization:
            requestLocationAuthorization()
            
        case .requestRouteTo(let destinationCoordinate):
            requesRouteTo(destinationCoordinate)
        }
    }

    // MARK: - Private methods
    
    private func requestLocationAuthorization() {
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            state = .didAuthorizeLocationUse
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
            
            
        default:
            break
        }
    }
    
    private func requesRouteTo(_ destinationCoordinate: CLLocationCoordinate2D) {
        
        guard let sourceCoordinate = locationManager.location?.coordinate else { return }
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let directionRequest = MKDirections.Request()
        directionRequest.transportType = .automobile
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error in
            
            if let error {
                print(error)
            }
            
            guard let route = response?.routes.first else { return }
            
            self?.state = .didReceiveRoute(route)
        }
        
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if case .authorizedWhenInUse = manager.authorizationStatus {
            
            state = .didAuthorizeLocationUse
            manager.startUpdatingLocation()
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = manager.location else { return }
        state = .didUpdateLocation(currentLocation.coordinate)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
