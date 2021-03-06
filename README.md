# GitHubSearchWithSwiftUI

GitHubSearchWithSwiftUI is an example that using [Combine](https://developer.apple.com/documentation/combine) and [SwiftUI <img width="18px" src="https://developer.apple.com/assets/elements/icons/swiftui/swiftui-96x96.png"/>](https://developer.apple.com/xcode/swiftui/)


| Receive Results | Receive Error | SafariViewController |
| :-: | :-: | :-: |
| ![](https://user-images.githubusercontent.com/2082134/58905672-41539280-8745-11e9-99e3-cb3c3c4991f0.png) | ![](https://user-images.githubusercontent.com/2082134/59124140-e1a1f500-8999-11e9-9d28-aaa2181a5e43.png) | ![](https://user-images.githubusercontent.com/2082134/59275420-4198e400-8c97-11e9-8e44-588f328bde8d.png)

[ricemill-sample](https://github.com/marty-suzuki/GitHubSearchWithSwiftUI/blob/ricemill-sample/GitHubSearchWithSwiftUI/View/RepositoryListViewModel.swift#L14-L90) branch is a sample which used [Ricemill](https://github.com/marty-suzuki/Ricemill) (that is Unidirectional Input / Output framework with Combine and SwiftUI).

## TODO

- [x] Search with TextField's text
- [x] Reflect API responses to List
- [x] Separate API access from BindableObject
- [x] Use Combine with API access
- [x] Reflect responses in MainThread via Combine

## Requirements

- Xcode 11 Beta 5
- Swift 5.1
- iOS 13 Beta

## References

- https://developer.apple.com/tutorials/swiftui/tutorials
- https://developer.apple.com/documentation/swiftui
- https://developer.apple.com/documentation/combine
- https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/
- [Data Flow Through SwiftUI](https://developer.apple.com/videos/play/wwdc2019/226)
- [Building Custom Views with SwiftUI](https://developer.apple.com/videos/play/wwdc2019/237)
- [Combine in Practice](https://developer.apple.com/videos/play/wwdc2019/721)
- [Introducing Combine](https://developer.apple.com/videos/play/wwdc2019/722)
- [Introducing Combine and Advances in Foundation](https://developer.apple.com/videos/play/wwdc2019/711)

## License

GitHubSearchWithSwiftUI is under MIT license. See the [LICENSE](./LICENSE) file for more info.
