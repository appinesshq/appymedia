enum MediaType {
  Text,
  Video,
  ShortVideo,
}

class Platform {
  String id;
  String name;
  List<MediaType> supportedMediaTypes;

  Platform({this.id, this.name, this.supportedMediaTypes});

  Platform.fromMap(Map<String, dynamic> map, {String id})
      : id = id,
        name = map['name'] ?? '',
        supportedMediaTypes = map['supported_media_types'] ?? [];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'supperted_media_types': supportedMediaTypes,
    };
  }
}
