//
//  CacheService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 21.10.2023.
//

import Foundation
import StorageService

final class LocalStorageService {
    
    static var `default` = LocalStorageService()
    
    typealias JPEGData = Data
    
    enum CacheServiceError: Error {
        case fileDoesntExists
        case fileIsEmpty
        case badDirectoryURL
        case failedWhileWritingToFile
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
    
    // MARK: Post related methods
  
    func writePostImageCache(from postIDWithImageData: (postID: String, jpegData: JPEGData)) throws {
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
    
    func readPostImageCache(from postID: String) throws -> Data {
        
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
    
    // MARK: Avatar related methods
    
    func writeUserAvatarCache(userID: String, jpegData: JPEGData) throws {
        guard let avatarCacheFolderURL = self.avatarCacheFolderURL else {
            print("postImageCacheFolderURL == nil")
            throw CacheServiceError.badDirectoryURL
        }
        let cachedImages = try fileManager.contentsOfDirectory(atPath: avatarCacheFolderURL.path())
        let pathToFile = avatarCacheFolderURL.appendingPathComponent(userID, conformingTo: .fileURL)
        if !cachedImages.contains(where: { $0 == userID }) {
            fileManager.createFile(atPath: pathToFile.path(), contents: jpegData)
        } else {
            do {
                try jpegData.write(to: pathToFile)
                print("New Avatar successfully written to file at: \(pathToFile)")
            } catch {
                print("Failed to write new avatar to file.")
                throw CacheServiceError.failedWhileWritingToFile
            }
        }
    }
    
    func readUserAvatarCache(from userID: String) throws -> Data {
        guard let avatarCacheFolderURL = self.avatarCacheFolderURL else {
            print("avatarCacheFolderURL == nil")
            throw CacheServiceError.badDirectoryURL
        }
        let cachedAvatarURL = avatarCacheFolderURL.appendingPathComponent(userID, conformingTo: .fileURL)
        guard fileManager.fileExists(atPath: cachedAvatarURL.path()) else {
            throw CacheServiceError.fileDoesntExists
        }
        guard let data = fileManager.contents(atPath: cachedAvatarURL.path()) else {
            throw CacheServiceError.fileIsEmpty
        }
        return data
    }
}
