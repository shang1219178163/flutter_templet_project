class OpenWeatherRoot {
  OpenWeatherRoot({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  OpenWeatherCoord? coord;

  List<OpenWeather>? weather;

  String? base;

  OpenWeatherMain? main;

  int? visibility;

  OpenWeatherWind? wind;

  OpenWeatherCloud? clouds;

  OpenWeatherRain? rain;

  int? dt;

  OpenWeatherSys? sys;

  int? timezone;

  int? id;

  String? name;

  int? cod;

  OpenWeatherRoot.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    coord =
        json['coord'] != null ? OpenWeatherCoord.fromJson(json['coord']) : null;
    if (json['weather'] != null) {
      final array = json['weather'].map((e) => OpenWeather.fromJson(e));
      weather = List<OpenWeather>.from(array);
    }
    base = json['base'];
    main = json['main'] != null ? OpenWeatherMain.fromJson(json['main']) : null;
    visibility = json['visibility'];
    wind = json['wind'] != null ? OpenWeatherWind.fromJson(json['wind']) : null;
    clouds = json['clouds'] != null
        ? OpenWeatherCloud.fromJson(json['clouds'])
        : null;
    rain = json['rain'] != null ? OpenWeatherRain.fromJson(json['rain']) : null;
    dt = json['dt'];
    sys = json['sys'] != null ? OpenWeatherSys.fromJson(json['sys']) : null;
    timezone = json['timezone'];
    id = json['id'];
    name = json['name'];
    cod = json['cod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (coord != null) {
      map['coord'] = coord!.toJson();
    }
    if (weather != null) {
      map['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    map['base'] = base;
    if (main != null) {
      map['main'] = main!.toJson();
    }
    map['visibility'] = visibility;
    if (wind != null) {
      map['wind'] = wind!.toJson();
    }
    if (clouds != null) {
      map['clouds'] = clouds!.toJson();
    }
    map['dt'] = dt;
    if (sys != null) {
      map['sys'] = sys!.toJson();
    }
    map['timezone'] = timezone;
    map['id'] = id;
    map['name'] = name;
    map['cod'] = cod;
    return map;
  }
}

class OpenWeatherCoord {
  OpenWeatherCoord({
    this.lon,
    this.lat,
  });

  double? lon;

  double? lat;

  OpenWeatherCoord.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['lon'] = lon;
    map['lat'] = lat;
    return map;
  }
}

class OpenWeather {
  OpenWeather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  int? id;

  String? main;

  String? description;

  String? icon;

  OpenWeather.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['main'] = main;
    map['description'] = description;
    map['icon'] = icon;
    return map;
  }
}

class OpenWeatherMain {
  OpenWeatherMain({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  double? temp;

  double? feelsLike;

  double? tempMin;

  double? tempMax;

  int? pressure;

  int? humidity;

  int? seaLevel;

  int? grndLevel;

  OpenWeatherMain.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    temp = json['temp'];
    feelsLike = json['feels_like'];
    tempMin = json['temp_min'];
    tempMax = json['temp_max'];
    pressure = json['pressure'];
    humidity = json['humidity'];
    seaLevel = json['sea_level'];
    grndLevel = json['grnd_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['temp'] = temp;
    map['feels_like'] = feelsLike;
    map['temp_min'] = tempMin;
    map['temp_max'] = tempMax;
    map['pressure'] = pressure;
    map['humidity'] = humidity;
    map['sea_level'] = seaLevel;
    map['grnd_level'] = grndLevel;
    return map;
  }
}

class OpenWeatherWind {
  OpenWeatherWind({
    this.speed,
    this.deg,
    this.gust,
  });

  double? speed;

  int? deg;

  double? gust;

  OpenWeatherWind.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    speed = json['speed'];
    deg = json['deg'];
    gust = json['gust'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['speed'] = speed;
    map['deg'] = deg;
    map['gust'] = gust;
    return map;
  }
}

class OpenWeatherCloud {
  OpenWeatherCloud({
    this.all,
  });

  int? all;

  OpenWeatherCloud.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    all = json['all'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['all'] = all;
    return map;
  }
}

class OpenWeatherRain {
  OpenWeatherRain({
    this.rain1h,
    this.rain3h,
  });

  int? rain1h;

  int? rain3h;

  double? d3h;

  OpenWeatherRain.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    rain1h = json['rain.1h'];
    rain3h = json['rain.3h'];
    d3h = json['3h'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['rain1h'] = rain1h;
    map['rain3h'] = rain3h;
    map['3h'] = d3h;
    return map;
  }
}

class OpenWeatherSys {
  OpenWeatherSys({
    this.type,
    this.id,
    this.country,
    this.sunrise,
    this.sunset,
  });

  int? type;

  int? id;

  String? country;

  int? sunrise;

  int? sunset;

  OpenWeatherSys.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    type = json['type'];
    id = json['id'];
    country = json['country'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['type'] = type;
    map['id'] = id;
    map['country'] = country;
    map['sunrise'] = sunrise;
    map['sunset'] = sunset;
    return map;
  }
}

/// 预测
class OpenWeatherForecast {
  OpenWeatherForecast({
    this.cod,
    this.message,
    this.cnt,
    this.list,
    this.city,
  });

  String? cod;

  int? message;

  int? cnt;

  List<OpenWeatherList>? list;

  OpenWeatherCity? city;

  OpenWeatherForecast.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    cod = json['cod'];
    message = json['message'];
    cnt = json['cnt'];
    if (json['list'] != null) {
      final array =
          (json['list'] as List).map((e) => OpenWeatherList.fromJson(e));
      list = List<OpenWeatherList>.from(array);
    }
    city = json['city'] != null ? OpenWeatherCity.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cod'] = cod;
    map['message'] = message;
    map['cnt'] = cnt;
    if (list != null) {
      map['list'] = list!.map((v) => v.toJson()).toList();
    }
    if (city != null) {
      map['city'] = city!.toJson();
    }
    return map;
  }
}

class OpenWeatherList {
  OpenWeatherList({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
    this.rain,
    this.sys,
    this.dtTxt,
  });

  int? dt;

  OpenWeatherMain? main;

  List<OpenWeather>? weather;

  OpenWeatherCloud? clouds;

  OpenWeatherWind? wind;

  int? visibility;

  double? pop;

  OpenWeatherRain? rain;

  OpenWeatherSys? sys;

  String? dtTxt;

  OpenWeatherList.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    dt = json['dt'];
    main = json['main'] != null ? OpenWeatherMain.fromJson(json['main']) : null;
    if (json['weather'] != null) {
      final array =
          (json['weather'] as List).map((e) => OpenWeather.fromJson(e));
      weather = List<OpenWeather>.from(array);
    }
    clouds = json['clouds'] != null
        ? OpenWeatherCloud.fromJson(json['clouds'])
        : null;
    wind = json['wind'] != null ? OpenWeatherWind.fromJson(json['wind']) : null;
    visibility = json['visibility'];
    pop = json['pop'];
    rain = json['rain'] != null ? OpenWeatherRain.fromJson(json['rain']) : null;
    sys = json['sys'] != null ? OpenWeatherSys.fromJson(json['sys']) : null;
    dtTxt = json['dt_txt'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dt'] = dt;
    if (main != null) {
      map['main'] = main!.toJson();
    }
    if (weather != null) {
      map['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    if (clouds != null) {
      map['clouds'] = clouds!.toJson();
    }
    if (wind != null) {
      map['wind'] = wind!.toJson();
    }
    map['visibility'] = visibility;
    map['pop'] = pop;
    if (rain != null) {
      map['rain'] = rain!.toJson();
    }
    if (sys != null) {
      map['sys'] = sys!.toJson();
    }
    map['dt_txt'] = dtTxt;
    return map;
  }
}

class OpenWeatherCity {
  OpenWeatherCity({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
    this.sunrise,
    this.sunset,
  });

  int? id;

  String? name;

  OpenWeatherCoord? coord;

  String? country;

  int? population;

  int? timezone;

  int? sunrise;

  int? sunset;

  OpenWeatherCity.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = json['id'];
    name = json['name'];
    coord =
        json['coord'] != null ? OpenWeatherCoord.fromJson(json['coord']) : null;
    country = json['country'];
    population = json['population'];
    timezone = json['timezone'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (coord != null) {
      map['coord'] = coord!.toJson();
    }
    map['country'] = country;
    map['population'] = population;
    map['timezone'] = timezone;
    map['sunrise'] = sunrise;
    map['sunset'] = sunset;
    return map;
  }
}
