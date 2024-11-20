//
//  ViewController.swift
//  URLSessionDownloadTask_Test
//
//  Created by AbdulMajid Shaikh on 16/11/24.
//

import UIKit

class TopicViewContoller: UIViewController{

    var isAllFilesDownloaded : Bool = false
    var isTotalProgressCompleted : Int = 0
    
    let topic : [TopicModel] = [
        TopicModel(name: "Topic-1", url: URL(string: APIServices.urlTopic1), subTopic: (1...200).map{"subtopic-\($0)"}),
        TopicModel(name: "Topic-2", url: URL(string: APIServices.urlTopic2), subTopic: (201...400).map{"subtopic-\($0)"}),
        TopicModel(name: "Topic-3", url: URL(string: APIServices.urlTopic3), subTopic: (401...706).map{"subtopic-\($0)"})
    ]
    
    let tableView :  UITableView =  {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isFirstLaunched()
        setupTableView()
        registerCells()
        print("DEBUG: Subtopics",topic[0].subTopic)
    }
    
    func isFirstLaunched(){
        self.isTotalProgressCompleted = UserDefaults.standard.integer(forKey: "totalProgress")
        print("DEBUG: self.isTotalProgressCompleted --> ", self.isTotalProgressCompleted)
    }
    
    func registerCells () {
        let nib = UINib(nibName: "TopicTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TopicTableViewCell")
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.black
    }
}

extension TopicViewContoller : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell", for: indexPath) as! TopicTableViewCell
        cell.lblTopic?.text = topic[indexPath.row].name
        cell.lblTopic.textColor = GlobalFunctions.randomNeonColor()
        setupUIView(for: cell.myView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.frame.origin.x = -cell.frame.width
        UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            cell.frame.origin.x = 0
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("DEBUG: DidSelect is tapped!")
        let downloadVC = DownloadViewController(nibName: "DownloadViewController", bundle: nil)
        downloadVC.delegate = self
        
        if  self.isAllFilesDownloaded == true{
            navigateToSubTopicViewController(indexPath: indexPath)
        }else {
            self.navigationController?.pushViewController(downloadVC, animated: true)
        }
    }
  
}

//MARK: SETUP UIVIEW
func setupUIView(for view: UIView){
    view.layer.borderWidth = 3.0
    view.layer.borderColor = GlobalFunctions.randomNeonColor().cgColor
    view.layer.cornerRadius = 30.0
}


//MARK: Protocol & Delegates
extension TopicViewContoller: DownloadDelegate{
    
    func didCompleteDownload(isCompleted: Bool) {
        print("DEBUG: self.isAllFilesDownloaded",self.isAllFilesDownloaded)
        self.isAllFilesDownloaded = isCompleted
        print("DEBUG: self.isAllFilesDownloaded",self.isAllFilesDownloaded)
    }
}

//MARK: Navigation To ViewController's
extension TopicViewContoller {
    func navigateToSubTopicViewController(indexPath: IndexPath){
        let subtopicVC = SubTopicViewController(nibName: "SubTopicViewController", bundle: nil)
        let selectedTopic = topic[indexPath.row]
        print("DEBUG: Selected topic - \(selectedTopic.name)")
        subtopicVC.topic = selectedTopic
        self.navigationController?.pushViewController(subtopicVC, animated: true)
    }
}


//MARK: Checking FILE path, if available 
extension TopicViewContoller {
    
    func validateFilesExistence() -> Bool {
        guard let unzippedFolderPath = UserDefaults.standard.string(forKey: "unzipped_files") else {
            print("DEBUG: No path saved for unzipped folder.")
            return false
        }
        
        let unzippedFolderURL = URL(fileURLWithPath: unzippedFolderPath)
        
        // Check if the folder still exists
        if FileManager.default.fileExists(atPath: unzippedFolderURL.path) {
            print("DEBUG: Files exist at path: \(unzippedFolderURL.path)")
            return true
        } else {
            print("DEBUG: Files missing at path: \(unzippedFolderURL.path)")
            return false
        }
    }
}

