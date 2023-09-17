class MediaModel {
  int? id;
  String? filename;
  String? filetype;
  String? type;
  int? createById;
  String? createByType;
  int? createdAt;
  String? createdAtStr;

  MediaModel(
      {this.filename,
        this.filetype,
        this.id,
        this.type,
        this.createById,
        this.createByType,
        this.createdAt,
        this.createdAtStr});

  MediaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filename = json['filename'];
    filetype = json['filetype'];
    type = json['type'];
    createById = json['createBy_id'];
    createByType = json['createBy_type'];
    createdAt = json['created_at'];
    createdAtStr = json['created_at_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['filename'] = filename;
    data['filetype'] = filetype;
    data['type'] = type;
    data['createBy_id'] = createById;
    data['createBy_type'] = createByType;
    data['created_at'] = createdAt;
    data['created_at_str'] = createdAtStr;
    return data;
  }
}