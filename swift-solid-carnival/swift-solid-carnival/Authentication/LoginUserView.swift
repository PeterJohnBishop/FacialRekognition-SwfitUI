//
//  LoginUserView.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/3/24.
//

import SwiftUI

struct LoginUserView: View {
    @State var userViewModel: UserViewModel = UserViewModel()
    @State var password: String = ""
    @State var success: Bool = false
    @State var newUser: Bool = false
    
    var body: some View {
        NavigationStack{
                    VStack{
                        HStack{
                            Spacer()
                            Button("Register", action: {
                                newUser = true
                            }).foregroundStyle(.black)
                                .fontWeight(.light)
                                .padding()
                                .navigationDestination(isPresented: $newUser, destination: {
                                    CreateUserView().navigationBarBackButtonHidden(true)
                                })
                        }
                        Spacer()
                        Text("Login").font(.system(size: 34))
                            .fontWeight(.ultraLight)
                        Divider().padding()
                        TextField("Email", text: $userViewModel.user.email)
                            .tint(.black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                        
                        SecureField("Password", text: $password)
                            .tint(.black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                        
                        
                        Button("Submit", action: {
                            Task{
                                userViewModel.user.password = password
                                success = await userViewModel.authenticateUser()
                            }
                        }).navigationDestination(isPresented: $success, destination: {
                            AvatarView(userViewModel: $userViewModel).navigationBarBackButtonHidden(true)
                        })
                        .fontWeight(.ultraLight)
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                        )
                        Spacer()
                    }.onAppear{
                        
                    }
                }
    }
}

#Preview {
    LoginUserView()
}
