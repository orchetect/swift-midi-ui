//
//  UIExampleApp.swift
//  SwiftMIDI UI • https://github.com/orchetect/swift-midi-ui
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@main
struct UIExampleApp: App {
    @StateObject var midiHelper = MIDIHelper(start: true)

    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(macOS)
                .toolbar { Spacer() } // coax unified titlebar to show
                .frame(minHeight: 600)
                #endif
        }
        .environmentObject(midiHelper)
    }
}
