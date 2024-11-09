//
//  ContentView.swift
//  DavidWeather
//
//  Created by David C on 2024-11-08.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var locationManager = MyLocationManager()
    @StateObject var weatherManager = WeatherManager()
    @State var locationName = ""   // search locations of interest
    @State var selection : MKMapItem?  // selected Marker
    @State var route : MKRoute?   // route to selected marker


    var body: some View {
        Text("Weather Application").font(.title)
     
        Grid{
            GridRow{
                Text("Latitude")
                Text(String(locationManager.location.coordinate.latitude))
            }
            GridRow{
                Text("Longitude")
                Text(String(locationManager.location.coordinate.longitude))
            }
        }
        
        Button("Get Weather"){
            
            weatherManager.getWeather(
                latitude: "40.741895",
                longitude: "-73.989308")
//            weatherManager.getWeather(
//                latitude: String(locationManager.location.coordinate.latitude),
//                longitude: String(locationManager.location.coordinate.longitude))
        }
    }
}

#Preview {
    ContentView()
}
