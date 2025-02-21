import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';

import '../blocs/add_customer/customer_bloc.dart';
import '../blocs/add_customer/customer_event.dart';
import '../blocs/add_customer/customer_state.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _geoAddressController = TextEditingController();
  File? _customerImage;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();

  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _geoAddressController.dispose();
    f1.dispose();
    f2.dispose();
    f3.dispose();
    f4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
            title: const Text(
                style: TextStyle(color: Colors.white), 'Add Customer')),
        body: BlocProvider(
          create: (context) => CustomerBloc(),
          child: BlocConsumer<CustomerBloc, CustomerState>(
              listener: (context, state) {
            if (state is CustomerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is CustomerSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Customer saved successfully!')),
              );
              _formKey.currentState!.reset();
              _customerImage = null;
              Navigator.pop(context,true);
            }
          }, builder: (context, state) {
            if (state is LocationFetched) {
              _latitudeController.text = state.latitude.toString();
              _longitudeController.text = state.longitude.toString();
              _geoAddressController.text = state.geoAddress;
            } else if (state is ImagePicked) {
              _customerImage = File(state.imagePath);
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _fullNameController,
                        keyboardType: TextInputType.name,
                        focusNode: f1,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(labelText: 'Full Name'),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(f2);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter full name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _mobileNoController,
                        keyboardType: TextInputType.number,
                        focusNode: f2,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(f3);
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(labelText: 'Mobile No'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          if (value.length != 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email ID'),
                        focusNode: f3,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(f4);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!EmailValidator.validate(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _addressController,
                        keyboardType: TextInputType.streetAddress,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(labelText: 'Address'),
                        focusNode: f4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _latitudeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Latitude'),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter latitude';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _longitudeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Longitude'),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please longitude';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _geoAddressController,
                        decoration: InputDecoration(labelText: 'Geo Address'),
                        readOnly: true,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<CustomerBloc>()
                              .add(FetchLocationEvent());
                        },
                        child: Text('Get Current Location'),
                      ),
                      SizedBox(height: 16),
                      _customerImage == null
                          ? ElevatedButton(
                              onPressed: () {
                                context
                                    .read<CustomerBloc>()
                                    .add(PickImageEvent());
                              },
                              child: Text('Pick Customer Image'),
                            )
                          : Center(
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Image.file(_customerImage!),
                              ),
                            ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if(_customerImage != null){
                              context.read<CustomerBloc>().add(
                                SaveCustomerEvent(
                                  fullName: _fullNameController.text,
                                  mobileNo: _mobileNoController.text,
                                  email: _emailController.text,
                                  address: _addressController.text,
                                  latitude:
                                  double.parse(_latitudeController.text),
                                  longitude:
                                  double.parse(_longitudeController.text),
                                  geoAddress: _geoAddressController.text,
                                  customerImage: _customerImage!.path,
                                ),
                              );
                            }else{
                              var s=SnackBar(
                                content: Text('Image is not selected'),
                                backgroundColor: Colors.red,
                                elevation: 10,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(5),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(s);
                            }

                          }
                        },
                        child: Text('Save Customer'),
                      ),
                    ],
                  )),
            );
          }),
        ));
  }
}
