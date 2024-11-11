//
//  CreateUserView.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/3/24.
//

import SwiftUI

struct CreateUserView: View {
    @State var userViewModel: UserViewModel = UserViewModel()
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var success: Bool = false
    @State var existingUser: Bool = false
    @State var error: String = ""
    @State var showAlert: Bool = false
    
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if emailPredicate.evaluate(with: userViewModel.user.email) {
            return true
        } else {
            error = "Must enter a valid email address."
            showAlert = true
            return false
        }
    }
    
    func passwordValidation() -> Bool {
        if userViewModel.user.password!.count >= 8 {
            if userViewModel.user.password == confirmPassword {
                return true
            } else {
                error = "Passwords must match."
                showAlert = true
                return false
            }
        } else {
            error = "Password must be at least 8 characters long."
            showAlert = true
            return false
        }
    }
    
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
                SecureField("Password", text: $password)
                    .tint(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .tint(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                
                Button("Next", action: {
                    if isValidEmail() {
                        if passwordValidation() {
                            Task{
                                userViewModel.user.password = password
                                success = await userViewModel.createNewUser()
                            }
                        }
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
                    .alert("Error", isPresented: $showAlert) {
                                    Button("OK", role: .cancel) {
                                        userViewModel.user.email = ""
                                        password = ""
                                        confirmPassword = ""
                                    }
                                } message: {
                                    Text(error)
                                }
                Spacer()
            }
        }
    }
}

#Preview {
    CreateUserView()
}
