//
//  GalleryPickerViewModel.swift
//  momogum
//
//  Created by 조승연 on 1/17/25.
//

import Photos
import SwiftUI

class GalleryPickerViewModel: ObservableObject {
    @Published var images: [UIImage?] = []
    @Published var isPermissionGranted: Bool = false
    @Published var showPermissionAlert: Bool = false

    private let imageManager = PHCachingImageManager()
    private let fetchBatchSize = 100  // 한 번에 가져올 이미지 개수
    private var assets: [PHAsset] = []  // PHAsset 리스트 저장
    private var fetchOffset = 0  // 가져온 이미지 개수 (페이징을 위한 오프셋)
    private var isLoading = false  // 중복 로딩 방지

    init() {
        checkPermission()
    }

    func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        DispatchQueue.main.async {
            self.isPermissionGranted = (status == .authorized || status == .limited)
            if self.isPermissionGranted {
                self.fetchAssets()
            }
        }
    }

    func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.isPermissionGranted = (status == .authorized || status == .limited)
                if self.isPermissionGranted {
                    self.fetchAssets()
                } else {
                    self.showPermissionAlert = true
                }
            }
        }
    }

    /// 📌 **최신순으로 PHAsset 리스트 가져오기 (페이징 적용)**
    func fetchAssets() {
        guard !isLoading else { return }  // 중복 로딩 방지
        isLoading = true

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]  // 최신순 정렬
        fetchOptions.fetchLimit = fetchBatchSize
        fetchOptions.includeHiddenAssets = false  // 숨겨진 이미지 제외
        fetchOptions.wantsIncrementalChangeDetails = false  // 성능 최적화

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        DispatchQueue.main.async {
            let newAssets = (self.fetchOffset..<min(self.fetchOffset + self.fetchBatchSize, fetchResult.count))
                .compactMap { fetchResult.object(at: $0) }

            self.assets.append(contentsOf: newAssets)  // 기존 배열에 추가
            self.images.append(contentsOf: Array(repeating: nil, count: newAssets.count))  // Lazy Loading 준비
            self.fetchOffset += newAssets.count  // 오프셋 증가
            self.isLoading = false
        }
    }

    /// 📌 **고화질 이미지 불러오기 (Lazy Loading)**
    func loadImage(at index: Int) {
        guard index < assets.count else { return }

        let asset = assets[index]
        let targetSize = CGSize(width: 1000, height: 1000)
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            DispatchQueue.main.async {
                if let image = image {
                    self.images[index] = image
                }
            }
        }
    }

    /// 🚀 **스크롤이 끝에 도달하면 추가 로드**
    func loadMoreContent() {
        if !isLoading {
            fetchAssets()
        }
    }
}
