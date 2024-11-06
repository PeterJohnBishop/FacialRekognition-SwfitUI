//
//  ImagePickerViewModel.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/6/24.
//

import Foundation
import Observation
import PhotosUI
import _PhotosUI_SwiftUI

@Observable class ImagePickerViewModel {
    var selectedItems: [PhotosPickerItem] = []
    var images: [UIImage] = []
    var imageURLs: [String] = []
    var videoURL: URL?
    var isUploading: Bool = false
    var showImagePicker: Bool = true
    
    func loadMedia(from items: [PhotosPickerItem]) async {
        for item in items {
            // Load the media as either Data (for images) or URL (for video)
            if let imageData = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: imageData) {
                images.append(image)
            } else if let videoURL = try? await item.loadTransferable(type: URL.self) {
                // Load video URL
                self.videoURL = videoURL
            }
        }
    }
    
}
