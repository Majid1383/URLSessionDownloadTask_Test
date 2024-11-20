//
//  ImageViewController.swift
//  URLSessionDownloadTask_Test
//
//  Created by AbdulMajid Shaikh on 18/11/24.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    var imageName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        do {
            let fileManager = FileManager.default
            let unzippedFolderPath = getDocumentDirectory().appendingPathComponent("unzipped_files") // Replace with your subfolder's name
            
            // Check if the subfolder exists
            if fileManager.fileExists(atPath: unzippedFolderPath.path) {
                let files = try fileManager.contentsOfDirectory(at: unzippedFolderPath, includingPropertiesForKeys: nil)
                print("Files in Unzipped Folder: \(files)")
            } else {
                print("Subfolder does not exist: \(unzippedFolderPath.path)")
            }
        } catch {
            print("Error reading unzipped folder: \(error)")
        }
        
        // Try to load the image from the subfolder
        if let imageName = imageName {
            let imagePath = getDocumentDirectory()
                .appendingPathComponent("unzipped_files") // Replace with your subfolder's name
                .appendingPathComponent(imageName)
            
            print("Image Path: \(imagePath.path)") // Check the full path being generated
            
            // Check if file exists before attempting to load
            if FileManager.default.fileExists(atPath: imagePath.path) {
                if let image = UIImage(contentsOfFile: imagePath.path) {
                    self.myImageView.image = image
                } else {
                    print("Error loading image: \(imageName)")
                }
            } else {
                print("Image file does not exist at path: \(imagePath.path)")
            }
        }
    }
    
    // Helper to get the Documents directory
    func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
