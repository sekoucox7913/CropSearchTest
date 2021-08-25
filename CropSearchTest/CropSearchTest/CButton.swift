//
//  CButton.swift
//  CropSearchTest
//
//  Created by a on 2021/8/25.
//

import UIKit

public class CButton: UIButton {
    
    public var isOpening = false {
        didSet{
            if isOpening {
                self.setImage(UIImage(systemName: "xmark"), for: .normal)
            }else{
                self.setImage(UIImage(systemName: "plus.bubble"), for: .normal)
            }
        }
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
        self.tintColor = .orange
    }
    
    public func changeState(){
        self.isOpening = !self.isOpening
    }
}

