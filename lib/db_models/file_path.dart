import 'package:isar/isar.dart';
part 'file_path.g.dart';

@embedded
class FilePath {
  String? url;
  String? localPath;
  FilePath({this.url, this.localPath});
}
