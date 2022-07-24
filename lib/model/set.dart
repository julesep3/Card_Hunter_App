class SetQuery {
  SetQuery({
    required this.sets,
  });

  List<Set> sets;

  factory SetQuery.fromJson(Map<String, dynamic> json) => SetQuery(
        sets: List<Set>.from(json["sets"].map((x) => Set.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sets": List<dynamic>.from(sets.map((x) => x.toJson())),
      };
}

class Set {
  Set({
    required this.code,
    required this.name,
    required this.type,
    required this.booster,
    required this.releaseDate,
    required this.block,
    required this.onlineOnly,
  });

  String code;
  String? name;
  String? type;
  List<dynamic> booster;
  DateTime? releaseDate;
  String? block;
  bool? onlineOnly;

  factory Set.fromJson(Map<String, dynamic> json) => Set(
        code: json["code"],
        name: json["name"],
        type: json["type"],
        booster: json["booster"] != null
            ? List<dynamic>.from(json["booster"].map((x) => x))
            : [],
        releaseDate: DateTime.parse(json["releaseDate"]),
        block: json["block"],
        onlineOnly: json["onlineOnly"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "type": type,
        "booster":
            booster != null ? List<dynamic>.from(booster.map((x) => x)) : [],
        "releaseDate":
            "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "block": block,
        "onlineOnly": onlineOnly,
      };
}

enum BoosterEnum { UNCOMMON, COMMON }

final boosterEnumValues = EnumValues(
    {"common": BoosterEnum.COMMON, "uncommon": BoosterEnum.UNCOMMON});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class SetScryfall {
  SetScryfall({
    required this.object,
    required this.id,
    required this.code,
    required this.mtgoCode,
    required this.arenaCode,
    required this.tcgplayerId,
    required this.name,
    required this.uri,
    required this.scryfallUri,
    required this.searchUri,
    required this.releasedAt,
    required this.setType,
    required this.cardCount,
    required this.printedSize,
    required this.digital,
    required this.nonfoilOnly,
    required this.foilOnly,
    required this.blockCode,
    required this.block,
    required this.iconSvgUri,
  });

  String? object;
  String? id;
  String? code;
  String? mtgoCode;
  String? arenaCode;
  int? tcgplayerId;
  String? name;
  String? uri;
  String? scryfallUri;
  String searchUri;
  DateTime? releasedAt;
  String? setType;
  int? cardCount;
  int? printedSize;
  bool? digital;
  bool? nonfoilOnly;
  bool? foilOnly;
  String? blockCode;
  String? block;
  String? iconSvgUri;

  factory SetScryfall.fromJson(Map<String, dynamic> json) => SetScryfall(
        object: json["object"],
        id: json["id"],
        code: json["code"],
        mtgoCode: json["mtgo_code"],
        arenaCode: json["arena_code"],
        tcgplayerId: json["tcgplayer_id"],
        name: json["name"],
        uri: json["uri"],
        scryfallUri: json["scryfall_uri"],
        searchUri: json["search_uri"],
        releasedAt: DateTime.parse(json["released_at"]),
        setType: json["set_type"],
        cardCount: json["card_count"],
        printedSize: json["printed_size"],
        digital: json["digital"],
        nonfoilOnly: json["nonfoil_only"],
        foilOnly: json["foil_only"],
        blockCode: json["block_code"],
        block: json["block"],
        iconSvgUri: json["icon_svg_uri"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "id": id,
        "code": code,
        "mtgo_code": mtgoCode,
        "arena_code": arenaCode,
        "tcgplayer_id": tcgplayerId,
        "name": name,
        "uri": uri,
        "scryfall_uri": scryfallUri,
        "search_uri": searchUri,
        "released_at":
            "${releasedAt!.year.toString().padLeft(4, '0')}-${releasedAt!.month.toString().padLeft(2, '0')}-${releasedAt!.day.toString().padLeft(2, '0')}",
        "set_type": setType,
        "card_count": cardCount,
        "printed_size": printedSize,
        "digital": digital,
        "nonfoil_only": nonfoilOnly,
        "foil_only": foilOnly,
        "block_code": blockCode,
        "block": block,
        "icon_svg_uri": iconSvgUri,
      };
}
