/*
	David C
	2024-11-08
*/


/*
Idea: Pull 4 popular cities then a button at the end where it prompts the user's location.
 Init : Pull the four values.
 How do I show it in UI?
 
 */
import SwiftUI
import MapKit
/*
 name
 ,region
 ,country
 ,tz_id
 ,localtime
 ,last_updated
	 :String
 ,lat
 ,lon
	 :Double
 ,localtime_epoch
	 :Int

 */
struct CityView: View{
	@Binding var city : Response?
	var body: some View{

		Text("Location").font(.headline)
		Grid(alignment: .leading){
			GridRow{
				Text("Location Information")
				Text("\(city?.location.name ?? "null"), \(city?.location.region ?? "null") \(city?.location.country ?? "null")")
			}

			GridRow{
				Text("Latitude and Longitude")
				Text("Latitude: \(city?.location.lat ?? 0.00). Longitude: \(city?.location.lon ?? 0.00).")
			}

			GridRow{
				Text("Time")
				Text("\(city?.location.localtime ?? "null")")
			}

			GridRow{
				Text("Last Updated")
				Text("\(city?.current.last_updated ?? "null")")
			}
		}.padding(10)

		Text("Weather").font(.headline)
		Grid(alignment: .leading){
			GridRow{
				Text("Temperature")
				Text("\(city?.current.temp_c ?? 0.00) c")
			}

			GridRow{
				Text("Wind (km/h)")
				Text("\(city?.current.wind_kph ?? 0.00) km/h")
			}

			GridRow{
				Text("Humidity")
				Text("\(city?.current.humidity ?? 0)%")
			}
		}.padding(10)
	}
}

struct ContentView:View{
	@StateObject var locationManager=MyLocationManager()
	@StateObject var weatherManager=WeatherManager()
	@State var locationName=""//	search locations of interest
	@State var selection:MKMapItem?//	selected Marker
	@State var route:MKRoute?//	route to selected marker
	@State var specificWeather : Response? = nil

	var body:some View{
		VStack{
		Text("Weather Application").font(.title)
		

		//CityView(city : weatherManager.weatherArray[0].content!)
			CityView(city : $specificWeather)

			Button("Get Weather"){

				if(
					abs(locationManager.location.coordinate.latitude) +
					abs(locationManager.location.coordinate.longitude) >
					1
				){
					weatherManager.getWeather(
						latitude:String(locationManager.location.coordinate.latitude),
						longitude:String(locationManager.location.coordinate.longitude)){ weather in
							specificWeather = weather
					 }
				}
				else{
					weatherManager.getWeather(latitude: "43.6534817",longitude:"-79.3839347"){ weather in
						specificWeather = weather
					}


					print("Specific Weather: ", specificWeather)
					//					NotificationAlert.show(title: "Location Problem", message: "Your latitude and longitude are invalid.")
					//					}
				}
			}

			HStack{
				Button("Get Toronto"){
					weatherManager.getWeather(latitude: weatherManager.toronto._latitude, longitude: weatherManager.toronto._longitude){ weather in
						specificWeather = weather
					}
				}

				Button("Get Vancouver"){
					weatherManager.getWeather(latitude: weatherManager.vancouver._latitude, longitude: weatherManager.vancouver._longitude){ weather in
						specificWeather = weather
					}
				}
			}.padding(10)
			HStack
			{
				Button("Get Montreal"){
					weatherManager.getWeather(latitude: weatherManager.montreal._latitude, longitude: weatherManager.montreal._longitude){ weather in
						specificWeather = weather
					}
				}

				Button("Get Ottawa"){
					weatherManager.getWeather(latitude: weatherManager.ottawa._latitude, longitude: weatherManager.ottawa._longitude){ weather in
						specificWeather = weather
					}
				}
			}
		}
	}
}

#Preview{
	ContentView()
}
