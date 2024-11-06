//
//  RekognitionFaceDetailModels.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/4/24.
//

import Foundation

struct RekognitionResponse: Codable {
    let metadata: Metadata
    let faceDetails: [FaceDetail]

    private enum CodingKeys: String, CodingKey {
        case metadata = "$metadata"
        case faceDetails = "FaceDetails"
    }
}

struct Metadata: Codable {
    let httpStatusCode: Int
    let requestId: String
    let attempts: Int
    let totalRetryDelay: Int

    private enum CodingKeys: String, CodingKey {
        case httpStatusCode = "httpStatusCode"
        case requestId = "requestId"
        case attempts = "attempts"
        case totalRetryDelay = "totalRetryDelay"
    }
}


struct FaceDetail: Identifiable, Codable {
    let id = UUID()
    let ageRange: AgeRange
    let beard: Beard
    let boundingBox: BoundingBox
    let confidence: Double
    let emotions: [Emotion]
    let eyeDirection: EyeDirection
    let eyeglasses: Eyeglasses
    let eyesOpen: EyesOpen
    let faceOccluded: FaceOccluded
    let gender: Gender
    let landmarks: [Landmark]
    let mouthOpen: MouthOpen
    let mustache: Mustache
    let pose: Pose
    let quality: Quality
    let smile: Smile
    let sunglasses: Sunglasses

    private enum CodingKeys: String, CodingKey {
        case ageRange = "AgeRange"
        case beard = "Beard"
        case boundingBox = "BoundingBox"
        case confidence = "Confidence"
        case emotions = "Emotions"
        case eyeDirection = "EyeDirection"
        case eyeglasses = "Eyeglasses"
        case eyesOpen = "EyesOpen"
        case faceOccluded = "FaceOccluded"
        case gender = "Gender"
        case landmarks = "Landmarks"
        case mouthOpen = "MouthOpen"
        case mustache = "Mustache"
        case pose = "Pose"
        case quality = "Quality"
        case smile = "Smile"
        case sunglasses = "Sunglasses"
    }
}

struct AgeRange: Codable {
    let high: Int
    let low: Int
    
    private enum CodingKeys: String, CodingKey {
        case high = "High"
        case low = "Low"
    }
}

struct Beard: Codable {
    let confidence: Double
    let value: Bool
    
    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case value = "Value"
    }
}

struct BoundingBox: Codable {
    let height: Double
    let left: Double
    let top: Double
    let width: Double
    
    private enum CodingKeys: String, CodingKey {
        case height = "Height"
        case left = "Left"
        case top = "Top"
        case width = "Width"
    }
}

struct Emotion: Identifiable, Codable {
    let id = UUID()
    let confidence: Double
    let type: String

    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case type = "Type"
    }
}

struct EyeDirection: Codable {
    let confidence: Double
    let pitch: Double
    let yaw: Double
    
    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case pitch = "Pitch"
        case yaw = "Yaw"
    }
}

struct Eyeglasses: Codable {
    let confidence: Double
    let value: Bool
    
    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case value = "Value"
    }
}

struct EyesOpen: Codable {
    let confidence: Double
    let value: Bool
    
    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case value = "Value"
    }
}

struct FaceOccluded: Codable {
    let confidence: Double
    let value: Bool
    
    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case value = "Value"
    }
}

struct Gender: Codable {
    let confidence: Double
    let value: String
    
    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case value = "Value"
    }
}

struct Landmark: Identifiable, Codable {
    let id = UUID()
    let type: String
    let x: Double
    let y: Double

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case x = "X"
        case y = "Y"
    }
}

struct MouthOpen: Codable {
    let confidence: Double
    let value: Bool
    
    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case value = "Value"
    }
}

struct Mustache: Codable {
    let confidence: Double
    let value: Bool
    
    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case value = "Value"
    }
}

struct Pose: Codable {
    let pitch: Double
    let roll: Double
    let yaw: Double
    
    private enum CodingKeys: String, CodingKey {
        case pitch = "Pitch"
        case roll = "Roll"
        case yaw = "Yaw"
    }
}

struct Quality: Codable {
    let brightness: Double
    let sharpness: Double

    private enum CodingKeys: String, CodingKey {
        case brightness = "Brightness"
        case sharpness = "Sharpness"
    }
}

struct Smile: Codable {
    let confidence: Double
    let value: Bool
    
    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case value = "Value"
    }
}

struct Sunglasses: Codable {
    let confidence: Double
    let value: Bool
    
    private enum CodingKeys: String, CodingKey {
        case confidence = "Confidence"
        case value = "Value"
    }
}
