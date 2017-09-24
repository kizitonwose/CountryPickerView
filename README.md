# CountryPickerView

<img src="/CountryPickerViewDemo/flag.gif" width="300">

[![Version](https://img.shields.io/cocoapods/v/CountryPickerView.svg?style=flat)](http://cocoapods.org/pods/CountryPickerView)
[![License](https://img.shields.io/cocoapods/l/CountryPickerView.svg?style=flat)](http://cocoapods.org/pods/CountryPickerView)
[![Platform](https://img.shields.io/cocoapods/p/CountryPickerView.svg?style=flat)](http://cocoapods.org/pods/CountryPickerView)

CountryPickerView is a simple, customizable view for selecting countries in iOS apps. 

You can clone/download the repository and run the [demo project](/.CountryPickerViewDemo). First run `pod install` from the CountryPickerViewDemo directory.

<img align="left" src="/CountryPickerViewDemo/place_holder.png" width="300">
<img src="/CountryPickerViewDemo/place_holder.png" width="300">
<img align="left" src="/CountryPickerViewDemo/place_holder.png" width="300">
<img src="/CountryPickerViewDemo/place_holder.png" width="300">


## Installation

### Cocoapods

CountryPickerView is available through [CocoaPods](http://cocoapods.org). Simply add the following to your Podfile:

```ruby
use_frameworks!

target '<Your Target Name>'
pod 'CountryPickerView', '~> 1.0'
```

### Manual

1. Put CountryPickerView repo somewhere in your project directory.
1. In Xcode, add `CountryPickerView.xcodeproj` to your project.
1. On your app's target, add the CountryPickerView framework:
  1. as an embedded binary on the General tab.
  1. as a target dependency on the Build Phases tab.

## Usage

If you're using Storyboards/Interface Builder you can create a CountryPickerView instance by adding a UIView to your Storyboard, and then manually changing the view's class to CountryPickerView in the "Custom Class" field of the Identity Inspector tab on the Utilities panel (the right-side panel)

You can also create an insatnce of CountryPickerView programmaticaly:

```swift
import CountryPickerView

let cpv = CountryPickerView(frame:)
```

To get the selected country from your `CountryPickerView` instance at any time, use the `selectedCountry` property. 

```swift
let country = cpv.selectedCountry
print(country)
```
This property is not optional, the default value is the user's current country.

### Customization

Customization options for the view itself are available directly via the CountryPickerView instance while options for the internal CountryPicker table view are available via the `CountryPickerViewDataSource` protocol. Setting the `CountryPickerViewDelegate` protocol is also neccessary if you wish to be notified when the user selects a country from the list.

```swift
import CountryPickerView

class DemoViewController: UIViewController, CountryPickerViewDelegate, CountryPickerViewDataSource {

    @IBOutlet weak var countryPickerView: CountryPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        // Direct customizations on CountryPickerView instance
        
        // Show the selected country's phone(e.g +234) code on the view
        countryPickerView.showPhoneCodeInView = true
        
        // Show the selected country's iso code(e.g NG) on the view
        countryPickerView.showCountryCodeInView = true
    }
    
}
```

#### CountryPickerViewDelegate
The delegate function will be called when the user selects a country from the list or when you manually set the `selectedCountry` property of the `CountryPickerView`

```swift
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country)
    }
```

#### CountryPickerViewDataSource
The datasource functions define the internal(country list) view controler's behavior. Run the demo project to play around with the options.

- An array of countries you wish to show at the top of the list. This is useful if your app is targeted towards people in specific countries. 
  ```swift
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]?
  ``` 
- The desired title for the preferred section. 
  ```swift  
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String?
  ```
  Note that you have to return a non-empty array of countries as well as the section title if you wish to show preferred countries on the list. Returning only the array will not work, the section title is required.
 
- The navigation item title when the internal view controller is pushed/presented.
  ```swift   
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?
  ``` 
 
- A navigation item button to be used if the internal view controller is presented(not pushed). If nil is returned, a default "Close" button is used.
  ```swift    
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem?
  ```

- Desired position for the search bar.
  ```swift    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition
  ```
  Posible values are: `.tableViewHeader`, `.navigationBar` and `.hidden`
 
- Show the phone code alongside the country name on the list. e.g Nigeria (+234) 
  ```swift    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool? 
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
This means your users do not have to worry about entering the country's phone code in the text field. This also ensures you get a valid phone code from `CountryPickerView` instead of relying on the user.

### Using the internal picker independently

If for any reason you do not want to show the default view or have your own implementation for showing country information, you can still use the internal picker to allow your users select countries from the list by calling the function `showCountriesList(from: UIViewController)` on a `CountryPickerView` instance. 

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

CountryPickerView is distributed under the MIT license. [See LICENSE](./LICENSE.md) for details.
