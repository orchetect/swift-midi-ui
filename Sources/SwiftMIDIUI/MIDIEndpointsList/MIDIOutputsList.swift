//
//  MIDIOutputsList.swift
//  SwiftMIDI UI • https://github.com/orchetect/swift-midi-ui
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import SwiftMIDIIO
import SwiftUI

/// SwiftUI `List` view for selecting MIDI output endpoints.
///
/// This view requires that a **swift-midi-io** `MIDIManager` instance exists in the environment.
///
/// ```swift
/// MIDIOutputsList( ... )
///     .environment(\.midiManager, midiManager)
/// ```
///
/// Optionally supply a tag to auto-update an input connection in MIDIManager.
///
/// ```swift
/// MIDIOutputsList( ... )
///     .environment(\.midiManager, midiManager)
///     .updatingInputConnection(withTag: "MyConnection")
/// ```
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public struct MIDIOutputsList: View, _MIDIOutputsSelectable {
    @Environment(\.midiManager) private var midiManager

    @Binding private var selectionID: MIDIIdentifier?
    @Binding private var selectionDisplayName: String?
    private var showIcons: Bool
    private var hideOwned: Bool

    var updatingInputConnectionWithTag: String?

    @State private var endpoints: [MIDIOutputEndpoint] = []

    public init(
        selectionID: Binding<MIDIIdentifier?>,
        selectionDisplayName: Binding<String?>,
        showIcons: Bool = true,
        hideOwned: Bool = false
    ) {
        _selectionID = selectionID
        _selectionDisplayName = selectionDisplayName
        self.showIcons = showIcons
        self.hideOwned = hideOwned
    }

    public var body: some View {
        MIDIEndpointsList<MIDIOutputEndpoint>(
            endpoints: endpoints,
            maskedFilter: maskedFilter,
            selectionID: $selectionID,
            selectionDisplayName: $selectionDisplayName,
            showIcons: showIcons,
            midiManager: midiManager
        )
        .onAppear { // get initial system state
            guard let midiManager else { return }
            endpoints = midiManager.endpoints.outputs
        }
        .task { // update on changes to system state
            guard let midiManager else { return }
            for await endpoints in midiManager.endpointsStream() {
                updateEndpoints(with: endpoints.outputs)
            }
        }
        .onChange(of: selectionID) { newValue in
            updateInputConnection(id: newValue)
        }
    }

    private var maskedFilter: MIDIEndpointMaskedFilter? {
        hideOwned ? .drop(.owned()) : nil
    }

    private func updateEndpoints(with newEndpoints: [MIDIOutputEndpoint]) {
        guard endpoints != newEndpoints else { return }
        endpoints = newEndpoints
    }

    private func updateInputConnection(id: MIDIIdentifier?) {
        guard let midiManager else { return }
        updateInputConnection(
            selectedUniqueID: id,
            selectedDisplayName: selectionDisplayName,
            midiManager: midiManager
        )
    }
}

#endif
