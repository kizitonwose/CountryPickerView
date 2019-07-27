Pod::Spec.new do |spec|

  spec.name         = "CountryPickerView"
  spec.version      = "3.0.2"
  spec.summary      = "A simple, customizable view for selecting countries in iOS apps."
  spec.homepage     = "https://github.com/kizitonwose/CountryPickerView"
  spec.license      = "MIT"
  spec.author       = { "Kizito Nwose" => "kizitonwose@gmail.com" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/kizitonwose/CountryPickerView.git", :tag => spec.version }
  spec.source_files  = "CountryPickerView/**/*.{swift}"
  spec.resource_bundles = {
    'CountryPickerView' => ['CountryPickerView/Assets/CountryPickerView.bundle/*',
    'CountryPickerView/**/*.{xib}']
  }
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

end
