#
# Be sure to run `pod lib lint NKJPhotoSliderController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "NKJPhotoSliderController"
  s.version          = "0.5.1"
  s.summary          = "NKJPhotoSliderController can a simple photo slider and delete slider with swiping."
  s.homepage         = "https://github.com/nakajijapan/NKJPhotoSliderController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "nakajijapan" => "pp.kupepo.gattyanmo@gmail.com" }
  s.source           = { :git => "https://github.com/nakajijapan/NKJPhotoSliderController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nakajijapan'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'NKJPhotoSliderController' => ['Pod/Assets/*.png']
  }

  s.dependency 'SDWebImage'
end
