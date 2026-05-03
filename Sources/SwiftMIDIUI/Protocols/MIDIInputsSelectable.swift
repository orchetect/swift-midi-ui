//
//  MIDIInputsSelectable.swift
//  SwiftMIDI UI • https://github.com/orchetect/swift-midi-ui
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import SwiftMIDIIO
import SwiftUI

/// Protocol adopted by SwiftMIDIUI SwiftUI views that allow the user to select MIDI input endpoints.
public protocol MIDIInputsSelectable {
    /// Automatically updates the MIDI output connection with the given tag (if it exists) in the `MIDIManager` in response
    /// to endpoint selection changes in a MIDI endpoint list or picker.
    ///
    /// In order for this to occur, the `MIDIManager` instance must be injected into the ``SwiftUICore/EnvironmentValues/midiManager``
    /// environment value. If it is not, then this view modifier has no effect and is the same as not using the view modifier.
    ///
    /// Supplying a `nil` tag simply bypasses the action and is the same as not using the view modifier.
    func updatingOutputConnection(withTag tag: String?) -> Self
}

protocol _MIDIInputsSelectable: MIDIInputsSelectable {
    var updatingOutputConnectionWithTag: String? { get set }
}

extension _MIDIInputsSelectable {
    public func updatingOutputConnection(withTag tag: String?) -> Self {
        var copy = self
        copy.updatingOutputConnectionWithTag = tag
        return copy
    }

    func updateOutputConnection(
        selectedUniqueID: MIDIIdentifier?,
        selectedDisplayName: String?,
        midiManager: MIDIManager
    ) {
        guard let tag = updatingOutputConnectionWithTag,
              let midiOutputConnection = midiManager.managedOutputConnections[tag]
        else { return }

        guard let selectedUniqueID,
              let selectedDisplayName,
              selectedUniqueID != .invalidMIDIIdentifier
        else {
            midiOutputConnection.removeAllInputs()
            return
        }

        let criterium: MIDIEndpointIdentity = .uniqueIDWithFallback(
            id: selectedUniqueID,
            fallbackDisplayName: selectedDisplayName
        )
        if midiOutputConnection.inputsCriteria != [criterium] {
            midiOutputConnection.removeAllInputs()
            midiOutputConnection.add(inputs: [criterium])
        }
    }
}

#endif
