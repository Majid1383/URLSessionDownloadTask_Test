//
//  DownloadViewController.swift
//  URLSessionDownloadTask_Test
//
//  Created by AbdulMajid Shaikh on 16/11/24.
//

import UIKit
import ZIPFoundation
import ProgressHUD

protocol DownloadDelegate: AnyObject {
    func didCompleteDownload(isCompleted: Bool)
}

class DownloadViewController: UIViewController{
    
    @IBOutlet weak var myTableView: UITableView!
    
    var downloadTasks: [DownloadTaskInfo] = []
    var progressData: [String: Float] = [:]
    
    weak var delegate : DownloadDelegate? //Delegate
    var currDownload : Int64 = -1
    
    let topic : [TopicModel] = [
        TopicModel(name: "Topic-1", url: URL(string: APIServices.urlTopic1), subTopic: (1...200).map{"subtopic-\($0)"}),
        TopicModel(name: "Topic-2", url: URL(string: APIServices.urlTopic2), subTopic: (201...400).map{"subtopic-\($0)"}),
        TopicModel(name: "Topic-3", url: URL(string: APIServices.urlTopic3), subTopic: (401...706).map{"subtopic-\($0)"})
    ]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        myTableView.dataSource = self
        myTableView.delegate = self
        registerCells()
    }
    
    
    func registerCells () {
        let nib = UINib(nibName: "DownloadCellTableViewCell", bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "DownloadCellTableViewCell")
    }
    
    func startDownload(for row: Int, with urlString: String ) {
        // Add a new task info for the row
        let taskInfo = DownloadTaskInfo(indexPathRow: row, progress: 0.0)
        downloadTasks.append(taskInfo)
        downloadFiles(urlString: urlString)
    }
    
    func downloadFiles(urlString: String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        
        let url = URL(string: urlString)
        let task = session.downloadTask(with: url!)
        task.resume()
    }
    
    func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
    func extractDownloadedZIP(from source: URL, to destination : URL){
        let fileManager = FileManager.default
        
        //Appending a sub-folder for extracting the ZIP file
        let unzippedFolderURL = destination.appendingPathComponent("unzipped_files")
        
        //Check if the unzippedFolderURL exist, if not then creating a new...
        do{
            if !fileManager.fileExists(atPath: unzippedFolderURL.path){
                try fileManager.createDirectory(at: unzippedFolderURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
                
            }
            //Now, Extracting the ZIP file to the above folder
            try fileManager.unzipItem(at: source, to: unzippedFolderURL)
            UserDefaults.standard.set(unzippedFolderURL.path, forKey: "unzippedFolderPath")
            print("DEBUG: Unzipped to unzippedFolderURL.path : --  \(unzippedFolderURL.path)")
        }catch{
            print("DEBUG: Failed to unzip file: \(error)")
        }
    }
    
}

extension DownloadViewController : URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let response = downloadTask.response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Download failed")
            return
        }

        let documentsURL = getDocumentDirectory()
        print("DEBUG: documentsURL",documentsURL)
        let destinationURL = documentsURL.appendingPathComponent(downloadTask.originalRequest?.url?.lastPathComponent ?? "file.zip")

        // Check if the file already exists at the destination
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            UserDefaults.standard.set(documentsURL.path, forKey: "documentsURL.path")
            print("File already exists at: \(destinationURL.path)")
            // Optionally, you can cancel the download task or do something else here.
            downloadTask.cancel()  // This stops the download
            return
        }
        
        //Process with the move and unzip
        do{
            //Move the download files to document directory
            try FileManager.default.moveItem(at: location, to: destinationURL)
            print("DEBUG: File moved to: \(destinationURL.path)")
            
            //MARK: Unzipping the file after moving
            extractDownloadedZIP(from: destinationURL, to: documentsURL)
            
        }catch {
            print("DEBUG: Error handling downloaded file: \(error)")
        }
    }
  
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard let url = downloadTask.originalRequest?.url?.absoluteString else { return }
        
        let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
        if Int64(percentage) != currDownload {
            print("DEBUG: checking percentage % - ", Int(percentage))
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else {return}
                
                self.progressData[url] = percentage
                
                let totalProgress = self.progressData.values.reduce(0,+)
                print("DEBUG:totalProgress ",totalProgress)
                
                if totalProgress == 300 {
                    UserDefaults.standard.set(totalProgress,forKey: "totalProgress")
                    self.isDownloadCompleted()
                    print("DEBUG: Let's go back! Download Completed!")
                }
                
                if let url = URL(string: url), let row = self.findRow(for: url),
                   let cell = self.myTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? DownloadCellTableViewCell {
                    cell.lblPercent.text = "\(Int(percentage))%"
                    } else {
                        print("DEBUG : Facing Cell value issue!")
                    }
            }
            currDownload = Int64(percentage)
        }
    }
    
    private func findRow(for url: URL) -> Int? {
        // Find the row associated with the given URL
        return topic.firstIndex { $0.url == url }
    }
}

extension DownloadViewController :   UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCellTableViewCell", for: indexPath) as! DownloadCellTableViewCell
        
        let labelTitle = topic[indexPath.row].name
        cell.lblTopic.text = "  Download \(labelTitle)"
        cell.lblTopic.textColor = GlobalFunctions.randomNeonColor()
        cell.lblPercent.textColor = GlobalFunctions.randomNeonColor()
  
        return cell
    }
    
    func isDownloadCompleted() {
        let success = true
        self.delegate?.didCompleteDownload(isCompleted: success)
        if success {
            self.navigationController?.popViewController(animated: true)
            print("DEBUG: isDownloadCompleted!")
        }
    }
    

    private func isAllDownloadsComplete() -> Bool {
        // Check if all items in progressData have reached 100%
        return progressData.values.allSatisfy { $0 >= 100 }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("DEBUG : DidSelect!")
        
        switch indexPath.row {
            
        case 0: startDownload(for: 0, with: APIServices.urlTopic1)
        case 1: startDownload(for: 1, with: APIServices.urlTopic2)
        case 2: startDownload(for: 2, with: APIServices.urlTopic3)
            
        default:
            break
        }
    }
}




