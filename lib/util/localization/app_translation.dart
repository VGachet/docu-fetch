mixin AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    'en_US': enUS,
    'fr': fr
  };
}

final Map<String, String> enUS = {
  'home': 'Home',
  'an_error_occured': 'An error occured',
  'trending': 'Trending',
  'coins': 'Coins',
};

final Map<String, String> fr = {
  'home': 'Accueil',
  'an_error_occured': 'Une erreur est survenue',
  'trending': 'Tendance',
  'coins': 'Jetons',
};
