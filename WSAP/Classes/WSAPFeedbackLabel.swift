//
//  WSAPFeedbackLabel.swift
//  iChange-common
//
//  Created by James Kizer on 1/15/18.
//

import UIKit
import ResearchSuiteExtensions

open class WSAPFeedbackLabel: RSLabel {

    override open var defaultFont: UIFont {
        return RSFonts.computeFont(startingTextStyle: UIFont.TextStyle.title3, defaultSize: 20.0, typeAdjustment: 24.0)
    }

}
