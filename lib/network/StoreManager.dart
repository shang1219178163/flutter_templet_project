
class StoreManager {

  static final StoreManager _instance = StoreManager._();
  StoreManager._();
  factory StoreManager() => _instance;
  static StoreManager get instance => _instance;

}