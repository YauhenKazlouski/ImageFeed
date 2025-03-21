//
//  UIBlocingProgressHUD.swift
//  ImageFeed
//
//  Created by PandaPo on 15.03.25.
//

import UIKit
import ProgressHUD

final class UIBlocingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
