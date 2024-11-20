//
//  DownloadCellTableViewCell.swift
//  URLSessionDownloadTask_Test
//
//  Created by AbdulMajid Shaikh on 17/11/24.
//

import UIKit

class DownloadCellTableViewCell: UITableViewCell {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblTopic: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblPercent.text = ""
        setupUIView(for: myView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setupUIView(for view: UIView){
        view.layer.borderWidth = 3.0
        view.layer.borderColor = GlobalFunctions.randomNeonColor().cgColor
        view.layer.cornerRadius = 30.0
    }
    
}
