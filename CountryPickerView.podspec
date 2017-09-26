Pod::Spec.new do |s|

  s.name         = "CountryPickerView"
  s.version      = "1.0.0"
  s.summary      = "A simple, customizable view for selecting countries in iOS apps."
  s.homepage     = "https://github.com/kizitonwose/CountryPickerView"
  s.license      = "MIT"
  s.author       = { "Kizito Nwose" => "kizitonwose@gmail.com" }
  s.platform     = :ios, "8.0"
  #s.source       = { :git => "https://github.com/kizitonwose/CountryPickerView.git", :tag => "{s.version}" }
  s.source       = {  :path => '.'  }
  s.source_files  = "CountryPickerView/**/*.{swift,xib}"
  s.resource_bundles = {
    'CountryPickerView' => ['CountryPickerView/Assets/CountryPickerView.bundle/*']
  }

end
