import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    [GMSServices provideAPIKey: @"AIzaSyDgE5xGH3hYhq-_EJTXS2oThkWzvsSxEf4"];
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
