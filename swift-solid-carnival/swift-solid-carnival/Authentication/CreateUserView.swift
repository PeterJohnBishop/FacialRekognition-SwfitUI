//
//  CreateUserView.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/3/24.
//

import SwiftUI

struct CreateUserView: View {
    @State var userViewModel: UserViewModel = UserViewModel()
    @State var confirmPassword: String = ""
    @State var success: Bool = false
    @State var existingUser: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Spacer()
                    Button("Login", action: {
                        existingUser = true
                    }).foregroundStyle(.black)
                        .fontWeight(.light)
                        .padding()
                        .navigationDestination(isPresented: $existingUser, destination: {
                            LoginUserView().navigationBarBackButtonHidden(true)
                        })
                }
                Spacer()
                Text("Register").font(.system(size: 34))
                    .fontWeight(.ultraLight)
                Divider().padding()
                TextField("Email", text: $userViewModel.user.email)
                    .tint(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                SecureField("Password", text: $userViewModel.user.password)
                    .tint(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .tint(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                
                Button("Submit", action: {
                    Task{
                        success = await userViewModel.createNewUser()
                    }
                }).fontWeight(.ultraLight)
                    .foregroundColor(.black)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                    )
                    .navigationDestination(isPresented: $success, destination: {
                        AvatarView(userViewModel: $userViewModel).navigationBarBackButtonHidden(true)
                    })
                Spacer()
            }
        }
    }
}

#Preview {
    CreateUserView()
}
