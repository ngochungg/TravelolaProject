// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class SearchMater extends StatefulWidget {
  static const routeName = '/search_master';
  SearchMater({Key? key}) : super(key: key);

  @override
  State<SearchMater> createState() => _SearchMaterState();
}

class _SearchMaterState extends State<SearchMater> {
  Position? _currentPosition;
  String? _currentAddress;
  List<String>? list;

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }
    var jsonData = json.decode(utf8.decode(retriveString.codeUnits));
    List<String> cityList = [
      for (int i = 0; i < jsonData.length; i++) jsonData[i]['name']
    ];
    setState(() {
      list = cityList;
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BackButton(
              color: Colors.white,
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Search your favorite hotel',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(
              width: 45,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 15, right: 15),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          if (_currentAddress != null)
                            if (_currentAddress!.length > 11)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Colors.white,
                                    ),
                                    onPressed: () {
                                      _tripEditModalBottomSheet(context);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          '${_currentAddress?.substring(0, 11)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Colors.white,
                                    ),
                                    onPressed: () {
                                      _tripEditModalBottomSheet(context);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          '${_currentAddress}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          else
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: Colors.white,
                                  ),
                                  onPressed: () {
                                    _tripEditModalBottomSheet(context);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Find hotel near you',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (_currentAddress != null)
                            IconButton(
                              onPressed: () {
                                _getCurrentLocation();
                              },
                              icon: Icon(Icons.my_location),
                              color: Colors.pink,
                            )
                          else
                            IconButton(
                              onPressed: () {
                                _getCurrentLocation();
                              },
                              icon: Icon(Icons.location_searching),
                              color: Colors.pink,
                            )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Divider(
                        color: Colors.grey[300],
                        // thickness: 1,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var id;
                        var province = await http.get(Uri.parse(
                            'http://localhost:8080/api/auth/getAllProvince'));
                        var alo =
                            jsonDecode(utf8.decode(province.body.codeUnits));
                        for (int i = 0; i < alo.length; i++) {
                          if (alo[i]['name'] == _currentAddress) {
                            id = alo[i]['id'];
                          }
                        }
                        var location = jsonEncode({"provinceId": "$id"});
                        var search = await http.post(
                            Uri.parse(
                                'http://localhost:8080/api/hotel/searchHotel'),
                            body: location,
                            headers: {'Content-Type': 'application/json'});
                        var data =
                            jsonDecode(utf8.decode(search.body.codeUnits));
                        for (int i = 0; i < data.length; i++) {
                          print(data[i]['hotelName']);
                        }
                      },
                      child: Text('search'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        if (_currentAddress == 'Ho Chi Minh City, , Vietnam') {
          _currentAddress = 'Hồ Chí Minh';
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _tripEditModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Choose your city',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: list!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(list![index]),
                        onTap: () {
                          setState(() {
                            _currentAddress = list![index];
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
