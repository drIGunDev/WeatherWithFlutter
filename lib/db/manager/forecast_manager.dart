import '../../services/location/types/location.dart';
import '../../services/open_weather_service/types/forecast_types.dart';

abstract interface class ForecastManager {
  Future<void> updateForecast({required Location location, required ForecastList forecast});

  Future<ForecastList> fetchForecast({required Location location});

  Future<void> deleteForecast({required Location location});

  Future<bool> haveToUpdateForecast({required String locationId, required int updateIntervalSec});
}
