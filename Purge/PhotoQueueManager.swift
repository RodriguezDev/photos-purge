//
//  PhotoQueueManager.swift
//  Purge
//
//  Created by Chris Rodriguez on 7/28/24.
//

import Collections
import Foundation
import Photos
import UIKit

struct CandidatePhoto {
    var image: UIImage
    var asset: PHAsset
}

class PhotoQueueManager {
    
    var currentImage: CandidatePhoto?
    
    private var imageQueue: Deque<CandidatePhoto> = []
    
    func getNextImage() -> UIImage {
        fetchRandomImage()
        self.currentImage = self.imageQueue.popFirst()!
        return self.currentImage!.image
    }

    private func fetchRandomImage() {
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        let manager: PHImageManager = PHImageManager.default()
        
        let randomIndex = Int.random(in: 0..<fetchResult.count)
        print(randomIndex)
        let asset = fetchResult.object(at: randomIndex)
        print("Total photos: \(fetchResult.count)")
        
        let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .exact
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = true
        requestOptions.isNetworkAccessAllowed = true

        manager.requestImage(
            for: asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .default,
            options: requestOptions,
            resultHandler: { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                if let image = image {
                    self.imageQueue.append(CandidatePhoto(image: image, asset: asset))
                } else {
                }
            })
    }
}
