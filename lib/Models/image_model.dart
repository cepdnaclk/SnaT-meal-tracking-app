import 'dart:typed_data';

class ImageModel {
  String? name;
  String? url;
  String? assetAddress;
  Uint8List? bytes;
  String? path;
  int? size;

  ImageModel(
      {this.name,
      this.path,
      this.bytes,
      this.size,
      this.url,
      this.assetAddress});
}
