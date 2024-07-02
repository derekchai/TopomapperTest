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
    
    private var previousLatitude: Double?
    private var previousLongitude: Double?
    private var previousElevation: Double?
    
    private var currentLatitude: Double?
    private var currentLongitude: Double?
    private var currentElevation: Double?
    
    private var distanceFromStart: Double = 0
    private var distanceFromPreviousCoordinate: Double = 0
    
    
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
        
        guard let currentLatitude, let currentLongitude, let currentElevation else {
            return
        }
        
        // If this is not the first trkpt...
        if let previousLatitude, let previousLongitude, let previousElevation {
            let previousCoordinate = CLLocation(
                latitude: previousLatitude,
                longitude: previousLongitude
            )
            
            let currentCoordinate = CLLocation(
                latitude: currentLatitude,
                longitude: currentLongitude
            )
            
            distanceFromPreviousCoordinate = previousCoordinate
                .distance(from: currentCoordinate)
            
            distanceFromStart += distanceFromPreviousCoordinate
            
            let grade: Double
            
            if distanceFromPreviousCoordinate > 0 {
                grade = (currentElevation - previousElevation) / distanceFromPreviousCoordinate
            } else {
                grade = 0
            }
            
            let point = RoutePoint(
                latitude: currentLatitude,
                longitude: currentLongitude,
                elevation: currentElevation,
                distanceFromStart: distanceFromStart,
                grade: grade
            )
            
            points.append(point)
            
        // If this is the first trkpt...
        } else {
            let point = RoutePoint(
                latitude: currentLatitude,
                longitude: currentLongitude,
                elevation: currentElevation,
                distanceFromStart: 0,
                grade: 0
            )
            
            points.append(point)
        }
        
        self.previousLatitude = currentLatitude
        self.previousLongitude = currentLongitude
        self.previousElevation = currentElevation
        
        self.currentLatitude = nil
        self.currentLongitude = nil
        self.currentElevation = nil
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
