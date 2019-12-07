# CountryPickerView

[![Build Status](https://travis-ci.org/kizitonwose/CountryPickerView.svg?branch=master)](https://travis-ci.org/kizitonwose/CountryPickerView)
[![Platform](https://img.shields.io/badge/Platform-iOS-00BCD4.svg)](http://cocoapods.org/pods/CountryPickerView)
[![Version](https://img.shields.io/cocoapods/v/CountryPickerView.svg?style=flat)](http://cocoapods.org/pods/CountryPickerView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/badge/License-MIT-8D6E63.svg)](https://github.com/kizitonwose/CountryPickerView/blob/master/LICENSE.md)

CountryPickerView is a simple, customizable view for selecting countries in iOS apps.

You can clone/download the repository and run the [demo project](https://github.com/kizitonwose/CountryPickerView/tree/master/CountryPickerViewDemo) to see CountryPickerView in action. First run `pod install` from the CountryPickerViewDemo directory.

<img align="left" src="https://raw.githubusercontent.com/kizitonwose/CountryPickerView/master/CountryPickerViewDemo/Screenshots/1.png" width="300">
<img src="https://raw.githubusercontent.com/kizitonwose/CountryPickerView/master/CountryPickerViewDemo/Screenshots/2.png" width="300">

<img align="left" src="https://raw.githubusercontent.com/kizitonwose/CountryPickerView/master/CountryPickerViewDemo/Screenshots/3.png" width="300">
<img src="https://raw.githubusercontent.com/kizitonwose/CountryPickerView/master/CountryPickerViewDemo/Screenshots/4.png" width="300">


## Installation

> Note that 3.x releases are Swift 5 compatible. For the Swift 4 compatibility, use 2.x releases. For the Swift 3 compatibility, use 1.x releases.

### Cocoapods

CountryPickerView is available through [CocoaPods](http://cocoapods.org). Simply add the following to your Podfile:

```ruby
use_frameworks!

target '<Your Target Name>' do
  pod 'CountryPickerView'
end
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To install CountryPickerView through Carthage, simply add the following to your Cartfile:

```ruby
github "kizitonwose/CountryPickerView"
```

### Manual

1. Put CountryPickerView repo somewhere in your project directory.
2. In Xcode, add `CountryPickerView.xcodeproj` to your project.
3. On your app's target, add the CountryPickerView framework:
   1. as an embedded binary on the General tab.
   2. as a target dependency on the Build Phases tab.

## Usage

If you're using Storyboards/Interface Builder you can create a CountryPickerView instance by adding a UIView to your Storyboard, and then manually changing the view's class to CountryPickerView in the "Custom Class" field of the Identity Inspector tab on the Utilities panel (the right-side panel)

You can also create an instance of CountryPickerView programmatically:

```swift
import CountryPickerView

let cpv = CountryPickerView(frame: /**Desired frame**/)
```

To get the selected country from your `CountryPickerView` instance at any time, use the `selectedCountry` property.

```swift
let country = cpv.selectedCountry
print(country)
```
This property is not optional, the default value is the user's current country, derived from the device's current Locale.

### Customization

Customization options for the view itself are available directly via the CountryPickerView instance while options for the internal CountryPicker table view are available via the `CountryPickerViewDataSource` protocol. Setting the `CountryPickerViewDelegate` protocol is also necessary if you wish to be notified when the user selects a country from the list.

```swift
import CountryPickerView

class DemoViewController: UIViewController, CountryPickerViewDelegate, CountryPickerViewDataSource {

    @IBOutlet weak var countryPickerView: CountryPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        countryPickerView.delegate = self
        countryPickerView.dataSource = self
    }
}
```

#### CountryPickerView properties

|Property|Description|Default value|
|:-:|:-:|:-:|
|showCountryCodeInView|Show or hide the country code(e.g NG) on the view.|true|
|showPhoneCodeInView|Show or hide the phone code(e.g +234) on the view.|true|
|font|The font of the phone/country code text.|system font|
|textColor|The color of the phone/country code text.|black|
|flagSpacingInView|The spacing between the flag image and the phone code text.|8px|
|hostViewController|The view controller used to show the internal `CountryPickerViewController`. If this is an instance of `UINavigationController`, the `CountryPickerViewController` will be pushed on the stack. If not, the `CountryPickerViewController` will be presented on its own navigation stack. If this property is `nil`, the view will try to find the nearest view controller and use that to present or push the `CountryPickerViewController`.|nil|
|delegate|An instance of `CountryPickerViewDelegate` type.|nil|
|dataSource|An instance of `CountryPickerViewDataSource` type.|nil|


#### CountryPickerViewDelegate
- Called when the user selects a country from the list or when you manually set the `selectedCountry` property of the `CountryPickerView`

  ```swift
  func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
  ```

- Called before the CountryPickerViewController is presented or pushed. The CountryPickerViewController is a UITableViewController subclass.
  
  ```swift
  func countryPickerView(_ countryPickerView: CountryPickerView, willShow viewController: CountryPickerViewController)
  ```

- Called after the CountryPickerViewController is presented or pushed. The CountryPickerViewController is a UITableViewController subclass.
  
  ```swift
  func countryPickerView(_ countryPickerView: CountryPickerView, didShow viewController: CountryPickerViewController)
  ```

**Note: If you already have a `Country` class or struct in your project then implementing the `didSelectCountry` delegate method can cause a compile error with a message saying that your conforming class does not comform to the `CountryPickerViewDelegate` protocol. This is because Xcode can't figure out which Country model to use in the method. The solution is to replace the `Country` in the method signature with the typealias `CPVCountry`, your delegate method should now look like this:**

```swift
func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: CPVCountry)
``` 
  
  You can also use `CPVCountry` as a replacement for the framework's `Country` model in other parts of your project.

Also, `willShow` and `didShow` delegate methods are optional. If the CountryPickerViewController is presented(not pushed), it is embedded in a UINavigationController.
The `CountryPickerViewController` class is made available so you can customize its appearance if needed. You can also access the public `searchController(UISearchController)` property in the `CountryPickerViewController` for customization.


#### CountryPickerViewDataSource
The datasource methods define the internal(country list) ViewController's behavior. Run the demo project to play around with the options. All methods are optional.

- An array of countries you wish to show at the top of the list. This is useful if your app is targeted towards people in specific countries.
  
  ```swift
  func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]
  ```

- The desired title for the preferred section.
  
  ```swift  
  func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String?
  ```
  **Note:** You have to return a non-empty array of countries from `preferredCountries(in countryPickerView: CountryPickerView)` as well as this section title if you wish to show preferred countries on the list. Returning only the array or title will not work.

- Show **ONLY** the preferred countries section on the list. Default value is `false`
  
  ```swift  
  func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool
  ```
  Return `true` to hide the internal list so your users can only choose from the preferred countries list.

- The desired font for the section title labels on the list. Can be used to configure the text size.
  
  ```swift  
  func sectionTitleLabelFont(in countryPickerView: CountryPickerView) -> UIFont
  ```

- The desired text color for the section title labels on the list.
  
  ```swift  
  func sectionTitleLabelColor(in countryPickerView: CountryPickerView) -> UIColor?
  ```

- The desired font for the cell labels on the list. Can be used to configure the text size.
  
  ```swift  
  func cellLabelFont(in countryPickerView: CountryPickerView) -> UIFont
  ```

- The desired text color for the country names on the list.
  
  ```swift  
  func cellLabelColor(in countryPickerView: CountryPickerView) -> UIColor?
  ```

- The desired size for the flag images on the list.
  
  ```swift  
  func cellImageViewSize(in countryPickerView: CountryPickerView) -> CGSize
  ```

- The desired corner radius for the flag images on the list.
  
  ```swift  
  func cellImageViewCornerRadius(in countryPickerView: CountryPickerView) -> CGFloat
  ```

- The navigation item title when the internal view controller is pushed/presented. Default value is `nil`
  
  ```swift   
  func navigationTitle(in countryPickerView: CountryPickerView) -> String?
  ```

- A navigation item button to be used if the internal view controller is presented(not pushed). If nil is returned, a default "Close" button is used. This method only enables you return a button customized the way you want. Default value is `nil`
  
  ```swift    
  func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem?
  ```
  **Note:** Any `target` or `action` associated with this button will be replaced as this button's sole purpose is to close the internal view controller.

- Desired position for the search bar. Default value is `.tableViewHeader`
  
  ```swift    
  func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition
  ```
  Possible values are: `.tableViewHeader`, `.navigationBar` and `.hidden`

- Show the phone code alongside the country name on the list. e.g Nigeria (+234). Default value is `false`
  
  ```swift    
  func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool
  ```

- Show the country code alongside the country name on the list. e.g Nigeria (NG). If `true`, searches are also performed against the country codes. Default value is `false`
  
  ```swift    
  func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool
  ```

- Show a checkmark on the selected country on the list. Default value is `true`
  
  ```swift    
  func showCheckmarkInList(in countryPickerView: CountryPickerView) -> Bool
  ```

- The locale used to display country names on the list. Default value is the current locale.
  
  ```swift    
  func localeForCountryNameInList(in countryPickerView: CountryPickerView) -> Locale
  ```

### Using CountryPickerView with UITextField

A good use case for `CountryPickerView` is when used as the left view of a phone number input field.

```swift
class DemoViewController: UIViewController {

    @IBOutlet weak var phoneNumberField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        phoneNumberField.leftView = cpv
        phoneNumberField.leftViewMode = .always
    }
}
```
This means your users do not have to worry about entering the country's phone code in the text field. This also ensures you get a valid phone code from `CountryPickerView` instead of relying on your users.

### Using the internal picker independently

If for any reason you do not want to show the default view or have your own implementation for showing country information, you can still use the internal picker to allow your users select countries from the list by calling the method `showCountriesList(from: UIViewController)` on a `CountryPickerView` instance.

It's important to keep a field reference to the `CountryPickerView` instance else it will be garbage collected and any attempt to use it will result to a crash.

```swift
class DemoViewController: UIViewController {

    // Keep a field reference
    let countryPickerView = CountryPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonPressed(_ sender: Any) {
        countryPickerView.showCountriesList(from: self)
    }
}
```
In the example above, calling `countryPickerView.showCountriesList(from: self)` will result in the internal picker view controller being presented in its own navigation stack because `DemoViewController` is not a navigation controller.

If you already have a navigation stack, you can push the internal picker view controller onto that stack by calling `countryPickerView.showCountriesList(from: self.navigationController!)` or do it the safe way:

```swift
if let nav = self.navigationController {
	countryPickerView.showCountriesList(from: nav)
}
```
Don't forget to set a delegate to be notified when the use selects a country from the list. An example of how to use the internal picker view controller is included in the demo project.


## License

CountryPickerView is distributed under the MIT license. [See LICENSE](https://github.com/kizitonwose/CountryPickerView/blob/master/LICENSE.md) for details.
