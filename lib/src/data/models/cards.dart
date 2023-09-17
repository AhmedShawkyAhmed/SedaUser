class Cards {
  List<Card> cards = [];

  Cards();

  Cards.fromJson(Map<String, dynamic> json) {
    if (json['cards'] != null) {
      cards = <Card>[];
      json['cards'].forEach((v) {
        cards.add(Card.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['cards'] = cards.map((v) => v.toJson()).toList();

    return data;
  }
}

class Card {
  int? id;
  int? userId;
  String? cardDigits;

  Card({this.id, this.userId, this.cardDigits});

  Card.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cardDigits = json['cardDigits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['cardDigits'] = cardDigits;
    return data;
  }
}
