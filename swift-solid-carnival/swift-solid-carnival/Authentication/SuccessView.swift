//
//  SuccessView.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/3/24.
//

import SwiftUI

struct SuccessView: View {
    @State var back: Bool = false
    @Binding var userViewModel: UserViewModel
    //@State var userViewModel: UserViewModel = UserViewModel() //for testing only
    @State var uid: String = ""
    
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
                Spacer()
            }.onAppear{
                Task{
                    let success = await userViewModel.getCurrentUser()
                    if(!success) {
                        back = true
                    }
                }
            }.navigationDestination(isPresented: $back, destination: {
                LoginUserView().navigationBarBackButtonHidden(true)
            })
        }
    }
}

//#Preview {
//    SuccessView()
//}
