import 'package:isar/isar.dart';

part 'page_counter.g.dart';

@collection
class PageCounter {
  PageCounter({this.leftPages = 0, this.rightPages = 0});

  Id id = 0;
  int leftPages;
  int rightPages;
}
