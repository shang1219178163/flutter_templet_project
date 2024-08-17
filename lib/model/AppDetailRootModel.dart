class AppDetailRootModel {
  AppDetailRootModel({
    this.resultCount,
    this.results,
  });

  int? resultCount;

  List<ResultsModel>? results;

  AppDetailRootModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    resultCount = json['resultCount'];
    if (json['results'] != null) {
      final array =
          (json['results'] as List).map((e) => ResultsModel.fromJson(e));
      results = List<ResultsModel>.from(array);
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['resultCount'] = resultCount;
    if (results != null) {
      map['results'] = results!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ResultsModel {
  ResultsModel({
    // this.ipadScreenshotUrls,
    // this.appletvScreenshotUrls,
    this.artworkUrl60,
    this.artworkUrl512,
    this.artworkUrl100,
    this.artistViewUrl,
    this.screenshotUrls,
    this.supportedDevices,
    // this.advisories,
    this.isGameCenterEnabled,
    this.kind,
    // this.features,
    this.trackCensoredName,
    this.languageCodesISO2A,
    this.fileSizeBytes,
    this.sellerUrl,
    this.contentAdvisoryRating,
    this.averageUserRatingForCurrentVersion,
    this.userRatingCountForCurrentVersion,
    this.averageUserRating,
    this.trackViewUrl,
    this.trackContentRating,
    this.trackId,
    this.trackName,
    this.releaseDate,
    this.genreIds,
    this.formattedPrice,
    this.primaryGenreName,
    this.minimumOsVersion,
    this.isVppDeviceBasedLicensingEnabled,
    this.sellerName,
    this.currentVersionReleaseDate,
    this.releaseNotes,
    this.primaryGenreId,
    this.currency,
    this.version,
    this.wrapperType,
    this.artistId,
    this.artistName,
    this.genres,
    this.price,
    this.description,
    this.bundleId,
    this.userRatingCount,
  });

  // List<Null>? ipadScreenshotUrls;
  //
  // List<Null>? appletvScreenshotUrls;

  String? artworkUrl60;

  String? artworkUrl512;

  String? artworkUrl100;

  String? artistViewUrl;

  List<String>? screenshotUrls;

  List<String>? supportedDevices;

  // List<Null>? advisories;

  bool? isGameCenterEnabled;

  String? kind;

  // List<Null>? features;

  String? trackCensoredName;

  List<String>? languageCodesISO2A;

  String? fileSizeBytes;

  String? sellerUrl;

  String? contentAdvisoryRating;

  double? averageUserRatingForCurrentVersion;

  int? userRatingCountForCurrentVersion;

  double? averageUserRating;

  String? trackViewUrl;

  String? trackContentRating;

  int? trackId;

  String? trackName;

  String? releaseDate;

  List<String>? genreIds;

  String? formattedPrice;

  String? primaryGenreName;

  String? minimumOsVersion;

  bool? isVppDeviceBasedLicensingEnabled;

  String? sellerName;

  String? currentVersionReleaseDate;

  String? releaseNotes;

  int? primaryGenreId;

  String? currency;

  String? version;

  String? wrapperType;

  int? artistId;

  String? artistName;

  List<String>? genres;

  double? price;

  String? description;

  String? bundleId;

  int? userRatingCount;

  ResultsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    // if (json['ipadScreenshotUrls'] != null) {
    //   final array =
    //       (json['ipadScreenshotUrls'] as List).map((e) => Null.fromJson(e));
    //   ipadScreenshotUrls = List<Null>.from(array);
    // }
    // if (json['appletvScreenshotUrls'] != null) {
    //   final array =
    //       (json['appletvScreenshotUrls'] as List).map((e) => Null.fromJson(e));
    //   appletvScreenshotUrls = List<Null>.from(array);
    // }
    artworkUrl60 = json['artworkUrl60'];
    artworkUrl512 = json['artworkUrl512'];
    artworkUrl100 = json['artworkUrl100'];
    artistViewUrl = json['artistViewUrl'];
    screenshotUrls = List<String>.from(json['screenshotUrls'] ?? []);
    supportedDevices = List<String>.from(json['supportedDevices'] ?? []);
    // if (json['advisories'] != null) {
    //   final array = (json['advisories'] as List).map((e) => Null.fromJson(e));
    //   advisories = List<Null>.from(array);
    // }
    isGameCenterEnabled = json['isGameCenterEnabled'];
    kind = json['kind'];
    // if (json['features'] != null) {
    //   final array = (json['features'] as List).map((e) => Null.fromJson(e));
    //   features = List<Null>.from(array);
    // }
    trackCensoredName = json['trackCensoredName'];
    languageCodesISO2A = List<String>.from(json['languageCodesISO2A'] ?? []);
    fileSizeBytes = json['fileSizeBytes'];
    sellerUrl = json['sellerUrl'];
    contentAdvisoryRating = json['contentAdvisoryRating'];
    averageUserRatingForCurrentVersion =
        json['averageUserRatingForCurrentVersion'];
    userRatingCountForCurrentVersion = json['userRatingCountForCurrentVersion'];
    averageUserRating = json['averageUserRating'];
    trackViewUrl = json['trackViewUrl'];
    trackContentRating = json['trackContentRating'];
    trackId = json['trackId'];
    trackName = json['trackName'];
    releaseDate = json['releaseDate'];
    genreIds = List<String>.from(json['genreIds'] ?? []);
    formattedPrice = json['formattedPrice'];
    primaryGenreName = json['primaryGenreName'];
    minimumOsVersion = json['minimumOsVersion'];
    isVppDeviceBasedLicensingEnabled = json['isVppDeviceBasedLicensingEnabled'];
    sellerName = json['sellerName'];
    currentVersionReleaseDate = json['currentVersionReleaseDate'];
    releaseNotes = json['releaseNotes'];
    primaryGenreId = json['primaryGenreId'];
    currency = json['currency'];
    version = json['version'];
    wrapperType = json['wrapperType'];
    artistId = json['artistId'];
    artistName = json['artistName'];
    genres = List<String>.from(json['genres'] ?? []);
    price = json['price'];
    description = json['description'];
    bundleId = json['bundleId'];
    userRatingCount = json['userRatingCount'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // if (ipadScreenshotUrls != null) {
    //   map['ipadScreenshotUrls'] =
    //       ipadScreenshotUrls!.map((v) => v.toJson()).toList();
    // }
    // if (appletvScreenshotUrls != null) {
    //   map['appletvScreenshotUrls'] =
    //       appletvScreenshotUrls!.map((v) => v.toJson()).toList();
    // }
    map['artworkUrl60'] = artworkUrl60;
    map['artworkUrl512'] = artworkUrl512;
    map['artworkUrl100'] = artworkUrl100;
    map['artistViewUrl'] = artistViewUrl;
    map['screenshotUrls'] = screenshotUrls;
    map['supportedDevices'] = supportedDevices;
    // if (advisories != null) {
    //   map['advisories'] = advisories!.map((v) => v.toJson()).toList();
    // }
    map['isGameCenterEnabled'] = isGameCenterEnabled;
    map['kind'] = kind;
    // if (features != null) {
    //   map['features'] = features!.map((v) => v.toJson()).toList();
    // }
    map['trackCensoredName'] = trackCensoredName;
    map['languageCodesISO2A'] = languageCodesISO2A;
    map['fileSizeBytes'] = fileSizeBytes;
    map['sellerUrl'] = sellerUrl;
    map['contentAdvisoryRating'] = contentAdvisoryRating;
    map['averageUserRatingForCurrentVersion'] =
        averageUserRatingForCurrentVersion;
    map['userRatingCountForCurrentVersion'] = userRatingCountForCurrentVersion;
    map['averageUserRating'] = averageUserRating;
    map['trackViewUrl'] = trackViewUrl;
    map['trackContentRating'] = trackContentRating;
    map['trackId'] = trackId;
    map['trackName'] = trackName;
    map['releaseDate'] = releaseDate;
    map['genreIds'] = genreIds;
    map['formattedPrice'] = formattedPrice;
    map['primaryGenreName'] = primaryGenreName;
    map['minimumOsVersion'] = minimumOsVersion;
    map['isVppDeviceBasedLicensingEnabled'] = isVppDeviceBasedLicensingEnabled;
    map['sellerName'] = sellerName;
    map['currentVersionReleaseDate'] = currentVersionReleaseDate;
    map['releaseNotes'] = releaseNotes;
    map['primaryGenreId'] = primaryGenreId;
    map['currency'] = currency;
    map['version'] = version;
    map['wrapperType'] = wrapperType;
    map['artistId'] = artistId;
    map['artistName'] = artistName;
    map['genres'] = genres;
    map['price'] = price;
    map['description'] = description;
    map['bundleId'] = bundleId;
    map['userRatingCount'] = userRatingCount;
    return map;
  }
}
