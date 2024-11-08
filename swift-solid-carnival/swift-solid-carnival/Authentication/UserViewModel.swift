//
//  UserModel.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/3/24.
//

import Foundation
import Observation
import CryptoKit

@Observable class UserViewModel {
    var user: UserModel = UserModel()
    var users: [UserModel] = []
    var userData: UserData = UserData()
    var usersData: [UserData] = []
    var baseURL: String = "http://192.168.0.158:4000/"
    var error: String = ""
    
    func createNewUser() async -> Bool {

        guard let url = URL(string: "\(baseURL)authentication/create") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": user.email,
            "password": user.password!,
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return false
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Decode the JSON response to get the uid
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let uid = json["uid"] as? String {
                    DispatchQueue.main.async {
                        self.user.uid = uid
                    }
                    print("User authenticated with UID: \(uid)")
                    return true
                } else {
                    print("UID not found in response")
                    return false
                }
            } else {
                DispatchQueue.main.async {
                    self.error = "Error authenticating user: \(response)"
                }
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }
    
    func authenticateUser() async -> Bool {
        
        guard let url = URL(string: "\(baseURL)authentication/login") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": user.email,
            "password": user.password!,
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return false
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Decode the JSON response to get the uid
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let uid = json["uid"] as? String {
                    DispatchQueue.main.async {
                        self.user.uid = uid
                    }
                    print("User authenticated with UID: \(uid)")
                    return true
                } else {
                    print("UID not found in response")
                    return false
                }
            } else {
                DispatchQueue.main.async {
                    self.error = "Error authenticating user: \(response)"
                }
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }
    
    func getCurrentUser() async -> Bool {
        guard let url = URL(string: "\(baseURL)authentication/current_user") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the JSON response into UserModel
                let decoder = JSONDecoder()
                do {
                    let user = try decoder.decode(UserModel.self, from: data)
                    DispatchQueue.main.async {
                        self.user = user
                    }
                    print("Current authenticated user UID: \(user.uid ?? "N/A")")
                    return true
                } catch {
                    print("Error decoding response: \(error)")
                    return false
                }
            } else {
                print("Return user to login/registration.")
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }
    
    func logoutUser() async -> Bool {
        
        guard let url = URL(string: "\(baseURL)authentication/logout") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "uid": user.uid ?? "",
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("An error occured preparing the request to logout!")
            return false
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("The current authenticated user has successfully been logged out.")
                return true
            } else {
                print("An error occured while trying to logout!")
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }
    
    //Firestore User Documents
    
    func saveUserData() async -> Bool {
        
        guard let url = URL(string: "\(baseURL)users/create/\(user.uid ?? "UID_error")") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "displayName": userData.displayName,
            "email": userData.email,
            "profileImg": userData.profileImg
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return false
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the JSON response to get the uid
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let uid = json["uid"] as? String {
                    DispatchQueue.main.async {
                        self.user.uid = uid
                    }
                    print("User authenticated with UID: \(uid)")
                    return true
                } else {
                    print("UID not found in response")
                    return false
                }
            } else {
                DispatchQueue.main.async {
                    self.error = "Error authenticating user: \(response)"
                }
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }
    
    func getUserData() async -> Bool {
        
        guard let url = URL(string: "\(baseURL)users/read_one/\(user.uid ?? "UID_error")") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the JSON response to get the uid
                let decoder = JSONDecoder()
                do {
                    let user = try decoder.decode(UserData.self, from: data)
                    DispatchQueue.main.async {
                        self.userData = user
                    }
                    print("Found user: \(user.displayName)")
                    return true
                } catch {
                    print("Error decoding response: \(error)")
                    return false
                }
            } else {
                DispatchQueue.main.async {
                    self.error = "Error authenticating user: \(response)"
                }
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }

}


