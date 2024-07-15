mixin AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    'en_US': enUS,
    'fr': fr
  };
}

final Map<String, String> enUS = {
  'home': 'Home',
  'an_error_occured': 'An error occured',
  'enter_url_json': 'Enter a JSON file URL',
};

final Map<String, String> fr = {
  'home': 'Accueil',
  'an_error_occured': 'Une erreur est survenue',
  'enter_url_json': 'Entrez une URL de fichier JSON',
};
