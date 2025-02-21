import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class FetchLocationEvent extends CustomerEvent {}

class PickImageEvent extends CustomerEvent {}

class SaveCustomerEvent extends CustomerEvent {
  final String fullName;
  final String mobileNo;
  final String email;
  final String address;
  final double latitude;
  final double longitude;
  final String geoAddress;
  final String customerImage;

  SaveCustomerEvent({
    required this.fullName,
    required this.mobileNo,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.geoAddress,
    required this.customerImage,
  });

  @override
  List<Object> get props => [
    fullName,
    mobileNo,
    email,
    address,
    latitude,
    longitude,
    geoAddress,
    customerImage,
  ];
}