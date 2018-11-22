//
//  AppColors.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import UIKit

class AppColors {
    
    // MARK: - Private backing variables
    
    fileprivate var colorUtility: ColorUtility!
    
    // MARK: - Setters and getters
    
    private func getColorUtility() -> ColorUtility {
        if colorUtility != nil {
            return colorUtility
        }
        
        colorUtility = ColorUtility()
        
        return colorUtility
    }

    // MARK: - AppColors methods

    // https://coolors.co/1d3461-1f487e-376996-6290c8-829cbc
    // #829CBC Light
    // #6290C8
    // #376996
    // #1F487E
    // #1D3461 Dark

    // https://coolors.co/134074-13315c-0b2545-8da9c4-eef4ed
    // #EEF4ED
    // #8DA9C4
    // #0B2545
    // #13315C
    // #134074
    // #134074
    func getBackgroundColor() -> UIColor {
        return getColorUtility().hexStringToUIColor(hex: "#EEF4ED")
    }

    func getDarkTextColor() -> UIColor {
        return getColorUtility().hexStringToUIColor(hex: "#0B2545")
    }

    func getLightTextColor() -> UIColor {
        return getColorUtility().hexStringToUIColor(hex: "#EEF4ED")
    }

    func getButtonColor() -> UIColor {
        return getColorUtility().hexStringToUIColor(hex: "#8DA9C4")
    }

    func getBorderColor() -> UIColor {
        return getColorUtility().hexStringToUIColor(hex: "#0B2545")
    }
}
