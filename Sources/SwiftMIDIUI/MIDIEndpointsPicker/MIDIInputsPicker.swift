//
//  MIDIInputsPicker.swift
//  SwiftMIDI UI • https://github.com/orchetect/swift-midi-ui
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import SwiftMIDIIO
import SwiftUI

/// SwiftUI `Picker` view for selecting MIDI input endpoints.
///
/// This view requires that a **swift-midi-io** `MIDIManager` instance exists in the environment.
///
/// ```swift
/// MIDIInputsPicker( ... )
///     .environment(\.midiManager, midiManager)
/// ```
///
/// Optionally, auto-update an output connection in the `MIDIManager` when the selection changes by using
/// the ``MIDIInputsSelectable/updatingOutputConnection(withTag:)`` view modifier.
///
/// ```swift
/// MIDIInputsPicker( ... )
///     .updatingOutputConnection(withTag: "MyConnection")
///     .environment(\.midiManager, midiManager)
/// ```
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public struct MIDIInputsPicker: View, _MIDIInputsSelectable {
    @Environment(\.midiManager) private var midiManager

    private var title: String
    @Binding private var selectionID: MIDIIdentifier?
    @Binding private var selectionDisplayName: String?
    private var showIcons: Bool
    private var hideOwned: Bool

    var updatingOutputConnectionWithTag: String?

    @State private var endpoints: [MIDIInputEndpoint] = []

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
        MIDIEndpointsPicker<MIDIInputEndpoint>(
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
            endpoints = midiManager.endpoints.inputs
        }
        .task { // update on changes to system state
            guard let midiManager else { return }
            for await endpoints in midiManager.endpointsStream() {
                updateEndpoints(with: endpoints.inputs)
            }
        }
        .onChange(of: selectionID) { newValue in
            updateOutputConnection(id: newValue)
        }
    }

    private var maskedFilter: MIDIEndpointMaskedFilter? {
        hideOwned ? .drop(.owned()) : nil
    }

    private func updateEndpoints(with newEndpoints: [MIDIInputEndpoint]) {
        guard endpoints != newEndpoints else { return }
        endpoints = newEndpoints
    }

    private func updateOutputConnection(id: MIDIIdentifier?) {
        guard let midiManager else { return }
        updateOutputConnection(
            selectedUniqueID: id,
            selectedDisplayName: selectionDisplayName,
            midiManager: midiManager
        )
    }
}

#endif
