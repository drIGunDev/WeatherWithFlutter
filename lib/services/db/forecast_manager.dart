import '../location/types/location.dart';
import '../open_weather_service/weather_service.dart';

abstract interface class ForecastManager {
  Future<void> updateForecast({required Location location, required MeteoForecast forecast});

  Future<MeteoForecast> fetchForecast({required Location location});

  Future<void> deleteForecast({required Location location});

  Future<bool> haveToUpdateForecast({required String locationId, required int updateIntervalSec});
}
