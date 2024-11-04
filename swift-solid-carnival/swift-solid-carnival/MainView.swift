//
//  MainView.swift
//  swift-solid-carnival
//
//  Created by m1_air on 11/3/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        LoginUserView().onAppear{
            SocketService.shared.socket.connect()
        }.onChange(of: SocketService.shared.connected, {
            if SocketService.shared.connected {
                SocketService.shared.socket.emit("ios", ["message":"\(SocketService.shared.socket.sid ?? "") connected on iOS!"])
            }
        })
    }
}

#Preview {
    MainView()
}
