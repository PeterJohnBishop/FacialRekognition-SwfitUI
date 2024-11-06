//
//  S3ViewModel.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/4/24.
//

import Foundation
import Observation
import UIKit

@Observable class S3ViewModel {
    var imageUrl: String = ""
    
    func uploadImageToS3(image: UIImage) {
        guard let url = URL(string: "http://192.168.0.158:4000/s3/upload") else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Error: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let url = json["imageUrl"] as? String {
                    print("Parsed JSON response:", json)
                    self.imageUrl = url
                    print(self.imageUrl)
                } else {
                    print("Failed to parse JSON or 'imageUrl' not found.")
                }
            } catch {
                print("Error parsing JSON:", error)
            }
        }.resume()
    }
}
