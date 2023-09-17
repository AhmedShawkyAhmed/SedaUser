class DriverImages {
  DriverImages({
    this.captenLeciens,
  });

  DriverImages.fromJson(dynamic json) {
    captenLeciens = json['capten_leciens'];
  }

  String? captenLeciens;

  DriverImages copyWith({
    String? captenLeciens,
  }) =>
      DriverImages(
        captenLeciens: captenLeciens ?? this.captenLeciens,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['capten_leciens'] = captenLeciens;
    return map;
  }
}
