import 'dart:io';

import 'package:customer_app/view/add_customer_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/customer_model.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  Future<Box<Customer>> fetchData() async {
    var data = await Hive.openBox<Customer>('customers');
    setState(() {});
    return data;
  }

  Future<void> _openGoogleMaps(var lat, var long) async {
    final googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$long&travelmode=driving';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not open Google Maps.';
    }
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
                style: TextStyle(color: Colors.white), 'Customer List')),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCustomerPage()),
            );
            if (result == true) {
              fetchData();
            }
          },
          shape: CircleBorder(),
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: FutureBuilder<Box<Customer>>(
            future: Hive.openBox<Customer>('customers'),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final customerBox = snapshot.data!;
                final customers = customerBox.values.toList();
                if (customers.isEmpty) {
                  return Center(child: Text('No customers found.'));
                }

                return ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              FileImage(File(customer.customerImage))),
                      title: Text('Name: ${customer.fullName}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${customer.email}'),
                          Text('Mobile: ${customer.mobileNo}'),
                          Text('Address: ${customer.address}'),
                          Text('GeoAddress: ${customer.geoAddress}'),
                        ],
                      ),
                      trailing: InkWell(
                          onTap: () {
                            _openGoogleMaps(
                                customer.latitude, customer.longitude);
                          },
                          child: Icon(
                            Icons.navigation,
                            color: Colors.blue,
                          )),
                      onTap: () {},
                    );
                  },
                );
              }
            }));
  }
}
