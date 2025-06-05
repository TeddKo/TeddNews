//
//  Extension.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/6/25.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL string.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Error: No data or could not create image.")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
