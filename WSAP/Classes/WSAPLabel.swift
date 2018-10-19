//
//  WSAPLabel.swift
//  iChange-common
//
//  Created by James Kizer on 1/15/18.
//

import UIKit
import ResearchSuiteExtensions

open class WSAPLabel: RSLabel {

    override open var defaultFont: UIFont {
        return RSFonts.computeFont(startingTextStyle: UIFont.TextStyle.title1, defaultSize: 28.0, typeAdjustment: 30.0)
    }

}
