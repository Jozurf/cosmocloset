class UserSettings {
  bool darkMode;
  bool weatherGen;
  bool formalGen;
  // Add more settings as needed
  String? lastKnownTemp;
  String? lastKnownArea;
  String? lastKnownWeather;

  UserSettings({this.darkMode = false, this.weatherGen = false, this.formalGen = false, this.lastKnownTemp, this.lastKnownArea, this.lastKnownWeather});

  // Add methods to convert the settings to/from a Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'weatherGen': weatherGen,
      'formalGen': formalGen,
      'lastKnownTemp': lastKnownTemp,
      'lastKnownArea': lastKnownArea,
      'lastKnownWeather': lastKnownWeather,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      darkMode: map['darkMode'],
      weatherGen: map['weatherGen'],
      formalGen: map['formalGen'],
      lastKnownTemp: map['lastKnownTemp'],
      lastKnownArea: map['lastKnownArea'],
      lastKnownWeather: map['lastKnownWeather']
    );
  }


  void updateWeatherGen(bool updatedValue) {
    weatherGen = updatedValue;
    print("updated weather gen in userSettings $updatedValue");
  }

  void updateFormalGen(bool updatedValue) {
    formalGen = updatedValue;
    print("updated formal gen in userSettings $updatedValue");
  }

  void updateDarkMode(bool updatedValue) {
    darkMode = updatedValue;
  }


  void updateLastKnownTemp(String updatedValue) {
    lastKnownTemp = updatedValue;
  }

  void updateLastKnownArea(String updatedValue) {
    lastKnownArea = updatedValue;
  }
  
  void updateLastKnownWeather(String updatedValue) {
    lastKnownWeather = updatedValue;
  }
}