//
//  Utilities.swift
//  SwiftMIDI UI • https://github.com/orchetect/swift-midi-ui
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftMIDIIO
import SwiftUI

/// Allow use with `@AppStorage` by conforming to a supported `RawRepresentable` type.
extension MIDIIdentifier: @retroactive RawRepresentable {
    public typealias RawValue = Int

    public init?(rawValue: RawValue) {
        self = Self(rawValue)
    }

    public var rawValue: RawValue {
        Int(self)
    }
}
