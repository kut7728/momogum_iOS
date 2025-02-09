//
//  GalleryPickerViewModel.swift
//  momogum
//
//  Created by 조승연 on 1/17/25.
//

import Photos
import SwiftUI

class GalleryPickerViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    @Published var isPermissionGranted: Bool = false
    @Published var showPermissionAlert: Bool = false

    init() {
        checkPermission()
    }

    func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        DispatchQueue.main.async {
            self.isPermissionGranted = (status == .authorized || status == .limited)
            if self.isPermissionGranted {
                self.fetchImages()
            }
        }
    }

    func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.isPermissionGranted = (status == .authorized || status == .limited)
                if self.isPermissionGranted {
                    self.fetchImages()
                } else {
                    self.showPermissionAlert = true
                }
            }
        }
    }

    func fetchImages() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        let imageManager = PHCachingImageManager()
        let targetSize = CGSize(width: 400, height: 400)
        
        DispatchQueue.main.async {
            self.images.removeAll()
        }

        fetchResult.enumerateObjects { asset, _, _ in
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.deliveryMode = .highQualityFormat

            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        self.images.append(image)
                    }
                }
            }
        }
    }
}
