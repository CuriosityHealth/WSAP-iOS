//
//  WSAPProgressView.swift
//  iChange
//
//  Created by James Kizer on 9/13/18.
//

import UIKit
import SnapKit
import ResearchSuiteExtensions
import ResearchSuiteApplicationFramework

open class WSAPProgressView: UIView {
    
    
    open var progressLabel: UILabel!
    var progressView: UIView!
    var progressViewBackground: UIView!
    var minProgressWidth: CGFloat!
//    var maxWith: CGFloat!
    
    static let percentFormatter: NumberFormatter = {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        return percentFormatter
    }()

    override open func awakeFromNib() {
        
        self.backgroundColor = UIColor.white
        
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
//            make.height.equalToSuperview().offset(-40)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 20
            
        stackView.addArrangedSubview(RSBasicCollectionViewCell.spacingView(axis: .vertical))
        
        self.progressLabel = RSTextLabel()
        self.progressLabel.textAlignment = .center
        self.progressLabel.text = "39 / 50"
        stackView.addArrangedSubview(self.progressLabel)
        self.progressLabel.snp.makeConstraints { (make) in
//            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        
        self.progressViewBackground = UIView()
        self.progressViewBackground.backgroundColor = UIColor.groupTableViewBackground
        self.progressViewBackground.layer.cornerRadius = 10
        
        stackView.addArrangedSubview(self.progressViewBackground)
        self.progressViewBackground.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        
        self.progressView = UIView()
        self.progressView.backgroundColor = UIColor(hexString: "#7ED321")
        self.progressView.layer.cornerRadius = 10
        self.progressView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.progressViewBackground.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        self.minProgressWidth = 20
        
        self.progressView.frame.size.width = self.minProgressWidth
        
        
        stackView.addArrangedSubview(RSBasicCollectionViewCell.spacingView(axis: .vertical))
        
        
//        //we need to understand how wide the view is
//        //first add 20px bounds on either side
//        self.progressView = UIView()
//        self.progressView.backgroundColor = UIColor.green
////        self.progressView.snp.makeConstraints { (make) in
////            make.width.equalTo(self.minProgressWidth)
////        }
//
//        self.progressView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//
//        self.progressView.layer.cornerRadius = 10
//
//        stackView.addArrangedSubview(self.progressView)
        
    }
    
    var progressBarColor: UIColor? {
        didSet {
            if let color = self.progressBarColor {
                self.progressView.backgroundColor = color
            }
            else {
                self.progressView.backgroundColor = self.tintColor
            }
        }
    }

    override open func tintColorDidChange() {
        //if we have not configured the color, set
        super.tintColorDidChange()
        if let _ = self.progressBarColor {
            return
        }
        else {
            self.progressView.backgroundColor = self.tintColor
        }
        
    }
    
    open var progress: Float = 0.0
    
    open func setProgress(_ progress: Float, animated: Bool) {
        
        let maxProgressWidth = self.frame.width - 40

        let width = (maxProgressWidth - self.minProgressWidth) * CGFloat(progress) + self.minProgressWidth
        
//        self.progressView.frame.size.width = width + 100

        if animated {
            UIView.animate(withDuration: 0.5) {
                self.progressView.frame.size.width = width
                self.progressLabel.text = WSAPProgressView.percentFormatter.string(from: NSNumber(floatLiteral: Double(progress)))
            }
        }
        else {
            self.progressView.frame.size.width = width
            self.progressLabel.text = WSAPProgressView.percentFormatter.string(from: NSNumber(floatLiteral: Double(progress)))
        }
        
        
    }
    
}
