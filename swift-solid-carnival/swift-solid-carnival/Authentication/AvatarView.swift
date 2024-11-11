//
//  SuccessView.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/3/24.
//

import SwiftUI
import PhotosUI

struct AvatarView: View {
    @Binding var userViewModel: UserViewModel
    @State var back: Bool = false
    @State var imagePickerViewModel: ImagePickerViewModel = ImagePickerViewModel()
    @State var uid: String = ""
    @State var showCamera = false
    @State var selectedImage: UIImage?
    @State var showImagePicker: Bool = true
    @State var s3ViewModel: S3ViewModel = S3ViewModel()
    @State var uploaded: Bool = false
    @State var saved: Bool = false
    @State var processing: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Button("Logout", action: {
                        Task{
                            back = await userViewModel.logoutUser()
                        }
                    }).foregroundStyle(.black)
                        .fontWeight(.light)
                        .padding()
                        .navigationDestination(isPresented: $back, destination: {
                            LoginUserView().navigationBarBackButtonHidden(true)
                        })
                    Spacer()
                }
                Text("Facial Verification Setup")
                Text("Take or Select an Image")
                Spacer()
                
                // View to select from the device image gallery
                if(showImagePicker) {
                    ImagePickerView(imagePickerViewModel: $imagePickerViewModel, userViewModel: $userViewModel, uploaded: $uploaded, saved: $saved, processing: $processing, uploadType: "profile").padding()
                }
                
                // View to capture an image with the device camera
                if let selectedImage {
                    
                    // Display the captured image
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 325, height: 325)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .onAppear {
                                showImagePicker = false
                            }
                            .onTapGesture {
                                self.showCamera.toggle()
                            }
                    HStack {
                        TextField("Username", text: $userViewModel.userData.displayName)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Saving will create the UserData document
                    HStack{
                        Spacer()
                        Button(action: {
                            self.selectedImage = nil
                            showCamera = false
                            showImagePicker = true
                        }, label: {
                            Image(systemName: "xmark").tint(Color.black)
                        })
                        Spacer()
                        Button(action: {
                            processing = true
                            //upload function here!
                            Task{
                                uploaded = await s3ViewModel.uploadImageToS3(image: selectedImage)
                                if (uploaded) {
                                    userViewModel.userData.profileImg = s3ViewModel.imageUrl
                                    saved = await userViewModel.saveUserData()
                                }
                                processing = false
                            }
                        }, label: {
                            if (processing) {
                                ProgressView()
                            } else {
                                Image(systemName: "checkmark").tint(Color.black)
                            }
                        })
                        Spacer()
                    }.padding()
                    
                } else {
                    
                    // Camera button appaers when the selectedImage is nil
                    Button(action: {
                        self.showCamera.toggle()
                    }, label: {
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.black)
                    }).fullScreenCover(isPresented: $showCamera) {
                        accessCameraView(selectedImage: $selectedImage)
                            .background(.black)
                    }
                    
                }
                Spacer()
            }.onAppear{
                
                Task{
                    let success = await userViewModel.getCurrentUser()
                    saved = await userViewModel.getUserData()
                    if(!success) {
                        back = true
                    } else {
                        userViewModel.userData.email = userViewModel.user.email
                    }
                }
                
            }.navigationDestination(isPresented: $back, destination: {
                LoginUserView().navigationBarBackButtonHidden(true)
            })
            .navigationDestination(isPresented: $saved, destination: {
                VerifyView().navigationBarBackButtonHidden(true)
            })
        }
    }
}

//#Preview {
//    AvatarView()
//}
