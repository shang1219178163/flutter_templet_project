

class StorageManager {

  static final StorageManager _instance = StorageManager._();
  StorageManager._();
  factory StorageManager() => _instance;
  static StorageManager get instance => _instance;

}