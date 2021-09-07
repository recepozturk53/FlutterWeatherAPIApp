import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Getlocation{
  late double latitude;
  late double longitude;
  late String city;


  //Get current location
  Future<void> getCurrentLocation() async{
    try{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;

      city = await getCityName(position.latitude, position.longitude);
    }catch(e){
      print(e);
    }
  }

  //Get city name
  Future<String> getCityName(double lat, double lon) async{
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    print(placemark);

    print('city name is: ${placemark[0].subAdministrativeArea}');
    if(placemark[0].locality!.isNotEmpty) return placemark[0].locality!;
    if(placemark[0].subAdministrativeArea!.isNotEmpty) return placemark[0].subAdministrativeArea!;
    return placemark[0].administrativeArea!;
  }

}