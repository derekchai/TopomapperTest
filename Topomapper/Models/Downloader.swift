//
//  Downloader.swift
//  Topomapper
//
//  Created by Derek Chai on 23/06/2024.
//

import Foundation
import os

class Downloader {
    
    
    // MARK: - Exposed Methods
    
    /// Downloads a file from the given website and saves it to the local
    /// filesystem.
    /// - Parameters:
    ///   - sourceURL: The URL to download
    ///   - destinationDirectoryURL: The URL of the local directory to which the
    ///   file should be downloaded.
    ///   - filename: The name to save the file locally as, including extension.
    func downloadAndSaveToFilesystem(
        from sourceURL: URL,
        to destinationDirectoryURL: URL,
        filename: String
    ) throws {
        var downloadTaskError: (any Error)?
        
        /// The URL the file will be saved at (including the filename and
        /// extension).
        var savedURL: URL?
        
        let downloadTask = URLSession.shared.downloadTask(with: sourceURL) {
            /// The location of a temporary file where the server’s response is
            /// being stored.
            optionalURL,
            
            /// Response metadata such as HTTP headers and status code.
            optionalResponse,
            
            /// An error if the task failed, or `nil` if it succeeded.
            optionalError in
            
            if let error = optionalError {
                downloadTaskError = error
                return
            }
            
            if let response = optionalResponse as? HTTPURLResponse,
               !(200...299 ~= response.statusCode) {
                downloadTaskError = DownloadingError.badStatusCode(
                    code: response.statusCode
                )
                return
            }
            
            guard let fileURL = optionalURL else {
                downloadTaskError = DownloadingError.failedToDownloadFile
                return
            }
            
            do {
                savedURL = destinationDirectoryURL.appendingPathComponent(filename)
                
                guard let savedURL else {
                    downloadTaskError = DownloadingError.failedToCreateURL
                    return
                }
                
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                
            } catch {
                downloadTaskError = DownloadingError.failedToMoveFile
                return
            }
        } // URLSession.shared.downloadTask()
        
        if let downloadTaskError {
            throw downloadTaskError
        } else {
            downloadTask.resume()
            
            defaultLog.info("Downloaded file from \(sourceURL) to \(savedURL!)!")
        }
    }
    
    
    // MARK: - Internal Variables
    
    private let defaultLog = Logger()
    
    enum DownloadingError: Error {
        case failedToDownloadFile
        case badStatusCode(code: Int)
        case failedToMoveFile
        case failedToCreateURL
    }
}
