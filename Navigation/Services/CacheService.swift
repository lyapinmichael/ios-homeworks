//
//  CacheService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 21.10.2023.
//

import Foundation
import StorageService

final class CacheService {
    
    static var `default` = CacheService()
    
    typealias PostID = String
    typealias JPEGData = Data
    
    enum CacheServiceError: Error {
        case fileDoesntExists
        case fileIsEmpty
        case badDirectoryURL
    }
    
    private var rootFolderURL: URL?
    private var postImageCacheFolderURL: URL?
    private var avatarCacheFolderURL: URL?
    
    private let fileManager = FileManager.default
    
    private init() {
        
        guard let rootFolderURL = try? fileManager.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false) else {
            print("Failed to access Documents folder")
            return
        }
        
        let postImageCacheFolderURL = rootFolderURL.appendingPathComponent("PostImageCache", conformingTo: .folder)
        let avatarCacheFolderURL = rootFolderURL.appendingPathComponent("AvatarCache", conformingTo: .folder)
        
        var isDirectory: ObjCBool = true
        
        if !fileManager.fileExists(atPath: postImageCacheFolderURL.path(), isDirectory: &isDirectory) {
            
            do  {
                try fileManager.createDirectory(at: postImageCacheFolderURL, withIntermediateDirectories: true)
            } catch {
                print(error)
            }
            
        }
        
        if !fileManager.fileExists(atPath: avatarCacheFolderURL.path(), isDirectory: &isDirectory)  {
            
            do  {
                try fileManager.createDirectory(at: avatarCacheFolderURL, withIntermediateDirectories: true)
            } catch {
                print(error)
            }
        }
        
        self.rootFolderURL = rootFolderURL
        self.postImageCacheFolderURL = postImageCacheFolderURL
        self.avatarCacheFolderURL = avatarCacheFolderURL
    }
    
    
  
    func writePostImageCache(from postIDWithImageData: (postID: PostID, jpegData: JPEGData)) throws {
        ///
        /// This method tries to store data (assuming it to be JPEG) in a file, named by an ID of a post, that has
        /// that JPEG attached.
        ///
        guard let postImageCacheFolderURL = self.postImageCacheFolderURL else {
            print("postImageCacheFolderURL == nil")
            throw CacheServiceError.badDirectoryURL
        }
        
        let cachedImages = try fileManager.contentsOfDirectory(atPath: postImageCacheFolderURL.path())
        
        if !cachedImages.contains(where: { $0 == postIDWithImageData.postID }) {
            let newFilePath = postImageCacheFolderURL.appendingPathComponent(postIDWithImageData.postID, conformingTo: .fileURL)
            fileManager.createFile(atPath: newFilePath.path(), contents: postIDWithImageData.jpegData)
        }
    }
    
    func readPostImageCache(from postID: PostID) throws -> Data {
        
        guard let postImageCacheFolderURL = self.postImageCacheFolderURL else {
            print("postImageCacheFolderURL == nil")
            throw CacheServiceError.badDirectoryURL
        }
        
        let cachedImageURL = postImageCacheFolderURL.appendingPathComponent(postID, conformingTo: .fileURL)
        
        guard fileManager.fileExists(atPath: cachedImageURL.path()) else {
            throw CacheServiceError.fileDoesntExists
        }
        
        guard let data = fileManager.contents(atPath: cachedImageURL.path()) else {
            throw CacheServiceError.fileIsEmpty
        }
        
        return data
    }
}
