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
    
    var body: some View {
        VStack{
            Text("Register").font(.system(size: 34))
                .fontWeight(.ultraLight)
                    
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
                                                    let registered = await userViewModel.createNewUser()
                                                }
                    }).fontWeight(.ultraLight)
                                               .foregroundColor(.black)
                                               .padding()
                                               .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.white)
                                                        .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                                                )
                }
    }
}

#Preview {
    CreateUserView()
}
