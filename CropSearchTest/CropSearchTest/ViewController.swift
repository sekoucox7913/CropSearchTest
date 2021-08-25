//
//  ViewController.swift
//  CropSearchTest
//
//  Created by a on 2021/8/24.
//

import UIKit

func getFontSize(_ defaultValue: CGFloat) -> CGFloat{
    let width = UIScreen.main.bounds.width
    return (CGFloat)(width / 375.0 * defaultValue)
}

class ViewController: UIViewController {
    
    private var datas  = [["id": 0, "name": "Surrounding Areas/Adjacent Activites", "state": false, "selectedState": -1],
                    ["id": 1, "name": "Building Grounds", "state": false, "selectedState": -1],
                    ["id": 2, "name": "Building Structure", "state": false, "selectedState": -1],
                    ["id": 3, "name": "Water System", "state": false, "selectedState": -1],
                    ["id": 4, "name": "Other", "state": false, "selectedState": -1]]
    
    lazy var tableView : UITableView = {[unowned self] in
        let tableView = UITableView()
        
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.backgroundColor = UIColor.clear
        
        //tableView.rowHeight = 200
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = true
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints{ make in
            make.width.height.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        
        tableView.layoutIfNeeded()
    }

    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.setData(data: datas[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let state = datas[indexPath.row]["state"] as! Bool
        
        return state ? 130.0 : 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .gray
        let label = UILabel(frame: view.frame)
        label.text = "Areas of Observation - Please note conern(s) if any, as well as corrective action(s)"
        label.textColor = .white
        
        view.addSubview(label)
        label.snp.makeConstraints{ make in
            make.height.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
        }
        label.layoutIfNeeded()
        
        return view
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension ViewController: CustomTableViewCellDelegate{
    func opened(_ id: Int) {
        datas[id]["state"] = true
        self.tableView.reloadData()
    }
    
    func closed(_ id: Int) {
        datas[id]["state"] = false
        self.tableView.reloadData()
    }
    
    
}
