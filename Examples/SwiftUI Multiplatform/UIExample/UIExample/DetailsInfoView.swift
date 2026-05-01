//
//  DetailsInfoView.swift
//  SwiftMIDI Examples • https://github.com/orchetect/swift-midi-examples
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct DetailsInfoView: View {
    var body: some View {
        Group {
            Text("Endpoint selections are saved persistently and restored after app relaunch.")
            Text("If the selected endpoint is removed from the system, it is displayed as missing in the UI.")
            Text("However it remains selected and will be restored when it reappears in the system.")
        }
        .lineLimit(10)
    }
}
