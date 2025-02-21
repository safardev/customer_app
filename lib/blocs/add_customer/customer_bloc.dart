import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/customer_model.dart';
import 'package:hive/hive.dart';

import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerInitial()) {
    on<FetchLocationEvent>(_onFetchLocation);
    on<PickImageEvent>(_onPickImage);
    on<SaveCustomerEvent>(_onSaveCustomer);
  }

  Future<void> _onFetchLocation(
      FetchLocationEvent event, Emitter<CustomerState> emit) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(CustomerError(message: 'Location services are disabled.'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(CustomerError(message: 'Location permissions are denied.'));
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      emit(LocationFetched(
        latitude: position.latitude,
        longitude: position.longitude,
        geoAddress: 'Lat: ${position.latitude}, Long: ${position.longitude}',
      ));
    } catch (e) {
      emit(CustomerError(message: 'Failed to fetch location: $e'));
    }
  }

  Future<void> _onPickImage(
      PickImageEvent event, Emitter<CustomerState> emit) async {
    try {
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        emit(ImagePicked(imagePath: pickedFile.path));
      }
    } catch (e) {
      emit(CustomerError(message: 'Failed to pick image: $e'));
    }
  }

  Future<void> _onSaveCustomer(
      SaveCustomerEvent event, Emitter<CustomerState> emit) async {
    try {
      final customer = Customer(
        fullName: event.fullName,
        mobileNo: event.mobileNo,
        email: event.email,
        address: event.address,
        latitude: event.latitude,
        longitude: event.longitude,
        geoAddress: event.geoAddress,
        customerImage: event.customerImage,
      );

      final box = Hive.box<Customer>('customers');
      box.add(customer);

      emit(CustomerSaved());
    } catch (e) {
      emit(CustomerError(message: 'Failed to save customer: $e'));
    }
  }
}