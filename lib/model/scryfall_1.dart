/*
 * parsed with Nicol Bolas
 */
// test test test test
import 'dart:convert';

Scryfall scryfallFromJson(String str) => Scryfall.fromJson(json.decode(str));

String scryfallToJson(Scryfall data) => json.encode(data.toJson());

class SetofCards {
  SetofCards({
    required this.object,
    required this.totalCards,
    required this.hasMore,
    required this.nextPage,
    required this.data,
  });

  String object;
  int totalCards;
  bool hasMore;
  String? nextPage;
  List<Scryfall> data;

  factory SetofCards.fromJson(Map<String, dynamic> json) => SetofCards(
        object: json["object"],
        totalCards: json["total_cards"],
        hasMore: json["has_more"],
        nextPage: json["next_page"],
        data:
            List<Scryfall>.from(json["data"].map((x) => Scryfall.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "total_cards": totalCards,
        "has_more": hasMore,
        "next_page": nextPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Scryfall {
  Scryfall({
    required this.object,
    required this.id,
    required this.oracleId,
    required this.multiverseIds,
    required this.mtgoId,
    required this.mtgoFoilId,
    required this.tcgplayerId,
    required this.cardmarketId,
    required this.arenaId,
    required this.name,
    required this.lang,
    required this.releasedAt,
    required this.uri,
    required this.scryfallUri,
    required this.layout,
    required this.highresImage,
    required this.imageStatus,
    required this.imageUris,
    required this.manaCost,
    required this.cmc,
    required this.typeLine,
    required this.oracleText,
    required this.power,
    required this.toughness,
    required this.colors,
    required this.colorIdentity,
    required this.keywords,
    required this.producedMana,
    required this.legalities,
    required this.games,
    required this.reserved,
    required this.foil,
    required this.nonfoil,
    required this.finishes,
    required this.oversized,
    required this.promo,
    required this.reprint,
    required this.variation,
    required this.setId,
    required this.scryfallSet,
    required this.setName,
    required this.setType,
    required this.setUri,
    required this.setSearchUri,
    required this.scryfallSetUri,
    required this.rulingsUri,
    required this.printsSearchUri,
    required this.collectorNumber,
    required this.digital,
    required this.rarity,
    required this.watermark,
    required this.flavorText,
    required this.cardBackId,
    required this.artist,
    required this.artistIds,
    required this.illustrationId,
    required this.borderColor,
    required this.frame,
    required this.frameEffects,
    required this.securityStamp,
    required this.fullArt,
    required this.textless,
    required this.booster,
    required this.storySpotlight,
    required this.edhrecRank,
    required this.prices,
    required this.relatedUris,
    required this.purchaseUris,
    required this.cardFaces,
    required this.allParts,
    required this.preview,
  });
  List<CardFace>? cardFaces;
  List<AllPart>? allParts;
  String? object;
  String? id;
  String? oracleId; // maybe nullable
  List<num>? multiverseIds; // nullable
  num? mtgoId;
  num? mtgoFoilId;
  num? tcgplayerId;
  num? cardmarketId;
  num? arenaId;
  String? name;
  String? lang;
  DateTime? releasedAt;
  String? uri;
  String? scryfallUri;
  String? layout; // maybe nullable
  bool? highresImage;
  String? imageStatus;
  ImageUris imageUris; // nullable
  String? manaCost; // maybe nullable
  num? cmc; // maybe nullable
  String? typeLine; // maybe nullable
  String? oracleText; // nullable
  String? power; // nullable
  String? toughness; // nullable
  List<String>? colors; // nullable
  List<String>? colorIdentity;
  List<String>? keywords;
  List<String>? producedMana;
  Legalities? legalities;
  List<String>? games;
  bool? reserved;
  bool? foil;
  bool? nonfoil;
  List<String>? finishes;
  bool? oversized;
  bool? reprint;
  bool? variation;
  String? setId;
  String? scryfallSet; // not found on doc
  String? setName;
  bool? promo;
  String? setType;
  String? setUri;
  String? setSearchUri;
  String? scryfallSetUri;
  String? rulingsUri;
  String? printsSearchUri;
  String? collectorNumber;
  bool? digital;
  String? rarity;
  String? watermark; // nullable
  String? flavorText; // nullable
  String? cardBackId;
  String? artist; // nullable
  List<String>? artistIds; // not found on doc
  String? illustrationId; // nullable
  String? borderColor;
  String? frame;
  List<String>? frameEffects;
  String? securityStamp; // nullable
  bool? fullArt;
  bool? textless;
  bool? booster; // not found on doc
  bool? storySpotlight;
  num? edhrecRank; // nullable
  Preview? preview;
  Prices? prices; // check edge case for Black Lotus
  RelatedUris? relatedUris;
  PurchaseUris? purchaseUris;

  factory Scryfall.fromJson(Map<String, dynamic> json) => Scryfall(
        object: json["object"],
        id: json["id"],
        allParts: json["all_parts"] != null
            ? List<AllPart>.from(
                json["all_parts"].map((x) => AllPart.fromJson(x)))
            : [],
        oracleId: json["oracle_id"],
        multiverseIds: json["multiverse_ids"] != null
            ? List<int>.from(json["multiverse_ids"].map((x) => x))
            : [],
        arenaId: json["arena_id"],
        mtgoId: json["mtgo_id"],
        mtgoFoilId: json["mtgo_foil_id"],
        tcgplayerId: json["tcgplayer_id"],
        cardmarketId: json["cardmarket_id"],
        name: json["name"],
        lang: json["lang"],
        releasedAt: DateTime.parse(json["released_at"]),
        uri: json["uri"],
        scryfallUri: json["scryfall_uri"],
        layout: json["layout"],
        highresImage: json["highres_image"],
        imageStatus: json["image_status"],
        imageUris: json["image_uris"] != null
            ? ImageUris.fromJson(json["image_uris"])
            : ImageUris(
                small: "",
                normal: "",
                large: "",
                png: "",
                artCrop: "",
                borderCrop: "",
              ),
        manaCost: json["mana_cost"],
        cmc: json["cmc"],
        typeLine: json["type_line"],
        oracleText: json["oracle_text"],
        power: json["power"],
        toughness: json["toughness"],
        cardFaces: json["card_faces"] != null
            ? List<CardFace>.from(
                json["card_faces"].map((x) => CardFace.fromJson(x)))
            : [],
        colors: json["colors"] != null
            ? List<String>.from(json["colors"].map((x) => x))
            : [],
        colorIdentity: json["color_identity"] != null
            ? List<String>.from(json["color_identity"].map((x) => x))
            : [],
        keywords: json["keywords"] != null
            ? List<String>.from(json["keywords"].map((x) => x))
            : [],
        producedMana: json["produced_mana"] != null
            ? List<String>.from(json["produced_mana"].map((x) => x))
            : [],
        legalities: Legalities.fromJson(json["legalities"]),
        games: List<String>.from(json["games"].map((x) => x)),
        reserved: json["reserved"],
        foil: json["foil"],
        nonfoil: json["nonfoil"],
        finishes: List<String>.from(json["finishes"].map((x) => x)),
        oversized: json["oversized"],
        promo: json["promo"],
        reprint: json["reprint"],
        variation: json["variation"],
        setId: json["set_id"],
        scryfallSet: json["set"],
        setName: json["set_name"],
        setType: json["set_type"],
        setUri: json["set_uri"],
        setSearchUri: json["set_search_uri"],
        scryfallSetUri: json["scryfall_set_uri"],
        rulingsUri: json["rulings_uri"],
        printsSearchUri: json["prints_search_uri"],
        collectorNumber: json["collector_number"],
        digital: json["digital"],
        rarity: json["rarity"],
        watermark: json["watermark"],
        flavorText: json["flavor_text"],
        cardBackId: json["card_back_id"],
        artist: json["artist"],
        artistIds: List<String>.from(json["artist_ids"].map((x) => x)),
        illustrationId: json["illustration_id"],
        borderColor: json["border_color"],
        frame: json["frame"],
        frameEffects: json["frame_effects"] != null
            ? List<String>.from(json["frame_effects"].map((x) => x))
            : [],
        securityStamp: json["security_stamp"],
        fullArt: json["full_art"],
        textless: json["textless"],
        booster: json["booster"],
        storySpotlight: json["story_spotlight"],
        edhrecRank: json["edhrec_rank"],
        preview: json["preview"] != null
            ? Preview.fromJson(json["preview"])
            : Preview(
                source: "",
                sourceUri: "",
                previewedAt: DateTime.now()), // come back here
        prices: Prices.fromJson(json["prices"]),
        relatedUris: json["related_uris"] != null
            ? RelatedUris.fromJson(json["related_uris"])
            : RelatedUris(
                gatherer: "",
                tcgplayerInfiniteArticles: "",
                tcgplayerInfiniteDecks: "",
                edhrec: "",
                mtgtop8: ""),
        purchaseUris: json["purchase_uris"] != null
            ? PurchaseUris.fromJson(json["purchase_uris"])
            : PurchaseUris(tcgplayer: "", cardmarket: "", cardhoarder: ""),
      );

  Map<String, dynamic> toJson() => {
        "card_faces": List<dynamic>.from(cardFaces!.map((x) => x.toJson())),
        "all_parts": List<dynamic>.from(allParts!.map((x) => x.toJson())),
        "object": object,
        "id": id,
        "oracle_id": oracleId,
        "multiverse_ids": List<dynamic>.from(multiverseIds!.map((x) => x)),
        "mtgo_id": mtgoId,
        "mtgo_foil_id": mtgoFoilId,
        "tcgplayer_id": tcgplayerId,
        "cardmarket_id": cardmarketId,
        "name": name,
        "lang": lang,
        "released_at":
            "${releasedAt?.year.toString().padLeft(4, '0')}-${releasedAt?.month.toString().padLeft(2, '0')}-${releasedAt?.day.toString().padLeft(2, '0')}",
        "uri": uri,
        "scryfall_uri": scryfallUri,
        "layout": layout,
        "highres_image": highresImage,
        "image_status": imageStatus,
        "image_uris": imageUris.toJson(),
        "mana_cost": manaCost,
        "cmc": cmc,
        "type_line": typeLine,
        "oracle_text": oracleText,
        "power": power,
        "toughness": toughness,
        "colors": List<dynamic>.from(colors!.map((x) => x)),
        "color_identity": List<dynamic>.from(colorIdentity!.map((x) => x)),
        "produced_mana": List<dynamic>.from(producedMana!.map((x) => x)),
        "keywords": List<dynamic>.from(keywords!.map((x) => x)),
        "legalities": legalities!.toJson(),
        "games": List<dynamic>.from(games!.map((x) => x)),
        "reserved": reserved,
        "foil": foil,
        "nonfoil": nonfoil,
        "finishes": List<dynamic>.from(finishes!.map((x) => x)),
        "oversized": oversized,
        "promo": promo,
        "reprint": reprint,
        "variation": variation,
        "set_id": setId,
        "set": scryfallSet,
        "set_name": setName,
        "set_type": setType,
        "set_uri": setUri,
        "set_search_uri": setSearchUri,
        "scryfall_set_uri": scryfallSetUri,
        "rulings_uri": rulingsUri,
        "prints_search_uri": printsSearchUri,
        "collector_number": collectorNumber,
        "digital": digital,
        "rarity": rarity,
        "watermark": watermark,
        "flavor_text": flavorText,
        "card_back_id": cardBackId,
        "artist": artist,
        "artist_ids": List<dynamic>.from(artistIds!.map((x) => x)),
        "illustration_id": illustrationId,
        "border_color": borderColor,
        "frame": frame,
        "frame_effects": List<dynamic>.from(frameEffects!.map((x) => x)),
        "security_stamp": securityStamp,
        "full_art": fullArt,
        "textless": textless,
        "booster": booster,
        "story_spotlight": storySpotlight,
        "edhrec_rank": edhrecRank,
        "preview": preview!.toJson(),
        "prices": prices!.toJson(),
        "related_uris": relatedUris!.toJson(),
        "purchase_uris": purchaseUris!.toJson(),
      };
}

class AllPart {
  AllPart({
    required this.object,
    required this.id,
    required this.component,
    required this.name,
    required this.typeLine,
    required this.uri,
  });

  String? object;
  String? id;
  String? component;
  String? name;
  String? typeLine;
  String? uri;

  factory AllPart.fromJson(Map<String, dynamic> json) => AllPart(
        object: json["object"],
        id: json["id"],
        component: json["component"],
        name: json["name"],
        typeLine: json["type_line"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "id": id,
        "component": component,
        "name": name,
        "type_line": typeLine,
        "uri": uri,
      };
}

class CardFace {
  CardFace({
    required this.object,
    required this.name,
    required this.manaCost,
    required this.typeLine,
    required this.oracleText,
    required this.colors,
    required this.power,
    required this.toughness,
    required this.flavorText,
    required this.artist,
    required this.artistId,
    required this.illustrationId,
    required this.imageUris,
    required this.flavorName,
    required this.colorIndicator,
    required this.watermark,
  });

  String? object;
  String? name;
  String? manaCost;
  String? typeLine;
  String? oracleText;
  List<String>? colors;
  String? power;
  String? toughness;
  String? flavorText;
  String? artist;
  String? artistId;
  String? watermark;
  String? illustrationId;
  ImageUris? imageUris;
  String? flavorName;
  List<String>? colorIndicator;

  factory CardFace.fromJson(Map<String, dynamic> json) => CardFace(
        object: json["object"],
        name: json["name"],
        manaCost: json["mana_cost"],
        typeLine: json["type_line"],
        oracleText: json["oracle_text"],
        watermark: json["watermark"] ?? "",
        colors: json["colors"] != null
            ? List<String>.from(json["colors"].map((x) => x))
            : [],
        power: json["power"],
        toughness: json["toughness"],
        flavorText: json["flavor_text"],
        artist: json["artist"],
        artistId: json["artist_id"],
        illustrationId: json["illustration_id"] ?? "",
        imageUris: json["image_uris"] != null
            ? ImageUris.fromJson(json["image_uris"])
            : ImageUris(
                small: "",
                normal: "",
                large: "",
                png: "",
                artCrop: "",
                borderCrop: "",
              ),
        flavorName: json["flavor_name"] ?? "",
        colorIndicator: json["color_indicator"] != null
            ? List<String>.from(json["color_indicator"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "name": name,
        "mana_cost": manaCost,
        "type_line": typeLine,
        "oracle_text": oracleText,
        "colors": List<dynamic>.from(colors!.map((x) => x)),
        "power": power,
        "watermark": watermark,
        "toughness": toughness,
        "flavor_text": flavorText,
        "artist": artist,
        "artist_id": artistId,
        "illustration_id": illustrationId,
        "image_uris": imageUris!.toJson(),
        "flavor_name": flavorName,
        "color_indicator": List<dynamic>.from(colorIndicator!.map((x) => x)),
      };
}

class Preview {
  Preview({
    required this.source,
    required this.sourceUri,
    required this.previewedAt,
  });

  String? source;
  String? sourceUri;
  DateTime? previewedAt;

  factory Preview.fromJson(Map<String, dynamic> json) => Preview(
        source: json["source"],
        sourceUri: json["source_uri"],
        previewedAt: DateTime.parse(json["previewed_at"]),
      );

  Map<String, dynamic> toJson() => {
        "source": source,
        "source_uri": sourceUri,
        "previewed_at":
            "${previewedAt?.year.toString().padLeft(4, '0')}-${previewedAt?.month.toString().padLeft(2, '0')}-${previewedAt?.day.toString().padLeft(2, '0')}",
      };
}

class ImageUris {
  ImageUris({
    required this.small,
    required this.normal,
    required this.large,
    required this.png,
    required this.artCrop,
    required this.borderCrop,
  });

  String? small;
  String? normal;
  String? large;
  String? png;
  String? artCrop;
  String? borderCrop;

  factory ImageUris.fromJson(Map<String, dynamic> json) => ImageUris(
        small: json["small"],
        normal: json["normal"],
        large: json["large"],
        png: json["png"],
        artCrop: json["art_crop"],
        borderCrop: json["border_crop"],
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "normal": normal,
        "large": large,
        "png": png,
        "art_crop": artCrop,
        "border_crop": borderCrop,
      };
}

class Legalities {
  Legalities({
    required this.standard,
    required this.future,
    required this.historic,
    required this.gladiator,
    required this.pioneer,
    required this.modern,
    required this.legacy,
    required this.pauper,
    required this.vintage,
    required this.penny,
    required this.commander,
    required this.brawl,
    required this.historicbrawl,
    required this.alchemy,
    required this.paupercommander,
    required this.duel,
    required this.oldschool,
    required this.premodern,
  });

  String? standard;
  String? future;
  String? historic;
  String? gladiator;
  String? pioneer;
  String? modern;
  String? legacy;
  String? pauper;
  String? vintage;
  String? penny;
  String? commander;
  String? brawl;
  String? historicbrawl;
  String? alchemy;
  String? paupercommander;
  String? duel;
  String? oldschool;
  String? premodern;

  factory Legalities.fromJson(Map<String, dynamic> json) => Legalities(
        standard: json["standard"],
        future: json["future"],
        historic: json["historic"],
        gladiator: json["gladiator"],
        pioneer: json["pioneer"],
        modern: json["modern"],
        legacy: json["legacy"],
        pauper: json["pauper"],
        vintage: json["vintage"],
        penny: json["penny"],
        commander: json["commander"],
        brawl: json["brawl"],
        historicbrawl: json["historicbrawl"],
        alchemy: json["alchemy"],
        paupercommander: json["paupercommander"],
        duel: json["duel"],
        oldschool: json["oldschool"],
        premodern: json["premodern"],
      );

  Map<String, dynamic> toJson() => {
        "standard": standard,
        "future": future,
        "historic": historic,
        "gladiator": gladiator,
        "pioneer": pioneer,
        "modern": modern,
        "legacy": legacy,
        "pauper": pauper,
        "vintage": vintage,
        "penny": penny,
        "commander": commander,
        "brawl": brawl,
        "historicbrawl": historicbrawl,
        "alchemy": alchemy,
        "paupercommander": paupercommander,
        "duel": duel,
        "oldschool": oldschool,
        "premodern": premodern,
      };
}

class Prices {
  Prices({
    required this.usd,
    required this.usdFoil,
    required this.usdEtched,
    required this.eur,
    required this.eurFoil,
    required this.tix,
  });

  String? usd;
  String? usdFoil;
  dynamic usdEtched;
  String? eur;
  String? eurFoil;
  String? tix;

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        usd: json["usd"],
        usdFoil: json["usd_foil"],
        usdEtched: json["usd_etched"],
        eur: json["eur"],
        eurFoil: json["eur_foil"],
        tix: json["tix"],
      );

  Map<String, dynamic> toJson() => {
        "usd": usd,
        "usd_foil": usdFoil,
        "usd_etched": usdEtched,
        "eur": eur,
        "eur_foil": eurFoil,
        "tix": tix,
      };
}

class PurchaseUris {
  PurchaseUris({
    required this.tcgplayer,
    required this.cardmarket,
    required this.cardhoarder,
  });

  String tcgplayer;
  String cardmarket;
  String cardhoarder;

  factory PurchaseUris.fromJson(Map<String, dynamic> json) => PurchaseUris(
        tcgplayer: json["tcgplayer"],
        cardmarket: json["cardmarket"],
        cardhoarder: json["cardhoarder"],
      );

  Map<String, dynamic> toJson() => {
        "tcgplayer": tcgplayer,
        "cardmarket": cardmarket,
        "cardhoarder": cardhoarder,
      };
}

class RelatedUris {
  RelatedUris({
    required this.gatherer,
    required this.tcgplayerInfiniteArticles,
    required this.tcgplayerInfiniteDecks,
    required this.edhrec,
    required this.mtgtop8,
  });

  String? gatherer;
  String? tcgplayerInfiniteArticles;
  String? tcgplayerInfiniteDecks;
  String? edhrec;
  String? mtgtop8;

  factory RelatedUris.fromJson(Map<String, dynamic> json) => RelatedUris(
        gatherer: json["gatherer"],
        tcgplayerInfiniteArticles: json["tcgplayer_infinite_articles"],
        tcgplayerInfiniteDecks: json["tcgplayer_infinite_decks"],
        edhrec: json["edhrec"],
        mtgtop8: json["mtgtop8"],
      );

  Map<String, dynamic> toJson() => {
        "gatherer": gatherer,
        "tcgplayer_infinite_articles": tcgplayerInfiniteArticles,
        "tcgplayer_infinite_decks": tcgplayerInfiniteDecks,
        "edhrec": edhrec,
        "mtgtop8": mtgtop8,
      };
}
