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
  'add_pdf_from_url': 'Add PDF from URL',
  'add_pdf_from_file': 'Add PDF from file',
  'validate': 'Validate',
  'cancel': 'Cancel',
  'empty_pdf_list':
      'PDF List is empty. Select the "+" button to download/import PDF',
  'downloading_pdf': 'Downloading PDF...'
};

final Map<String, String> fr = {
  'home': 'Accueil',
  'an_error_occured': 'Une erreur est survenue',
  'enter_url_json': 'Entrez une URL de fichier JSON',
  'add_pdf_from_url': 'Ajouter un PDF depuis une URL',
  'add_pdf_from_file': 'Ajouter un PDF depuis un fichier',
  'validate': 'Valider',
  'cancel': 'Annuler',
  'empty_pdf_list':
      'Liste de PDF vide. Sélectionner le bouton "+" pour importer/télécharger des PDF',
  'downloading_pdf': 'Téléchargement en cours...'
};
