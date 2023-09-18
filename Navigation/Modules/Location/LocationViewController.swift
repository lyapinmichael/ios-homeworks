//
//  LocationViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 08.09.2023.
//

import UIKit
import MapKit
import CoreLocation

final class LocationViewController: UIViewController {

    // MARK: - Public properties
    
    var viewModel: LocationViewModelProtocol?
    
    // MARK: - Private properties
    
    private var currentUserCoordinate: CLLocationCoordinate2D?
    
    // MARK: - Subviews
    
    private lazy var mapView: MKMapView = {
       let mapView = MKMapView()
        mapView.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
        mapView.addGestureRecognizer(longPressGesture)
        
        let configuration = MKStandardMapConfiguration()
        configuration.showsTraffic = true
    
        mapView.preferredConfiguration = configuration
        
        mapView.showsCompass = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var removePinBarButton: UIBarButtonItem = {
        
        let image = UIImage(systemName: "mappin.slash.circle")
        let action = UIAction { [weak self] _ in
            
            guard let self = self else { return }
            
            let previousAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(previousAnnotations)
            
            let previousOverlays = self.mapView.overlays
            self.mapView.removeOverlays(previousOverlays)
            
        }
        
        let barButtonItem = UIBarButtonItem(image: image, primaryAction: action)
        
        return barButtonItem
    }()
    
    private lazy var centerOnUserLocationBarButton: UIBarButtonItem = {
       
        let image = UIImage(systemName: "location.fill")
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            
            self.viewModel?.updateState(with: .requestLocation)
        }
        
        let barButtonItem = UIBarButtonItem(image: image, primaryAction: action)
        
        barButtonItem.isEnabled = false
        
        return barButtonItem
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("location", comment: "")
    
        setupMapView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItems = [centerOnUserLocationBarButton, removePinBarButton]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        viewModel?.updateState(with: .requestLocationAuthorization)
    }
    
    // MARK: - Private methods
    
    private func setupMapView() {
        
        view.addSubview(mapView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
        
            mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        
        ])
    }
    
    private func bindViewModel() {
        
        viewModel?.onStateDidChange = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .initial(let authorizationStatus, let currentCoordinate):
                if case .authorizedWhenInUse = authorizationStatus {
                    centerOnUserLocationBarButton.isEnabled = true
                }
                
                self.currentUserCoordinate = currentCoordinate
                
            case .didUpdateLocation(let coordinate):
                self.currentUserCoordinate = coordinate
                self.centerMapView(coordinate)
                
            case .didAuthorizeLocationUse:
                mapView.showsUserLocation = true
                mapView.setUserTrackingMode(.follow, animated: true)
                centerOnUserLocationBarButton.isEnabled = true
                
            case .didReceiveRoute(let route):
                DispatchQueue.main.async {
                    self.mapView.addOverlay(route.polyline)
                }
            }
        }
    }
    
    private func centerMapView(_ centerCoordinate: CLLocationCoordinate2D) {
       
        DispatchQueue.main.async {
            let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    // MARK: - Objc methods
    
    @objc private func addPin(_ sender: UILongPressGestureRecognizer) {
        let previousAnnotations = mapView.annotations
        mapView.removeAnnotations(previousAnnotations)
        
        let previousOverlays = mapView.overlays
        mapView.removeOverlays(previousOverlays)
        
        let pinPoint = sender.location(in: mapView)
        let coordinate = mapView.convert(pinPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        viewModel?.updateState(with: .requestRouteTo(coordinate))
    }
}

extension LocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        
        return renderer
    }
}
