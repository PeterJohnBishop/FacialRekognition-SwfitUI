//
//  RekognitionViewModel.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/3/24.
//

import Foundation
import Observation
import UIKit

@Observable class RekognitionViewModel {
    var faceDetails: [FaceDetail]?
    
    func analyzeImageWithAWSRekognition(image: UIImage) {
        guard let url = URL(string: "http://192.168.0.158:4000/rekognition/face_local") else { return }
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

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:", jsonString)
            }
            
            let decoder = JSONDecoder()
            do {
                let rekognitionResponse = try decoder.decode(RekognitionResponse.self, from: data)
                DispatchQueue.main.async {
                    self.faceDetails = rekognitionResponse.faceDetails
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
        
    }
    
    func analyzeImagesWithAWSRekognition(images: [UIImage]) {
        guard let url = URL(string: "http://192.168.0.158:4000/rekognition/faces_local") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        for (index, image) in images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\(index)\"; filename=\"image\(index).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
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

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:", jsonString)
            }
            
            let decoder = JSONDecoder()
            do {
                let rekognitionResponse = try decoder.decode([RekognitionResponse].self, from: data) // Decoding as array
                DispatchQueue.main.async {
                    self.faceDetails = rekognitionResponse.flatMap { $0.faceDetails } // Flatten all face details
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }

}
