![swift-midi-ui](Images/swift-midi-ui-banner.png)

# swift-midi-ui

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-midi-ui%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/orchetect/swift-midi-ui) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-midi-ui%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/orchetect/swift-midi-ui) [![License: MIT](http://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-midi-ui/blob/main/LICENSE)

Extension for [swift-midi](https://github.com/orchetect/swift-midi) adding reusable user interface controls for SwiftUI.

## Compatibility

| macOS | iOS  | visionOS | Linux | Android | Windows |
| :---: | :--: | :------: | :---: | :-----: | :-----: |
|   🟢   |  🟢   |    🟢     |   -   |    -    |    -    |

## Getting Started

This extension is available as a Swift Package Manager (SPM) package.

To use this extension as standalone dependency (instead of importing the **swift-midi** umbrella repository):

1. Add the **swift-midi-ui** repo as a dependency.

   ```swift
   .package(url: "https://github.com/orchetect/swift-midi-ui", from: "1.0.0")
   ```

2. Add **SwiftMIDIUI** to your target.

   ```swift
   .product(name: "SwiftMIDIUI", package: "swift-midi-ui")
   ```

3. Import **SwiftMIDIUI** to use it.

   ```swift
   import SwiftMIDIUI
   ```

## Documentation & Support

For documentation, support, and example code see the main [swift-midi](https://github.com/orchetect/swift-midi) repository.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/swift-midi-ui/blob/master/LICENSE) for details.
