# Merakly

#### *Merakly is a advertising library which is based on surveys and written in Swift.*

## Getting Started

### Installation with CocoaPods

Add this line to your Podfile `pod 'Merakly'` and then do `pod install`.

> Note: If you get `[!] Unable to find a specification for 'Merakly'` please do `pod update` before installing. 

## Usage

### Initalization

First you have to configure Merakly with your API Key and your App Secret in your AppDelegate. Call this method in `didFinishLaunchingWithOptions`.

```swift
import Merakly

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
    Merakly.configure(withApiKey: "YOUR_API_KEY", andAppSecret: "YOUR_APP_SECRET")
        
    return true
    
}

```

### Using `MRKBannerView`

`MRKBannerView` is a subclass of `UIView` and only component you need to use for showing beatiful survey based ads. There is two way to use `MRKBannerView` in your applications.

#### 1) Using XIB file

Drag-and-drop a `UIView` into your `UIViewController` and set its class as `MRKBannerView`. Remember that, `MRKBannerView` 's height should be 80 and it has to use full width of screen.

![screenshot1](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/18363/3822969/rATDoHo1QjrhH1s/upload.png)

You can customize some options in Attributes Inspector. Like if banner view should be closable or its backgroung color etc.

![screenshot2](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/18363/3822969/OXG6QEVegIqvRh2/upload.png)

After that, connect your IBOutlet for `MRKBannerView`.

```swift 
@IBOutlet weak var bannerView: MRKBannerView! 
```
When you ready to show some beatiful survey based ads call `loadCampaign` method.

```swift
bannerView.delegate = self
bannerView.loadCampaign()
```

#### 1) Programmaticaly

If you dont want to use Interface Builder, you can add `MRKBannerView` in the code. It is simple as adding any `UIView`.

```swift
let bannerViewLocation = CGPoint(x: 0, y: view.frame.size.height - 80)
bannerView = MRKBannerView(point: bannerViewLocation, andCloseOption: .notClosable) //Set location of banner view and its close option.
bannerView?.bannerViewBackgroundColor = .purple //Set background color of banner view.
bannerView?.bannerViewTextColor = .orange //Set text color of banner view.
view.addSubview(bannerView!)
```

Again when you ready to show some beatiful survey based ads call `loadCampaign` method.

```swift
bannerView?.delegate = self
bannerView?.loadCampaign()
```

## Advanced Usage

When you add `MRKBannerView` into your `UIViewController`, you really don't worry about the rest. Merakly will handle all if you set it as non-closable. If you set it as closable, you need to handle removing `MRKBannerView` from its superview. There are some delegate methods for you to do this actions.

```swift
optional func noCampaignToLoad() //Fires when there is no campaign to show. You can remove banner view when this delegate fires.
```
```swift
optional func campaignLoaded() //Fires when a campaign loaded and showed to user.
```
```swift
optional func campaignSkipped() //Fires when user skipped the campaign.
```
```swift
optional func closeAction() // Fires when user wants to close banner view. This action is available if banner view is closable.
```
```swift
optional func refreshAction() // Fires when user wants to refresh the campaign and see the other campaign. This action is available if banner view is not closable.
```
```swift
optional func adLoaded() // Fires when ad loaded and showed to user in after answering the question in banner view or after the survey.
```
```swift
optional func surveyStarted() // Fires when survey started.
```
```swift
optional func surveyCanceled() // Fires when user cancelled the survey.
```
```swift
optional func surveyEnded() // Fires when user completed the survey.
```

