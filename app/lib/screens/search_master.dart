// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:app/screens/Hotel/home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SearchMater extends StatefulWidget {
  static const routeName = '/search_master';
  const SearchMater({Key? key}) : super(key: key);

  @override
  State<SearchMater> createState() => _SearchMaterState();
}

class _SearchMaterState extends State<SearchMater> {
  Position? _currentPosition;
  String? _currentAddress;
  List<String>? list;
  String? nights = 1.toString();
  DateTime selectedDate = DateTime.now();
  static List<String> nightsList = [for (int i = 1; i < 31; i++) i.toString()];

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    final hotelNameController = TextEditingController();
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }
    var jsonData = json.decode(utf8.decode(retriveString.codeUnits));
    List<String> cityList = [
      for (int i = 0; i < jsonData.length; i++) jsonData[i]['name']
    ];

    final RoundedLoadingButtonController _btnController =
        RoundedLoadingButtonController();
    setState(() {
      list = cityList;
      _btnController.reset();
    });
    void _doSomething() async {
      Timer(Duration(seconds: 2), () {
        _btnController.reset();
      });
      var id;
      var province = await http
          .get(Uri.parse('http://localhost:8080/api/auth/getAllProvince'));
      var alo = jsonDecode(utf8.decode(province.body.codeUnits));
      for (int i = 0; i < alo.length; i++) {
        if (alo[i]['name'] == _currentAddress) {
          id = alo[i]['id'];
        }
      }
      String hotelName = hotelNameController.text;
      var location = jsonEncode({
        "provinceId": "$id",
        "hotelName": hotelName,
        "checkIn": "$selectedDate",
      });
      var search = await http.post(
          Uri.parse('http://localhost:8080/api/hotel/searchHotel'),
          body: location,
          headers: {'Content-Type': 'application/json'});
      var data = jsonDecode(search.body);
      var infor = jsonDecode(location);
      if (search.body.isNotEmpty) {
        var temps =
            json.encode({'dataHotel': data, 'infor': infor, 'nights': nights});
        Navigator.of(context)
            .pushNamed(HotelHomePage.routeName, arguments: temps);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Your hotel name is not found"),
        ));
      }
    }

    var day = int.parse('$nights');

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
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(5, 8), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    //search bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: hotelNameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15),
                          //   borderSide: BorderSide(
                          //     color: Colors.white,
                          //   ),
                          // ),
                          focusColor: Colors.white,
                          hintText: 'Search your favorite hotel',
                          labelText: 'Search',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          if (_currentAddress != null)
                            if (_currentAddress!.length > 11)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
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
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
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
                                          '$_currentAddress',
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
                                        'Hotel near you',
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
                        color: Colors.grey[500],
                        // thickness: 1,
                      ),
                    ),
                    //date selection bar
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.pinkAccent,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              elevation: 0,
                            ),
                            child: Text(
                              '$nights night(s)',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            onPressed: () {
                              _tripEditModalBottomSheetNight(context);
                            },
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Divider(
                        color: Colors.grey[300],
                        // thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Check-out: ${selectedDate.day + day}/${selectedDate.month}/${selectedDate.year}',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                            ),
                          ),
                          SizedBox(
                            width: 45,
                          ),
                          Expanded(
                            child: Text(
                              'Max. 30 nights',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Divider(
                        color: Colors.grey[500],
                        // thickness: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15, top: 10),
                          child: RoundedLoadingButton(
                            color: Colors.pinkAccent,
                            // height: 30,
                            width: 180,
                            child: Text('Search',
                                style: TextStyle(color: Colors.white)),
                            controller: _btnController,
                            onPressed: _doSomething,
                          ),
                        ),
                      ],
                    ),
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
        return SizedBox(
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

  void _tripEditModalBottomSheetNight(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SingleChildScrollView(
          physics: ScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text('Choose your payment method',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: nightsList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text("${nightsList[index]} night(s)"),
                          onTap: () {
                            setState(() {
                              nights = nightsList[index];
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
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.pinkAccent, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.pinkAccent, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2023));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
