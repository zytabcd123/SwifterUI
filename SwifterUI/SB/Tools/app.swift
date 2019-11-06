//
//  app.swift
//  apc
//
//  Created by ovfun on 2017/1/3.
//  Copyright © 2017年 @天意. All rights reserved.
//

import Foundation
import Photos.PHPhotoLibrary
public struct app {}


// MARK: - info.plist
extension app {
    
    public static var displayName: String? {
        // http://stackoverflow.com/questions/28254377/get-app-name-in-swift
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    
    public static var bundleID: String? {
        return Bundle.main.bundleIdentifier
    }

    public static var version: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    public static var build: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
    
    public static var versionCode: String {
        return app.version?.replacing(".", with: "") ?? ""
    }
    
    public static var versionDes: String? {
        guard let v = app.version else {
            return nil
        }
        return v
//        return "version " + v + "  (build \(b))"
    }
}


// MARK: - Device
extension app {

    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    public static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    public static var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    public static var currentDevice: UIDevice {
        return UIDevice.current
    }
    
    public static var deviceModel: String {
        return UIDevice.current.model
    }
    
    public static var deviceName: String {
        return UIDevice.current.name
    }
    
    public static var deviceOrientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    public static var isRunningOnSimulator: Bool {
        // http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
    
    public static var isiPhoneX: Bool {

        return UIScreen.h >= 812
    }
}

extension app {
    
    public static var isInDebuggingMode: Bool {
        // http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    public static var keyWindow: UIView? {
        return UIApplication.shared.keyWindow
    }
    
    public static var rootViewController: UIViewController? {
        get {
            return UIApplication.shared.keyWindow?.rootViewController
        }
        set {
            UIApplication.shared.keyWindow?.rootViewController = newValue
        }
    }
}

extension app {

    
    /// 当用户使用系统截屏的时候回调
    public static func didTakeScreenShot(_ action: @escaping () -> ()) {
        // http://stackoverflow.com/questions/13484516/ios-detection-of-screenshot
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: mainQueue) { notification in
            action()
        }
    }
}

extension app {
    
    public static var isPhotoLibraryDenied: Bool {
        return PHPhotoLibrary.authorizationStatus() != .denied
    }
    
    public static var isCameraDenided: Bool {
        let mediaType = AVMediaType.video
        let authStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        return authStatus != .denied
    }
    
    //检测用户是否拒绝授权，false表示用户拒绝定位授权，需要提示用户去设置，否则执行定位
    public static var isLocationDenied: Bool {
        
        return CLLocationManager.authorizationStatus() != .denied
    }
}
