//
//  GPXParser.swift
//  Topomapper
//
//  Created by Derek Chai on 21/06/2024.
//

import Foundation
import CoreLocation

class GPXParser: NSObject, XMLParserDelegate {
    
    
    // MARK: - Exposed Methods
    
    /// Parses a GPX file from the given URL, extracting coordinate and
    /// elevation data into an array of `LocationCoordinate3D`s.
    func parsedGPXFile(at url: URL) throws(GPXParsingError) -> [RoutePoint] {
        guard let parser = XMLParser(contentsOf: url) else {
            throw GPXParsingError.failedToCreateXMLParser
        }
        
        parser.delegate = self
        
        let successfullyParsed: Bool = parser.parse()
        
        guard successfullyParsed else {
            throw GPXParser.GPXParsingError.failedToParseGPX
        }
        
        return points
    }
    
    
    // MARK: - Internal Variables
    
    private var points: [RoutePoint] = []
    
    private var currentElement: String = ""
    private var currentLatitude: Double?
    private var currentLongitude: Double?
    private var currentElevation: Double?
    
    
    // MARK: - Delegate Methods
    
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
        
        if let currentLatitude, let currentLongitude, let currentElevation {
            let point = RoutePoint(
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
    
    enum GPXParsingError: Error {
        case failedToParseGPX
        case failedToCreateXMLParser
    }
}
