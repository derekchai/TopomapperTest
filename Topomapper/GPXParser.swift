//
//  GPXParser.swift
//  Topomapper
//
//  Created by Derek Chai on 21/06/2024.
//

import Foundation
import CoreLocation

class GPXParser: NSObject, XMLParserDelegate {
    private var points: [GPXPoint] = []
    
    private var currentElement: String = ""
    private var currentLatitude: Double?
    private var currentLongitude: Double?
    private var currentElevation: Double?
    
    func parseGPX(fileURL: URL) throws -> [GPXPoint] {
        if let parser = XMLParser(contentsOf: fileURL) {
            parser.delegate = self
            
            // parser.parse() returns true if the parsing operation succeeds, or
            // false otherwise.
            guard parser.parse() else {
                throw GPXParser.ParsingError.unableToParseGPX
            }
        }
        
        return points
    }
    
    // MARK: - XMLParserDelegate methods
    
    // didStartElement
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        currentElement = elementName
        
        guard currentElement == "trkpt" else { return }
        
        guard let latitudeString = attributeDict["lat"],
              let longitudeString = attributeDict["lon"] else {
            return
        }
        
        if let latitude = Double(latitudeString),
           let longitude = Double(longitudeString) {
            currentLatitude = latitude
            currentLongitude = longitude
        }
    }
    
    // foundCharacters
    func parser(
        _ parser: XMLParser,
        foundCharacters string: String
    ) {
        guard currentElement == "ele" else { return }
        
        guard let elevation = Double(
            string.trimmingCharacters(in: .whitespacesAndNewlines)
        ) else { return }
                
        currentElevation = elevation
    }
    
    // didEndElement
    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        guard elementName == "trkpt" else { return }
        
        if let currentLatitude, let currentLongitude {
            let point = GPXPoint(
                latitude: currentLatitude,
                longitude: currentLongitude,
                elevation: currentElevation
            )
            
            points.append(point)
        }
        
        currentLatitude = nil
        currentLongitude = nil
        currentElevation = nil
    }
    
    // parseErrorOccurred
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error parsing GPX: \(parseError.localizedDescription)")
    }
    
    // MARK: - Errors
    
    enum ParsingError: Error {
        case unableToParseGPX
    }
}
