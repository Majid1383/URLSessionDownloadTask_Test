//
//  SubTopicViewController.swift
//  URLSessionDownloadTask_Test
//
//  Created by AbdulMajid Shaikh on 16/11/24.
//

import UIKit

class SubTopicViewController: UIViewController {
    
    var topic: TopicModel?
    var path : String = ""
    var imageURL : String = ""
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        if let topic = topic {
            print("DEBUG: Topic received - \(topic.name), Subtopics: \(topic.subTopic)")
               } else {
                   print("DEBUG: No topic received!")
               }
    }
    
    func registerCells(){
        let nib = UINib(nibName: "SubTopicTableViewCell", bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "SubTopicTableViewCell")
    }
}

//MARK: TABLEVIEW FUNCTION'S
extension SubTopicViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic?.subTopic.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageVC = ImageViewController(nibName: "ImageViewController", bundle: nil)
        if let subtopic = topic?.subTopic[indexPath.row] {
            imageVC.imageName = subtopic.replacingOccurrences(of: "subtopic-", with: "image-") + ".jpg"
            self.navigationController?.pushViewController(imageVC, animated: true)
        }else {
           print("DEBUG: Error in subtopic!")
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.frame.origin.x = -cell.frame.width
        UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            cell.frame.origin.x = 0
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "SubTopicTableViewCell", for: indexPath) as!   SubTopicTableViewCell
        
        guard let subtopic = topic?.subTopic else {
            print("DEBUG: subtopic value is nil")
            return cell
        }
        
        cell.lblSubtopics.text = subtopic[indexPath.row]
        setupUIView(for: cell.myView)
        cell.lblSubtopics.textColor = GlobalFunctions.randomNeonColor()
        return cell
    }
      
}


extension SubTopicViewController {
    func setupUIView(for view: UIView){
        view.layer.borderWidth = 3.0
        view.layer.borderColor = GlobalFunctions.randomNeonColor().cgColor
        view.layer.cornerRadius = 30.0
    }
}

