import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'COIN_API_KEY', obfuscate: true)
  static final coinApiKey = _Env.coinApiKey;
}
