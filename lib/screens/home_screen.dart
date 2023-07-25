import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmocloset/model/clothing.dart';
import 'package:cosmocloset/model/user.dart' as model;
import 'package:cosmocloset/model/userSettings.dart';
import 'package:cosmocloset/provider/user_provider.dart';
import 'package:cosmocloset/screens/random_clothing_card.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/global_variables.dart';
import 'package:cosmocloset/widgets/accessory_expansion_card.dart';
import 'package:cosmocloset/widgets/clothing_card.dart';
import 'package:cosmocloset/widgets/clothing_gen.dart';
import 'package:cosmocloset/widgets/deafult_weather.dart';
import 'package:cosmocloset/widgets/generate_settings_popup.dart';
import 'package:cosmocloset/widgets/hero_animation.dart';
import 'package:cosmocloset/widgets/skelton.dart';
import 'package:cosmocloset/widgets/weather_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';

import '../resources/fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String weatherKey = "0a830a12cd399d7ae1e08b21f955e582";
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  Weather? currentWeather;
  bool _isLoading = false;
  bool doneGen = false;
  bool _isLoadingWeather = false;
  // generate settings
  Random rand = Random();
  UserSettings userSettings = UserSettings();
  bool _considerWeather = false;
  bool _considerFormalEvent = false;
  // weather settings
  String? lastKnownTemp;
  String? lastKnownArea;
  String? lastKnownWeather;

  @override
  void initState() {
    super.initState();
    loadUserSettings();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
        width: double.infinity,
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Generator panel
            Expanded(
              flex: 14,
              child: Container(
                //TODO
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "welcome",
                          style: descriptionStyle,
                        ),
                        Text(
                          user.username,
                          style: titleStyle,
                        ),
                        GestureDetector(
                          onTap: () => getWeather(),
                          child: _isLoadingWeather == true
                              ? const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Skelton(height: 45, width: 48),
                                      SizedBox(width: 12,),
                                      Skelton(height: 20, width: 48),
                                      SizedBox(width: 8,),
                                      Skelton(height: 30, width: 38)
                                    ],
                                  ),
                              )
                              : currentWeather == null
                                  ? DefaultWeather(
                                      lastKnownTemp: userSettings.lastKnownTemp,
                                      lastKnownArea: userSettings.lastKnownArea,
                                      lastKnownWeather:
                                          userSettings.lastKnownWeather)
                                  : WeatherWidget(
                                      currentWeather: currentWeather!,
                                    ),
                        )
                      ],
                    ),
                    doneGen == false
                        ? const SizedBox()
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RandomClothingCard(
                                    clothingType: "Top",
                                    rand: rand,
                                    formalCondition: _considerFormalEvent,
                                    weatherCondition: _considerWeather,
                                    weatherInformation: currentWeather,
                                  ),
                                  RandomClothingCard(
                                    clothingType: "Bottom",
                                    rand: rand,
                                    formalCondition: _considerFormalEvent,
                                    weatherCondition: _considerWeather,
                                    weatherInformation: currentWeather,
                                  ),
                                  RandomClothingCard(
                                    clothingType: "Outerwear",
                                    rand: rand,
                                    formalCondition: _considerFormalEvent,
                                    weatherCondition: _considerWeather,
                                    weatherInformation: currentWeather,
                                  ),
                                  RandomClothingCard(
                                    clothingType: "Footwear",
                                    rand: rand,
                                    formalCondition: _considerFormalEvent,
                                    weatherCondition: _considerWeather,
                                    weatherInformation: currentWeather,
                                  ),
                                  RandomClothingCard(
                                    clothingType: "Accessories",
                                    rand: rand,
                                    formalCondition: _considerFormalEvent,
                                    weatherCondition: _considerWeather,
                                    weatherInformation: currentWeather,
                                  ),
                                  // AccessoriesExpandCard(
                                  //     clothingType: "Accessories", rand: rand),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            // settings panel
            Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "outfit settings",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Hero(
                        tag: generateSettingsHero,
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            alignment: Alignment.center,
                            color: Colors.grey.shade600,
                            onPressed: showSettings,
                            icon: const Icon(Icons.settings),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            // button panel
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: generateOutfit,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    color: buttonColor,
                  ),
                  child: _isLoading
                      ? Center(
                          child: Text(
                          "getting weather...",
                          style: buttonTextStyle,
                        ))
                      : Text(
                          "Generate Outfit!",
                          style: buttonTextStyle,
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showSettings() {
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return GenerateSettingsPopup(
        setConsiderFormal: setConsiderFormal,
        setConsiderWeather: setConsiderWeather,
        initialConsiderFormal: _considerFormalEvent,
        initialConsiderWeather: _considerWeather,
      );
    }));
  }

  void toggleWeatherMode() {
    setState(() {});
  }

  void generateOutfit() async {
    setState(() {
      rand = Random();
    });
    // check the current weather
    if (_considerWeather == true && currentWeather == null) {
      setState(() {
        _isLoading = true;
      });
      await getWeather();
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      doneGen = true;
    });
  }

  void randomPicker() {}

  getWeather() async {
    setState(() {
      _isLoadingWeather = true;
    });
    Position currentPos = await _determinePosition();
    WeatherFactory wf = WeatherFactory(weatherKey);
    Weather w = await wf.currentWeatherByLocation(
        currentPos.latitude, currentPos.longitude);
    String temperature = w.temperature!.celsius!.round().toString();
    String areaName = w.areaName!;
    String weatherMain = w.weatherMain!;
    userSettings.updateLastKnownTemp(temperature);
    userSettings.updateLastKnownArea(areaName);
    userSettings.updateLastKnownWeather(weatherMain);
    print("updated userSettings weather component");
    await saveUserSettings();
    print("saved");
    setState(() {
      currentWeather = w;
      _isLoadingWeather = false;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void loadUserSettings() async {
    String? settingsString =
        await const FlutterSecureStorage().read(key: userId);
    print("storage read");
    if (settingsString != null) {
      print("found user");
      Map<String, dynamic> settingsMap = jsonDecode(settingsString);
      setState(() {
        userSettings = UserSettings.fromMap(settingsMap);
        _considerFormalEvent = userSettings.formalGen;
        _considerWeather = userSettings.weatherGen;
        lastKnownTemp = userSettings.lastKnownTemp;
        lastKnownArea = userSettings.lastKnownArea;
        lastKnownWeather = userSettings.lastKnownWeather;
      });
      print("sucess setting users settings");
    } else {
      // Return default settings for a new user
      setState(() {
        userSettings = UserSettings();
        print("created new user setting");
      });
    }
  }

  void setConsiderWeather(bool boolean) async {
    if (currentWeather == null && boolean) {
      await getWeather();
    }
    setState(() {
      _considerWeather = boolean;
      // preferences!.setBool("weather", boolean);
      userSettings.updateWeatherGen(boolean);
      print("updated user settings");
    });
    // save to cloud
    await saveUserSettings();
    print("saved user settings to map");
  }

  void setConsiderFormal(bool boolean) async {
    setState(() {
      _considerFormalEvent = boolean;
      // preferences!.setBool("formal", boolean);
      userSettings.updateFormalGen(boolean);
      print("updated user settings");
    });
    await saveUserSettings();
    print("saved user settings to map");
  }

  saveUserSettings() async {
    String settingsString = jsonEncode(userSettings.toMap());
    await storage.write(key: userId, value: settingsString);
  }
}
