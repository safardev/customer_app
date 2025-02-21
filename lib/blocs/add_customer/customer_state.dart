import 'package:equatable/equatable.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class LocationFetched extends CustomerState {
  final double latitude;
  final double longitude;
  final String geoAddress;

  const LocationFetched({
    required this.latitude,
    required this.longitude,
    required this.geoAddress,
  });

  @override
  List<Object> get props => [latitude, longitude, geoAddress];
}

class ImagePicked extends CustomerState {
  final String imagePath;

  const ImagePicked({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

class CustomerSaved extends CustomerState {}

class CustomerError extends CustomerState {
  final String message;

  CustomerError({required this.message});

  @override
  List<Object> get props => [message];
}