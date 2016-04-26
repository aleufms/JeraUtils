//
//  FontAdditions.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 1/19/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit

public extension UILabel {
    public var substituteFontNameRegular: String {
        get { return self.font.fontName }
        set {
            if self.font.fontName == UIFont.systemFontOfSize(1).fontName {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }

    public var substituteFontNameBold: String {
        get { return self.font.fontName }
        set {
//            if self.font.fontName == UIFont.boldSystemFontOfSize(1).fontName {
            if self.font.fontName == ".SFUIText-Bold" || self.font.fontName == ".SFUIText-Medium" || self.font.fontName == ".SFUIText-SemiBold" ||
            self.font.fontName == "HelveticaNeue-Medium" {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }

    public var substituteFontNameLight: String {
        get { return self.font.fontName }
        set {
            UIFont.italicSystemFontOfSize(12)
            if self.font.fontName == UIFont.italicSystemFontOfSize(1).fontName {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
}

public extension UIFont {

    public static func availableFonts() {

        // Get all fonts families
        for family in UIFont.familyNames() {
            NSLog("\(family)")

            // Show all fonts for any given family
            for name in UIFont.fontNamesForFamilyName(family) {
                NSLog("   \(name)")
            }
        }
    }
}
