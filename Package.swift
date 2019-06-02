// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CountryPickerView",
    products: [
        .library(name: "CountryPickerView", targets: ["CountryPickerView"])
    ],
    targets: [
        .target(
            name: "CountryPickerView",
            path: "CountryPickerView"
        )
    ]
)
