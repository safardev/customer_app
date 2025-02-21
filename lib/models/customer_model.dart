import 'package:hive/hive.dart';
part 'customer_model.g.dart';


@HiveType(typeId: 0)
class Customer {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String mobileNo;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final double latitude;

  @HiveField(5)
  final double longitude;

  @HiveField(6)
  final String geoAddress;

  @HiveField(7)
  final String customerImage;

  Customer({
    required this.fullName,
    required this.mobileNo,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.geoAddress,
    required this.customerImage,
  });
}