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
    
    func extractFileName(from urlString: String) -> String {
        let prefix = "https://solidcarnivals3rekog.s3.us-east-1.amazonaws.com/uploads/"
        
        if urlString.hasPrefix(prefix) {
            return String(urlString.dropFirst(prefix.count))
        } else {
            return urlString
        }
    }
    
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
    
    func compareWithAWSRekognition(source: String, target: String) async -> Bool {
        
        let sourceImageName = extractFileName(from: source)
        let targetImageName = extractFileName(from: target)
        
        guard let url = URL(string: "http://192.168.0.158:4000/rekognition/compare_faces_s3") else { return false }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "source": sourceImageName,
            "target": targetImageName
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("An error occured preparing the request to logout!")
            return false
        }
        
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the JSON response to get the uid
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                    return true
                } else {
                    return false
                }
                   
            } else {
                DispatchQueue.main.async {
                   print("Error authenticating user: \(response)")
                }
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }


}
