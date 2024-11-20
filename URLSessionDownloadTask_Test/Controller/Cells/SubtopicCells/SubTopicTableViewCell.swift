//
//  SubTopicTableViewCell.swift
//  URLSessionDownloadTask_Test
//
//  Created by AbdulMajid Shaikh on 17/11/24.
//

import UIKit

class SubTopicTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblSubtopics: UILabel!
    @IBOutlet weak var myView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblSubtopics.text = "" 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
