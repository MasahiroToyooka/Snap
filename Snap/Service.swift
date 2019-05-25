//
//  Service.swift
//  Snap
//
//  Created by 豊岡正紘 on 2019/05/12.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import Foundation
import CoreLocation

let client_id = "YOUR_client_id"
let client_secret = "YOUR_client_secret"

class Service {
    
    static let shared = Service()
    
    func fetchCoffee(location: CLLocationCoordinate2D, completion: @escaping (Empty?, Error?) -> ()) {

        let urlString = "https://api.foursquare.com/v2/search/recommendations?ll=\(location.latitude),\(location.longitude)&intent=coffee&limit=10&client_id=\(client_id)&client_secret=\(client_secret)&v=20190514"
        
        print(urlString)
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    
    func fetchGenericJSONData<T: Codable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data!)
                // success
                completion(objects, nil)
            } catch {
                completion(nil, error)
            }
            }.resume()
    }
}
