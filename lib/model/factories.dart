class Album {
  final Future<Post>? card;
  // late Future<GETCard> card;
  const Album(this.card);
}

class GETCard {
  GETCard({
    required this.card,
  });

  List<Card> card;

  factory GETCard.fromJson(Map<String, dynamic> json) => GETCard(
        card: List<Card>.from(json["card"].map((x) => Card.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "card": List<dynamic>.from(card.map((x) => x.toJson())),
      };
}

class Card {
  Card({
    required this.name,
    required this.url,
    required this.cardSet,
    required this.setUrl,
    required this.offer,
  });

  String name;
  String url;
  SetType? cardSet;
  String setUrl;
  List<Offer> offer;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        name: json["name"],
        url: json["url"],
        cardSet: setValues.map[json["set"]],
        setUrl: json["set_url"],
        offer: List<Offer>.from(json["offer"].map((x) => Offer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "set": setValues.reverse[cardSet],
        "set_url": setUrl,
        "offer": List<dynamic>.from(offer.map((x) => x.toJson())),
      };
}

enum SetType {
  COLLECTORS_EDITION_DOMESTIC_SINGLES,
  MAGIC_THE_GATHERING_PROMO_CARDS,
  BETA_MAGIC_CARDS_SINGLES,
  ALPHA_MAGIC_CARDS_SINGLES
}

final setValues = EnumValues({
  "Alpha (Magic Cards) Singles": SetType.ALPHA_MAGIC_CARDS_SINGLES,
  "Beta (Magic Cards) Singles": SetType.BETA_MAGIC_CARDS_SINGLES,
  "Collectors' Edition (Domestic) Singles":
      SetType.COLLECTORS_EDITION_DOMESTIC_SINGLES,
  "Magic: The Gathering Promo Cards": SetType.MAGIC_THE_GATHERING_PROMO_CARDS
});

class Offer {
  Offer({
    required this.name,
  });

  String name;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class Post {
  Post({
    required this.projectToken,
    required this.runToken,
    required this.status,
    required this.dataReady,
    required this.startTime,
    required this.endTime,
    required this.pages,
    required this.md5Sum,
    required this.startUrl,
    required this.startTemplate,
    required this.startValue,
  });

  final String projectToken;
  final String runToken;
  final String status;
  final int dataReady;
  final DateTime startTime;
  final dynamic endTime;
  final int pages;
  final dynamic md5Sum;
  final String startUrl;
  final String startTemplate;
  final String startValue;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        projectToken: json["project_token"],
        runToken: json["run_token"],
        status: json["status"],
        dataReady: json["data_ready"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: json["end_time"],
        pages: json["pages"],
        md5Sum: json["md5sum"],
        startUrl: json["start_url"],
        startTemplate: json["start_template"],
        startValue: json["start_value"],
      );

  Map<String, dynamic> toJson() => {
        "project_token": projectToken,
        "run_token": runToken,
        "status": status,
        "data_ready": dataReady,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime,
        "pages": pages,
        "md5sum": md5Sum,
        "start_url": startUrl,
        "start_template": startTemplate,
        "start_value": startValue,
      };
}

/*
 * Factory for Project JSON 
 */
class Get {
  final String elements;
  final String outputType;
  final String templatesJson;
  final String ownerEmail;
  final List<LastReadyRun> runList;
  final String publicKey;
  final LastReadyRun lastReadyRun;
  final String mainTemplate;
  final String mainSite;
  final String title;
  final String token;
  final int? totalRuns;
  final bool maintained;
  final int? syntaxVersion;
  final String optionsJson;
  final String webhook;
  final LastReadyRun lastRun;
  Get({
    required this.elements,
    required this.outputType,
    required this.templatesJson,
    required this.ownerEmail,
    required this.runList,
    required this.publicKey,
    required this.lastReadyRun,
    required this.mainTemplate,
    required this.mainSite,
    required this.title,
    required this.token,
    required this.totalRuns,
    required this.maintained,
    required this.syntaxVersion,
    required this.optionsJson,
    required this.webhook,
    required this.lastRun,
  });
  factory Get.fromJson(Map<String, dynamic> json) => Get(
        elements: json["elements"],
        outputType: json["output_type"],
        templatesJson: json["templates_json"],
        ownerEmail: json["owner_email"],
        runList: List<LastReadyRun>.from(
            json["run_list"].map((x) => LastReadyRun.fromJson(x))),
        publicKey: json["public_key"],
        lastReadyRun: LastReadyRun.fromJson(json["last_ready_run"]),
        mainTemplate: json["main_template"],
        mainSite: json["main_site"],
        title: json["title"],
        token: json["token"],
        totalRuns: json["total_runs"],
        maintained: json["maintained"],
        syntaxVersion: json["syntax_version"],
        optionsJson: json["options_json"],
        webhook: json["webhook"],
        lastRun: LastReadyRun.fromJson(json["last_run"]),
      );

  Map<String, dynamic> toJson() => {
        "elements": elements,
        "output_type": outputType,
        "templates_json": templatesJson,
        "owner_email": ownerEmail,
        "run_list": List<dynamic>.from(runList.map((x) => x.toJson())),
        "public_key": publicKey,
        "last_ready_run": lastReadyRun.toJson(),
        "main_template": mainTemplate,
        "main_site": mainSite,
        "title": title,
        "token": token,
        "total_runs": totalRuns,
        "maintained": maintained,
        "syntax_version": syntaxVersion,
        "options_json": optionsJson,
        "webhook": webhook,
        "last_run": lastRun.toJson(),
      };
}

class LastReadyRun {
  final DateTime endTime;
  final String md5Sum;
  final int? dataReady;
  final String status;
  final String startUrl;
  final String runToken;
  final String startTemplate;
  final int? pages;
  final DateTime startRunningTime;
  final String projectToken;
  final DateTime startTime;
  final String customProxies;
  final String optionsJson;
  final String startValue;
  final String webhook;
  final bool isEmpty;
  final TemplatePages templatePages;

  LastReadyRun({
    required this.endTime,
    required this.md5Sum,
    required this.dataReady,
    required this.status,
    required this.startUrl,
    required this.runToken,
    required this.startTemplate,
    required this.pages,
    required this.startRunningTime,
    required this.projectToken,
    required this.startTime,
    required this.customProxies,
    required this.optionsJson,
    required this.startValue,
    required this.webhook,
    required this.isEmpty,
    required this.templatePages,
  });

  factory LastReadyRun.fromJson(Map<String, dynamic> json) => LastReadyRun(
        endTime: DateTime.parse(json["end_time"]),
        md5Sum: json["md5sum"],
        dataReady: json["data_ready"],
        status: json["status"],
        startUrl: json["start_url"],
        runToken: json["run_token"],
        startTemplate: json["start_template"],
        pages: json["pages"],
        startRunningTime: DateTime.parse(json["start_running_time"]),
        projectToken: json["project_token"],
        startTime: DateTime.parse(json["start_time"]),
        customProxies: json["custom_proxies"],
        optionsJson: json["options_json"],
        startValue: json["start_value"],
        webhook: json["webhook"],
        isEmpty: json["is_empty"],
        templatePages: TemplatePages.fromJson(json["template_pages"]),
      );

  Map<String, dynamic> toJson() => {
        "end_time": endTime.toIso8601String(),
        "md5sum": md5Sum,
        "data_ready": dataReady,
        "status": status,
        "start_url": startUrl,
        "run_token": runToken,
        "start_template": startTemplate,
        "pages": pages,
        "start_running_time": startRunningTime.toIso8601String(),
        "project_token": projectToken,
        "start_time": startTime.toIso8601String(),
        "custom_proxies": customProxies,
        "options_json": optionsJson,
        "start_value": startValue,
        "webhook": webhook,
        "is_empty": isEmpty,
        "template_pages": templatePages.toJson(),
      };
}

class TemplatePages {
  final int? movieDetails;
  final int? mainTemplate;
  TemplatePages({
    required this.movieDetails,
    required this.mainTemplate,
  });

  factory TemplatePages.fromJson(Map<String, dynamic> json) => TemplatePages(
        movieDetails: json["movie_details"],
        mainTemplate: json["main_template"],
      );

  Map<String, dynamic> toJson() => {
        "movie_details": movieDetails,
        "main_template": mainTemplate,
      };
}

class Options {
  Options({
    required this.ignoreDisabledElements,
    required this.allowPerfectSimulation,
    required this.startUrl,
    required this.rotateIPs,
    required this.outputType,
    required this.maxWorkers,
    required this.sendEmail,
    required this.customProxies,
    required this.recoveryRules,
    required this.proxyDisableAdblock,
    required this.preserveOrder,
    required this.startTemplate,
    required this.webhook,
    required this.maxPages,
    required this.startValue,
    required this.proxyAllowInsecure,
    required this.proxyCustomRotationHybrid,
    required this.loadJs,
  });

  bool ignoreDisabledElements;
  bool allowPerfectSimulation;
  String startUrl;
  bool rotateIPs;
  String outputType;
  String maxWorkers;
  bool sendEmail;
  String customProxies;
  String recoveryRules;
  bool proxyDisableAdblock;
  bool preserveOrder;
  String startTemplate;
  String webhook;
  String maxPages;
  String startValue;
  bool proxyAllowInsecure;
  bool proxyCustomRotationHybrid;
  bool loadJs;

  factory Options.fromJson(Map<String, dynamic> json) => Options(
        ignoreDisabledElements: json["ignoreDisabledElements"],
        allowPerfectSimulation: json["allowPerfectSimulation"],
        startUrl: json["startUrl"],
        rotateIPs: json["rotateIPs"],
        outputType: json["outputType"],
        maxWorkers: json["maxWorkers"],
        sendEmail: json["sendEmail"],
        customProxies: json["customProxies"],
        recoveryRules: json["recoveryRules"],
        proxyDisableAdblock: json["proxyDisableAdblock"],
        preserveOrder: json["preserveOrder"],
        startTemplate: json["startTemplate"],
        webhook: json["webhook"],
        maxPages: json["maxPages"],
        startValue: json["startValue"],
        proxyAllowInsecure: json["proxyAllowInsecure"],
        proxyCustomRotationHybrid: json["proxyCustomRotationHybrid"],
        loadJs: json["loadJs"],
      );

  Map<String, dynamic> toJson() => {
        "ignoreDisabledElements": ignoreDisabledElements,
        "allowPerfectSimulation": allowPerfectSimulation,
        "startUrl": startUrl,
        "rotateIPs": rotateIPs,
        "outputType": outputType,
        "maxWorkers": maxWorkers,
        "sendEmail": sendEmail,
        "customProxies": customProxies,
        "recoveryRules": recoveryRules,
        "proxyDisableAdblock": proxyDisableAdblock,
        "preserveOrder": preserveOrder,
        "startTemplate": startTemplate,
        "webhook": webhook,
        "maxPages": maxPages,
        "startValue": startValue,
        "proxyAllowInsecure": proxyAllowInsecure,
        "proxyCustomRotationHybrid": proxyCustomRotationHybrid,
        "loadJs": loadJs,
      };
}

class Run {
  Run({
    required this.movies,
  });

  List<Movie> movies;

  factory Run.fromJson(Map<String, dynamic> json) => Run(
        movies: List<Movie>.from(json["movies"].map((x) => Movie.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "movies": List<dynamic>.from(movies.map((x) => x.toJson())),
      };
}

class Movie {
  Movie({
    required this.name,
    required this.url,
    required this.imax,
    required this.rating,
    required this.character,
  });

  String name;
  String url;
  String imax;
  String rating;
  List<Character> character;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        name: json["name"],
        url: json["url"],
        imax: json["IMAX"],
        rating: json["rating"],
        character: List<Character>.from(
            json["character"].map((x) => Character.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "IMAX": imax,
        "rating": rating,
        "character": List<dynamic>.from(character.map((x) => x.toJson())),
      };
}

class Character {
  Character({
    required this.name,
    required this.actor,
  });

  String name;
  String actor;

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        name: json["name"],
        actor: json["actor"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "actor": actor,
      };
}
