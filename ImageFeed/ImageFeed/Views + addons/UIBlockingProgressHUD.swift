//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Anton Rachkov on 10.08.2026.
//

import Foundation
import UIKit
import ProgressHUD
final class UIBlockingProgressHUD{
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    static func show(){
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
