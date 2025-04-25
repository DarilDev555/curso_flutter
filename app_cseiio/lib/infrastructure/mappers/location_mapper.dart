import '../../domain/entities/location.dart';
import '../models/api_cseiio/location/location_response_cseiio.dart';

class LocationMapper {
  static Location locationCseiioToEntity(
    LocationResponseCseiio locationCseiio,
  ) {
    return Location(
      id: locationCseiio.id,
      street: locationCseiio.street,
      city: locationCseiio.city,
      state: locationCseiio.state,
      postalCode: locationCseiio.postalCode,
      description: locationCseiio.description,
      latitude: locationCseiio.latitude,
      longitude: locationCseiio.longitude,
      createdAt: locationCseiio.createdAt,
      updatedAt: locationCseiio.updatedAt,
    );
  }
}
