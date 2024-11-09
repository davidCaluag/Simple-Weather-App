//
//  WeatherManager.swift
//  DavidWeather
//
//  Created by David C on 2024-11-08.
//

import Foundation

struct Location:Decodable{
    let
        name
        ,region
        ,country
        ,tz_id
        ,localtime
            :String
        ,lat
        ,lon
            :Double
        ,localtime_epoch
            :Int
    
        
  }


struct Response: Decodable{
    let
        location : Location
        ,current : Weather
}



struct Weather : Decodable {
//    var date : Date
//    var maxTemp_c : Int
//    var minTemp_c : Int
//    var avgTemp_c : Int
    let
    temp_c : Double
    ,wind_kph : Double//comment
    ,humidity : Int
	,last_updated : String
}

struct Coordinate {
	let
	_latitude
	,_longitude
	: String
}

struct WeatherInformation{
	var id = UUID()
	var content : Response!
}

//ChatGPT generated API_KEY retrieval
func loadAPIKey() -> String? {
	if let path = Bundle.main.path(forResource: "config", ofType: "plist"),
	   let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
	   let apiKey = dict["API_KEY"] as? String {
		return apiKey
	}
	return nil
}


class WeatherManager : ObservableObject{
	
	private var API_KEY : String?

	private var url : String

    @Published var weather : Response?
	@Published var weatherArray : [Weather] = []
	let toronto : Coordinate = Coordinate(_latitude: "43.6534817", _longitude: "-79.3839347")
	let vancouver : Coordinate = Coordinate(_latitude: "49.2608724", _longitude: "-123.113952")
	let ottawa : Coordinate = Coordinate(_latitude: "45.4208777", _longitude: "-75.6901106")
	let montreal : Coordinate = Coordinate(_latitude: "45.5031824", _longitude: "-73.5698065")

	
//	var weatherArray : [WeatherInformation] = []

    private let jsonDecoder = JSONDecoder()

	init(){
		//super.init()
		if let API_KEY = loadAPIKey(){
			url = "https://api.weatherapi.com/v1/current.json?key=\(API_KEY)&q="
		}else{
			print("API_KEY is not properly working")
			url = "Not working"
		}
	}


    func getWeather(latitude: String, longitude: String, completion: @escaping (Response?) -> Void){
        let newUrl = url + latitude + "," + longitude
        let url = URL(string: newUrl)
        print("Initializing...")
        let task = URLSession.shared.dataTask(with: url!){
            data, response, error in
            
            if let err = error {
                print (#line,"Error : \(err)")
				completion(nil)
            }
            else {
                do {
                    print(String(data:data!,encoding:.utf8)!)
                    let weatherInput = try self.jsonDecoder.decode(Response.self, from: data!)
                    print("Successful: \(weatherInput)")
                    DispatchQueue.main.sync{
						self.weather = weatherInput
						completion(weatherInput)
						//print("Weather: \(self.weather)")
                    }
                }catch{
                    print("\(error)")
					completion(nil)
                    fatalError()
                }
            }
            
        }
        task.resume()
        
    }
}
