//
//  EmptyDetailsView.swift
//  SwiftMIDI UI • https://github.com/orchetect/swift-midi-ui
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct EmptyDetailsView: View {
    var body: some View {
        VStack(spacing: 10) {
            if #available(macOS 11.0, iOS 14.0, *) {
                Image(systemName: "pianokeys")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondary)
                    .frame(width: 140, height: 140)
                Spacer()
                    .frame(height: 50)
            }

            DetailsInfoView()
        }
        .padding()
        .multilineTextAlignment(.center)
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
