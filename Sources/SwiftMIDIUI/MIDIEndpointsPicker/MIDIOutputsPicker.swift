//
//  MIDIOutputsPicker.swift
//  SwiftMIDI UI • https://github.com/orchetect/swift-midi-ui
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import SwiftMIDIIO
import SwiftUI

/// SwiftUI `Picker` view for selecting MIDI output endpoints.
///
/// This view requires that a **swift-midi-io** `MIDIManager` instance exists in the environment.
///
/// ```swift
/// MIDIOutputsPicker( ... )
///     .environment(\.midiManager, midiManager)
/// ```
///
/// Optionally supply a tag to auto-update an input connection in MIDIManager.
///
/// ```swift
/// MIDIOutputsPicker( ... )
///     .environment(\.midiManager, midiManager)
///     .updatingInputConnection(withTag: "MyConnection")
/// ```
@available(macOS 14.0, iOS 17.0, *)
public struct MIDIOutputsPicker: View, _MIDIOutputsSelectable {
    @Environment(\.midiManager) private var midiManager

    private var title: String
    @Binding private var selectionID: MIDIIdentifier?
    @Binding private var selectionDisplayName: String?
    private var showIcons: Bool
    private var hideOwned: Bool

    var updatingInputConnectionWithTag: String?

    @State private var endpoints: [MIDIOutputEndpoint] = []

    public init(
        title: String,
        selectionID: Binding<MIDIIdentifier?>,
        selectionDisplayName: Binding<String?>,
        showIcons: Bool = true,
        hideOwned: Bool = false
    ) {
        self.title = title
        _selectionID = selectionID
        _selectionDisplayName = selectionDisplayName
        self.showIcons = showIcons
        self.hideOwned = hideOwned
    }

    public var body: some View {
        MIDIEndpointsPicker<MIDIOutputEndpoint>(
            title: title,
            endpoints: endpoints,
            maskedFilter: maskedFilter,
            selectionID: $selectionID,
            selectionDisplayName: $selectionDisplayName,
            showIcons: showIcons,
            midiManager: midiManager
        )
        .onAppear { // get initial system state
            guard let midiManager else { return }
            self.endpoints = midiManager.endpoints.outputs
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
