import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as path;

class Storage {
  static final Storage _storageInstance = Storage._();
  FirebaseStorage storage = FirebaseStorage.instance;
  factory Storage() {
    return _storageInstance;
  }

  Storage._();

  Future<String?> uploadFile(
      XFile mediaInfo, String ref, String fileName, Uint8List bytes) async {
    try {
      String? mimeType = mime(path.basename(mediaInfo.name));

      final String? extension = extensionFromMime(mimeType!);

      var metadata = SettableMetadata(
        contentType: mimeType,
      );
      Reference storageReference =
          storage.ref(ref).child("$fileName.$extension");
      var task = await storageReference.putData(bytes, metadata);
      String url = await task.ref.getDownloadURL();
      return url;
    } catch (e) {
      print("File Upload Error $e");
      return null;
    }
  }
}
