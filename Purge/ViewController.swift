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
    var displayedAsset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite) { PHAuthorizationStatus in
            print("Got access");
            
            self.showRandomImage()
        }
    }

    @IBAction func deleteButton(_ sender: UIButton) {
        let assetToDelete = self.displayedAsset
        if let assetToDelete = assetToDelete {
            PHPhotoLibrary.shared().performChanges({
                var assetsToDelete = [PHAsset]()
                assetsToDelete.append(assetToDelete)
                PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
            }, completionHandler: { (success: Bool, error2: Error?) in
                if (success) {
                    print("Deleted!")
                    self.showRandomImage()
                } else {
                    print("Not deleted")
                }
            })
        }

    }
    
    @IBAction func skipButton(_ sender: UIButton) {
        self.showRandomImage()
    }
    
    func showRandomImage() {
        let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .exact
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = true
        requestOptions.isNetworkAccessAllowed = true

        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        let manager: PHImageManager = PHImageManager.default()
        
        let randomIndex = Int.random(in: 0..<fetchResult.count)
        let asset = fetchResult.object(at: randomIndex)
        self.displayedAsset = asset
        print("Total photos: \(fetchResult.count)")

        DispatchQueue.main.async {
            manager.requestImage(
                for: asset,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .default,
                options: requestOptions,
                resultHandler: { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                    if let image = image {
                        self.mainImage.image = image
                        print("set image")
                    }
                })
        }
    }
    
}

// TODO
// Make the image zoomable
// Add a favorite button to add to favorites (https://stackoverflow.com/questions/31689112/about-implementing-photo-favorites-heart-button-in-swift)
// Preload upcoming image to reduce wait time
// Check for state where user doesn't allow access to images
// Check for state where no more images are available
// Add deleted images to a pending queue and then perform a single batch deletion at the end
// Gestures
// Swipe up to see x images before and after displayed image, and maybe allow actions to be performed on those (i.e. tapping on one makes it the main image (nice and fluid) or bulk selection (not as nice))
// Undo button / gesture

// Maybe do
// Migrate to Swift UI
