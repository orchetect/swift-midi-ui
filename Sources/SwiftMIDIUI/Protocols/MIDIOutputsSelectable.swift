//
//  MIDIOutputsSelectable.swift
//  SwiftMIDI UI • https://github.com/orchetect/swift-midi-ui
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import SwiftMIDIIO
import SwiftUI

/// Protocol adopted by SwiftMIDIUI SwiftUI views that allow the user to select MIDI output endpoints.
public protocol MIDIOutputsSelectable {
    /// Automatically updates the MIDI input connection with the given tag (if it exists) in the `MIDIManager` in response
    /// to endpoint selection changes in a MIDI endpoint list or picker.
    ///
    /// In order for this to occur, the `MIDIManager` instance must be injected into the ``SwiftUICore/EnvironmentValues/midiManager``
    /// environment value. If it is not, then this view modifier has no effect and is the same as not using the view modifier.
    ///
    /// Supplying a `nil` tag simply bypasses the action and is the same as not using the view modifier.
    func updatingInputConnection(withTag tag: String?) -> Self
}

protocol _MIDIOutputsSelectable: MIDIOutputsSelectable {
    var updatingInputConnectionWithTag: String? { get set }
}

extension _MIDIOutputsSelectable {
    public func updatingInputConnection(withTag tag: String?) -> Self {
        var copy = self
        copy.updatingInputConnectionWithTag = tag
        return copy
    }

    func updateInputConnection(
        selectedUniqueID: MIDIIdentifier?,
        selectedDisplayName: String?,
        midiManager: MIDIManager
    ) {
        guard let tag = updatingInputConnectionWithTag,
              let midiInputConnection = midiManager.managedInputConnections[tag]
        else { return }

        guard let selectedUniqueID,
              let selectedDisplayName,
              selectedUniqueID != .invalidMIDIIdentifier
        else {
            midiInputConnection.removeAllOutputs()
            return
        }

        let criterium: MIDIEndpointIdentity = .uniqueIDWithFallback(
            id: selectedUniqueID,
            fallbackDisplayName: selectedDisplayName
        )
        if midiInputConnection.outputsCriteria != [criterium] {
            midiInputConnection.removeAllOutputs()
            midiInputConnection.add(outputs: [criterium])
        }
    }
}

#endif
