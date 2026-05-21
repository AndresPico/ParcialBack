enum Flavor { dev, prod }

class AppEnvironment {
  AppEnvironment._();

  static late final Flavor flavor;
  static late final String baseUrl;
  static late final String wsUrl;

  static void configure(Flavor value) {
    flavor = value;
    switch (value) {
      case Flavor.dev:
        baseUrl = const String.fromEnvironment(
          'DEV_BASE_URL',
          defaultValue: 'http://10.0.2.2:8080',
        );
        wsUrl = const String.fromEnvironment(
          'DEV_WS_URL',
          defaultValue: 'ws://10.0.2.2:8080/ws',
        );
      case Flavor.prod:
        baseUrl = const String.fromEnvironment(
          'PROD_BASE_URL',
          defaultValue: 'https://api.labapp.com',
        );
        wsUrl = const String.fromEnvironment(
          'PROD_WS_URL',
          defaultValue: 'wss://api.labapp.com/ws',
        );
    }
  }
}
