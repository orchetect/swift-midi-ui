//
//  ContentView.swift
//  SwiftMIDI Examples • https://github.com/orchetect/swift-midi-examples
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftMIDIIO
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var midiHelper: MIDIHelper

    var body: some View {
        NavigationView {
            List {
                Section("Controls") {
                    NavigationLink("Endpoint List") {
                        details(index: 0)
                        #if os(iOS)
                            .navigationBarTitle("Endpoint List", displayMode: .inline)
                            .navigationBarBackButtonHidden(false)
                        #endif
                    }
                    .tag(0)

                    NavigationLink("Endpoint Picker") {
                        details(index: 1)
                        #if os(iOS)
                            .navigationBarTitle("Endpoint Picker", displayMode: .inline)
                            .navigationBarBackButtonHidden(false)
                        #endif
                    }
                    .tag(1)
                }

                #if os(iOS)
                Section("Info") {
                    DetailsInfoView()
                        .foregroundColor(.secondary)
                }
                #endif
            }

            EmptyDetailsView()
        }
        .navigationTitle("Reusable Components")
    }

    private func details(index: Int) -> some View {
        VStack {
            switch index {
            case 0:
                ListsExampleView()
            case 1:
                PickersExampleView()
            default:
                EmptyDetailsView()
            }

            VStack(spacing: 10) {
                #if os(iOS)
                if UIDevice.current.userInterfaceIdiom == .phone {
                    VStack { virtualEndpointsButtons }
                } else {
                    HStack { virtualEndpointsButtons }
                }
                #else
                HStack { virtualEndpointsButtons }
                #endif
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.background)
        }
    }

    private var virtualEndpointsButtons: some View {
        Group {
            Button("Create Test Endpoints") {
                midiHelper.createVirtualEndpoints()
            }
            .disabled(midiHelper.isVirtualEndpointsExist)

            Button("Remove Test Endpoints") {
                midiHelper.removeVirtualEndpoints()
            }
            .disabled(!midiHelper.isVirtualEndpointsExist)
        }
        .buttonStyle(.bordered)
    }
}
