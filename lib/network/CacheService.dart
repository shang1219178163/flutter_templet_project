
class CacheService {

  static final CacheService _instance = CacheService._();
  CacheService._();
  factory CacheService() => _instance;
  static CacheService get instance => _instance;

}