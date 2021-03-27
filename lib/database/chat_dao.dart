import 'package:sembast/sembast.dart';
import 'package:flutter_ble_messenger/database/app_database.dart';
import 'package:flutter_ble_messenger/model/chat.dart';

class ChatDao {
  static const String CHAT_STORE_NAME = 'chat';

  final _chatStore = intMapStoreFactory.store(CHAT_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Chat chat) async {
    await _chatStore.add(await _db,chat.toMap());
  }

  Future update(Chat chat) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(chat.chatId));
    await _chatStore.update(
      await _db,
      chat.toMap(),
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

  Future<List<Chat>> getAll() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('receiverName'),
    ]);

    final recordSnapshots = await _chatStore.find(
      await _db,
      //finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final fruit = Chat.fromJson(snapshot.value);
      return fruit;
    }).toList();
  }

  Future<List<Chat>> findChat(String chatId) async {

    final finder = Finder(
        filter: Filter.and([
          Filter.equals("chatId",chatId),
        ])
    );
    final recordSnapshots = await _chatStore.find(
        await _db,
        finder: finder
    );
    return recordSnapshots.map((snapshot) {
      final fruit = Chat.fromJson(snapshot.value);
      return fruit;
    }).toList();
  }
}