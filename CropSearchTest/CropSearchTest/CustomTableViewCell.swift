//
//  CustomTableViewCell.swift
//  CropSearchTest
//
//  Created by a on 2021/8/25.
//

import UIKit
import SnapKit

protocol CustomTableViewCellDelegate {
    func opened(_ id: Int)
    func closed(_ id: Int)
}
class CustomTableViewCell: UITableViewCell {
    
    private var data : [String : Any] = [String : Any]()
    private var state: Bool = false
    
    var delegate: CustomTableViewCellDelegate?
    
    private lazy var label: UILabel = {
        let v = UILabel()
        v.text = "UILabel"
        
        return v
    }()
    
    private lazy var openButton: CButton = {
        let v = CButton()
        v.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
        return v
    }()
    
    private lazy var segmentedControl: CSegmentedControl = {
        let v = CSegmentedControl()
        v.items = ["Acceptable", "Unacceptable", "N/A"]
        v.selectedLabelColor = .white
        v.backgroundColor = .systemGray4
        v.selectedColors = [.systemGreen, .systemRed, .systemGray2]
        v.font =  UIFont.boldSystemFont(ofSize: getFontSize(5.0))
        //v.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        return v
    }()
    
    private lazy var textField: UITextField = {
        let v = UITextField()
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 8
        v.backgroundColor = .white
        
        return v
    }()
    
    private lazy var topView = UIView()
    private lazy var bottomView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .systemGray6
        
        self.topView.backgroundColor = .clear
        self.bottomView.backgroundColor = .clear
        
        self.contentView.addSubview(topView)
        self.contentView.addSubview(bottomView)
        
        topView.addSubview(label)
        topView.addSubview(openButton)
        topView.addSubview(segmentedControl)
        
        topView.snp.makeConstraints{ make in
            make.top.centerX.equalToSuperview()
            make.height.equalTo(70.0)
            make.width.equalToSuperview().offset(-40)
        }
        topView.layoutIfNeeded()
       
        bottomView.snp.makeConstraints{ make in
            make.top.equalTo(topView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(60.0)
            make.width.equalToSuperview().offset(-40)
        }
        bottomView.layoutIfNeeded()
        
        label.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        label.layoutIfNeeded()
        
        segmentedControl.snp.makeConstraints{ make in
            make.trailing.equalToSuperview()
            make.height.equalTo(36)
            make.top.equalToSuperview().offset(17)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        segmentedControl.layoutIfNeeded()
        
        openButton.snp.makeConstraints{ make in
            make.centerY.height.equalTo(segmentedControl)
            make.width.equalTo(45)
            make.trailing.equalTo(segmentedControl.snp.leading).offset(-15)
        }

        openButton.layoutIfNeeded()
        openButton.isUserInteractionEnabled = true
        bottomView.addSubview(textField)
        
        textField.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.width.centerX.equalToSuperview()
            make.height.equalTo(43.0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnTapped(){
        let id = data["id"] as! Int
        self.state = !self.state
        if self.state {
            delegate?.opened(id)
        }else{
            delegate?.closed(id)
        }
    }
    
    func setData(data: [String : Any]){
        self.data = data
        
        let id = data["id"] as! Int
        if id % 2 != 0 {
            self.contentView.backgroundColor = .systemGray6
        }else{
            self.contentView.backgroundColor = .white
        }
        
        self.state = data["state"] as! Bool
        self.bottomView.isHidden = !state
        self.openButton.isOpening = state
        self.label.text = data["name"] as? String
    }
}
