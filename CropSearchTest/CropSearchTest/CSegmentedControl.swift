//
//  CSegmentedControl.swift
//  CropSearchTest
//
//  Created by a on 2021/8/25.
//

import UIKit

@IBDesignable public class CSegmentedControl: UIControl {
    
    fileprivate var labels = [UILabel]()
    private var thumbView = UIView()
    
    
    public var items: [String] = ["Item 1"] {
        didSet {
            if items.count > 0 { setupLabels() }
        }
    }
    
    public var selectedIndex: Int = -1 {
        didSet { displayNewSelectedIndex() }
    }
    
    public var selectedColors: [UIColor] = [.white]
    
    @IBInspectable public var selectedLabelColor: UIColor = UIColor.black {
        didSet { setSelectedColors() }
    }
    
    @IBInspectable public var unselectedLabelColor: UIColor = UIColor.black {
        didSet { setSelectedColors() }
    }
    
    @IBInspectable public var font: UIFont? = UIFont.systemFont(ofSize: 12) {
        didSet { setFont() }
    }
    
    public var padding: CGFloat = 0 {
        didSet { setupLabels() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = frame.height / 2
        
        backgroundColor = UIColor.clear
        setupLabels()
        insertSubview(thumbView, at: 0)
        
    }
    
    private func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        for index in 1...items.count {
            let label = UILabel()
            label.text = items[index - 1]
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = font
            label.textColor = unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(labels, mainView: self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if labels.count > 0 {
            if selectedIndex >= 0 {
                let label = labels[selectedIndex]
                label.textColor = selectedLabelColor
                thumbView.frame = CGRect(x: label.frame.minX, y: label.frame.minY + 1, width: label.frame.width, height: label.frame.height - 2)// label.frame
                
                thumbView.backgroundColor = thumbColor()
                thumbView.layer.cornerRadius = 8
                displayNewSelectedIndex()
            }
            
        }
        
        self.layer.cornerRadius = 8
//        self.roundCorners(corners: .allCorners, radius: 8)
            
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex : Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    private func displayNewSelectedIndex() {
        if selectedIndex < 0{
            return
        }
        
        for (_, item) in labels.enumerated() {
            item.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        UIView.animate(withDuration: 0.3, delay: 0.0, /*usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8,*/ animations: {
            self.thumbView.frame = CGRect(x: label.frame.minX, y: label.frame.minY + 1, width: label.frame.width, height: label.frame.height - 2)//label.frame
            self.thumbView.backgroundColor = self.thumbColor()
            self.thumbView.layer.shadowColor = UIColor.black.cgColor
            self.thumbView.layer.shadowRadius = 1
            self.thumbView.layer.shadowOpacity = 0.2
            self.thumbView.clipsToBounds = false
        }, completion: nil)
    }
    
    private func addIndividualItemConstraints(_ items: [UIView], mainView: UIView) {
        for (index, button) in items.enumerated() {
            button.topAnchor.constraint(equalTo: mainView.topAnchor, constant: padding).isActive = true
            button.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -padding).isActive = true

            ///set leading constraint
            if index == 0 {
                /// set first item leading anchor to mainView
                button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: padding).isActive = true
            } else {
                let prevButton: UIView = items[index - 1]
                let firstItem: UIView = items[0]
                
                /// set remaining items to previous view and set width the same as first view
                button.leadingAnchor.constraint(equalTo: prevButton.trailingAnchor, constant: padding).isActive = true
                button.widthAnchor.constraint(equalTo: firstItem.widthAnchor).isActive = true
            }

            ///set trailing constraint
            if index == items.count - 1 {
                /// set last item trailing anchor to mainView
                button.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -padding).isActive = true
            } else {
                /// set remaining item trailing anchor to next view
                let nextButton: UIView = items[index + 1]
                button.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -padding).isActive = true
            }
        }
    }
    
    private func setSelectedColors() {
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor()
    }
    
    private func setFont() {
        for item in labels {
            item.font = font
        }
    }
    
    private func thumbColor() -> UIColor{
        if selectedIndex >= 0 {
            if selectedColors.count > selectedIndex{
                return selectedColors[selectedIndex]
            }
        }
        return .white
    }
    
    private func roundCorners(corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
