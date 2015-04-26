# NKJPhotoSliderController

[![Version](https://img.shields.io/cocoapods/v/NKJPhotoSliderController.svg?style=flat)](http://cocoapods.org/pods/NKJPhotoSliderController)
[![License](https://img.shields.io/cocoapods/l/NKJPhotoSliderController.svg?style=flat)](http://cocoapods.org/pods/NKJPhotoSliderController)
[![Platform](https://img.shields.io/cocoapods/p/NKJPhotoSliderController.svg?style=flat)](http://cocoapods.org/pods/NKJPhotoSliderController)

NKJPhotoSliderController can a simple photo slider and delete slider with swiping.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NKJPhotoSliderController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NKJPhotoSliderController"
```

## Use

```
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
NKJPhotoSliderController *slider = [[NKJPhotoSliderController alloc] initWithImageURLs:self.images];
slider.index = indexPath.row;
[self presentViewController:slider animated:YES completion:nil];
}
````

## Author

nakajijapan, pp.kupepo.gattyanmo@gmail.com

## License

NKJPhotoSliderController is available under the MIT license. See the LICENSE file for more info.
