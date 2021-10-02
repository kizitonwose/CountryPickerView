import class Foundation.Bundle

private class BundleFinder {}

// For some reason this extension for SPM is not geneated when we build the
// framework (CMD + B) but gets generated when the framework is used in a progect.
// Just add it manually with the "_" prefix so it does not clash with the one
// that gets generated when used in a project.
extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static var _module: Bundle = {
        // We also use this name for the cocopods bundle (see podspec) so same code is used for SPM and Cocoapods.
        let bundleName = "CountryPickerView_CountryPickerView"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        // This should be a fallback for Carthage.
        return Bundle(for: CountryPickerView.self)
        // fatalError("unable to find bundle named CountryPickerView_CountryPickerView")
    }()
}
