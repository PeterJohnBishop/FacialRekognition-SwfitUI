//
//  ImagePickerView.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/6/24.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @Binding var imagePickerViewModel: ImagePickerViewModel
    var uploadType: String = ""

        var body: some View {
            VStack {
                if (imagePickerViewModel.showImagePicker) {
                    Rectangle()
                                .fill(Color.white)
                                .frame(width: 325, height: 325)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                .overlay(
                                    PhotosPicker(
                                        selection: $imagePickerViewModel.selectedItems,
                                        maxSelectionCount: uploadType == "profile" ? 1 : 6,
                                        matching: uploadType == "profile" ? .any(of: [.images]) : .any(of: [.images, .videos]),
                                        photoLibrary: .shared()) {
                                            Image(systemName: "photo.circle.fill").resizable()
                                                .fontWeight(.ultraLight)
                                                .foregroundStyle(.black)
                                                .frame(width: 50, height: 50)
                                        }
                                        .onChange(of: imagePickerViewModel.selectedItems) { oldItems, newItems in

                                            Task {
                                                    await imagePickerViewModel.loadMedia(from: newItems)
                                                }
                                            
                                        }
                                        .onChange(of: imagePickerViewModel.images) {
                                            if !imagePickerViewModel.images.isEmpty {
                                                imagePickerViewModel.showImagePicker = false
                                            }
                                        }
                                )
                }

                if !imagePickerViewModel.images.isEmpty {
                    if(uploadType == "profile") {
                        ForEach(imagePickerViewModel.images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 325, height: 325)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                .onTapGesture {
                                    imagePickerViewModel.selectedItems = []
                                    imagePickerViewModel.images = []
                                    imagePickerViewModel.imageURLs = []
                                    imagePickerViewModel.videoURL = nil
                                    imagePickerViewModel.showImagePicker = true
                                }
                        }
                    } else {
                        ForEach(imagePickerViewModel.images, id: \.self) { image in
                            
                            Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 320, height: 320)
                                        .cornerRadius(20)
                                        .clipped() // Ensures the image doesn't overflow outside the rounded corners
                                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                    }
                }

                if let videoURL = imagePickerViewModel.videoURL {
                    Text("Video Selected: \(imagePickerViewModel.videoURL!.lastPathComponent)")
                    //needs player
                }
                
                if (!imagePickerViewModel.showImagePicker) {
                    HStack{
                        Spacer()
                        Button(action: {
                            imagePickerViewModel.selectedItems = []
                            imagePickerViewModel.images = []
                            imagePickerViewModel.imageURLs = []
                            imagePickerViewModel.videoURL = nil
                            imagePickerViewModel.showImagePicker = true
                        }, label: {
                            Image(systemName: "xmark").tint(Color.black)
                        })
                        Spacer()
                        Button(action: {
                            //upload function here!
                        }) {
                            Image(systemName: "checkmark").tint(Color.black)
                        }
//                        .onChange(of: imagePickerViewModel.imageURLs) { oldValue, newValue in
//                            if(oldValue.count < newValue.count) {
//                                checkColor = Color.green
//                            }
//                        }
//                        .disabled(imagePickerViewModel.isUploading)
                        Spacer()
                    }.padding()
                }
            }
            .padding()
        }
}
//
//#Preview {
//    ImagePickerView()
//}
