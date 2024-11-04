//
//  LoginUserView.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/3/24.
//

import SwiftUI

struct LoginUserView: View {
    @State var userViewModel: UserViewModel = UserViewModel()
    @State var success: Bool = false
    
    var body: some View {
        NavigationStack{
                    VStack{
                        Text("Login")
                        
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
                        
                        Button("Submit", action: {
                            Task{
                                success = await userViewModel.authenticateUser()
                            }
                        }).navigationDestination(isPresented: $success, destination: {
                            SuccessView()
                        })
                        .fontWeight(.ultraLight)
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                        )
                    }.onAppear{
                        
                    }
                }
    }
}

#Preview {
    LoginUserView()
}
