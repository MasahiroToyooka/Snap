//
//  ViewController.swift
//  Snap
//
//  Created by 豊岡正紘 on 2019/05/10.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SDWebImage

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {

    private let cellId = "cellId"
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        collectionView.backgroundColor = UIColor.rgb(red: 203, green: 203, blue: 203)

        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        collectionView.register(VenueCell.self, forCellWithReuseIdentifier: cellId)
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed))
//        longPressRecognizer.delegate = self
        collectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func cellLongPressed(gesture: UILongPressGestureRecognizer) {
        
        let point = gesture.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        
//        guard indexPath != nil else { return }
        
        if gesture.state == .ended {
//            print("\(indexPath)番目のセルや！！")

            let location = results[(indexPath?.item)!].venue.location.address
            print(location)
            
            let mapItem = mapItems[(indexPath?.item)!]
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedWhenInUse {
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        animateCollectionView()
    }
    
    var results = [Result]()
    var mapItems = [MKMapItem]()
    
    func fetchData() {
        Service.shared.fetchCoffee(location: currentLocation) { (empty, err) in
            if let err = err {
                print("なんでやねん", err)
                return
            }
            self.results = empty?.response.group.results ?? []
            
            let mapItems = empty?.response.group.results.map({ (result) -> MKMapItem in
                let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: result.venue.location.lat, longitude: result.venue.location.lng))
                let mapItem = MKMapItem(placemark: placemark)
                return mapItem
            })
            self.mapItems = mapItems ?? []
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation != nil{
            return
        }
        currentLocation = locations.last?.coordinate
        fetchData()
//        if locations.last?.timestamp.timeIntervalSinceNow < 30 || locations.last?.horizontalAccuracy > 80 {
//            return
//        }
    }
    
    func getCurrentLocation() {
        print(3)
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
        
            case .authorizedWhenInUse:
                locationManager.stopUpdatingLocation()
            
            default:
                showLocationAlert()
            }
        } else {
                showLocationAlert()
        }
    }
    
    func showLocationAlert() {
        let alert = UIAlertController(title: "位置情報を取得できませんでした", message: "「設定」「プライバシー」「位置情報サービス」から許可してください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    var animationPerformedOnce = false
    func animateCollectionView() {
        print(123)
        if !animationPerformedOnce {
            print(987)
            let cells = collectionView.visibleCells
            //        let collectionViewWidth = collectionView.bounds.size.width
            
            for cell in cells {
                cell.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
            }
            var delayCounter = 0
            
            for cell in cells {
                UIView.animate(withDuration: 1, delay: Double(delayCounter)  * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    cell.transform = .identity
                    print(5)
                }, completion: nil)
                delayCounter += 1
                animationPerformedOnce = true
            }
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VenueCell
        let result = results[indexPath.item]
        cell.venueName.text = result.venue.name
        cell.foodImage.sd_setImage(with: URL(string: result.photo.photoPrefix + "100x100" + result.photo.suffix), placeholderImage: #imageLiteral(resourceName: "loading"), options: .delayPlaceholder, completed: nil)
        cell.distanceLabel.text = "ここから\(result.venue.location.distance)M"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let location = results[indexPath.item].venue.location.address
        print(location)

        let mapItem = mapItems[indexPath.item]
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width-64, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}

