//
//  MIDIEndpointsSelectable.swift
//  SwiftMIDI UI • https://github.com/orchetect/swift-midi-ui
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import SwiftMIDIIO
import SwiftUI

/// Protocol adopted by SwiftMIDIUI SwiftUI views that allow the user to select MIDI endpoints.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol MIDIEndpointsSelectable where Self: View, Endpoint.ID == MIDIIdentifier {
    associatedtype Endpoint: MIDIEndpoint & Hashable & Identifiable

    var endpoints: [Endpoint] { get set }
    var maskedFilter: MIDIEndpointMaskedFilter? { get set }
    var selectionID: MIDIIdentifier? { get set }
    var selectionDisplayName: String? { get set }

    var ids: [MIDIIdentifier] { get set }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension MIDIEndpointsSelectable {
    /// Returns non-nil if properties require updating.
    func updatedID(endpoints: [Endpoint]) -> (id: MIDIIdentifier?, displayName: String?)? {
        if selectionID == .invalidMIDIIdentifier {
            return (id: nil, displayName: nil)
        }

        if let selectionID,
           let selectionDisplayName,
           let found = endpoints.first(
               whereUniqueID: selectionID,
               fallbackDisplayName: selectionDisplayName
           )
        {
            return (id: found.uniqueID, displayName: found.displayName)
        }

        return nil
    }

    func generateIDs(
        endpoints: [Endpoint],
        maskedFilter: MIDIEndpointMaskedFilter?,
        midiManager: MIDIManager?
    ) -> [MIDIIdentifier] {
        var endpointIDs: [MIDIIdentifier] = []
        if let maskedFilter, let midiManager {
            endpointIDs = endpoints
                .filter(maskedFilter, in: midiManager)
                .map(\.id)
        } else {
            endpointIDs = endpoints
                .map(\.id)
        }

        if let selectionID, !endpointIDs.contains(selectionID) {
            return [selectionID] + endpointIDs
        } else {
            return endpointIDs
        }
    }

    func endpoint(for id: MIDIIdentifier) -> Endpoint? {
        endpoints.first(whereUniqueID: id)
    }
}

// MARK: - _MIDIEndpointsSelectable

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
protocol _MIDIEndpointsSelectable: MIDIEndpointsSelectable {
    var midiManager: MIDIManager? { get }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension _MIDIEndpointsSelectable {
    /// Emits an error to the console if `MIDIManager` is missing from the SwiftUI environment.
    /// This method is called from `onAppear { }` in all SwiftMIDIUI views that require the `MIDIManager`.
    func checkForMIDIManager() {
        if midiManager != nil { return }
        
        print("""
            MIDIManager instance is missing from the SwiftUI environment. \
            It must be assigned to the midiManager environment value in order for endpoint lists and pickers to update.
            """
        )
    }
}

#endif
