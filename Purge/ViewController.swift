//
//  ViewController.swift
//  Purge
//
//  Created by Chris Rodriguez on 7/27/24.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!

    private let photoQueueManager = PhotoQueueManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite) { PHAuthorizationStatus in
            print("Got access");
            
            let nextImage = self.photoQueueManager.getNextImage()
            self.setMainImage(image: nextImage)
        }
    }

    @IBAction func deleteButton(_ sender: UIButton) {
        let imageToDelete = photoQueueManager.currentImage
        if let imageToDelete = imageToDelete {
            PHPhotoLibrary.shared().performChanges({
                var assetsToDelete = [PHAsset]()
                assetsToDelete.append(imageToDelete.asset)
                PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
            }, completionHandler: { (success: Bool, error2: Error?) in
                if (success) {
                    // TODO: Determine why this doesn't work without running on main thread.
                    DispatchQueue.main.async {
                        let nextImage = self.photoQueueManager.getNextImage()
                        self.setMainImage(image: nextImage)
                    }
                }
            })
        }

    }
    
    @IBAction func skipButton(_ sender: UIButton) {
        let nextImage = self.photoQueueManager.getNextImage()
        self.setMainImage(image: nextImage)
    }
    
    private func setMainImage(image: UIImage) {
        DispatchQueue.main.async {
            self.mainImage.image = image
        }
    }
}
