import 'package:sembast/sembast.dart';
import 'package:flutter_ble_messenger/database/app_database.dart';
import 'package:flutter_ble_messenger/model/discussion.dart';

class DiscussionDao{

   static const String DISCUSSION_STORE_NAME = 'discussions';
   final _chatStore = intMapStoreFactory.store(DISCUSSION_STORE_NAME);

   Future<Database> get _db async => await AppDatabase.instance.database;

   Future insert(Discussion discussion) async {
     await _chatStore.add(await _db,discussion.toMap());
   }

   Future update(Discussion discussion) async {
     // For filtering by key (ID), RegEx, greater than, and many other criteria,
     // we use a Finder.
     final finder = Finder(filter: Filter.byKey(discussion.chatId));
     await _chatStore.update(
       await _db,
       discussion.toMap(),
       finder: finder,
     );
   }

   Future delete(String chatId) async {
     final finder = Finder(filter: Filter.and([
       Filter.equals("chatId",chatId)
     ])
     );
     await _chatStore.delete(
       await _db,
       finder: finder,
     );
   }

   Future<List<Discussion>> getAll(String chatId) async {
     // Finder object can also sort data.
     final finder = Finder(
       filter: Filter.and([
         Filter.equals("chatId",chatId),
       ])
     );

     final recordSnapshots = await _chatStore.find(
       await _db,
       //finder: finder,
     );

     // Making a List<Fruit> out of List<RecordSnapshot>
     return recordSnapshots.map((snapshot) {
       final fruit = Discussion.fromJson(snapshot.value);
       return fruit;
     }).toList();
   }

}