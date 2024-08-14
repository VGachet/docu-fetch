mixin AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    'en_US': enUS,
    'fr': fr
  };
}

final Map<String, String> enUS = {
  'home': 'Home',
  'an_error_occured': 'An error occured',
  'enter_json_repo_url': 'Enter the JSON URL of a DocuFetch repository',
  'add_pdf_from_url': 'Add PDF from URL',
  'add_pdf_from_file': 'Add PDF from file',
  'validate': 'Validate',
  'cancel': 'Cancel',
  'empty_pdf_list':
      'PDF List is empty. Select the "☰" button to download/import PDF',
  'downloading_pdf': 'Downloading PDF...',
  'url_already_saved': 'This URL already exists in your repository list',
  'enter_repo_name': 'Enter a name for the repository',
  'repo_name_example': 'Example : DocuFetch Repository',
  'json_repo_url_example': 'Example : https://example.com/file.json',
  'no_json_found_repo': 'No DocuFetch JSON file found in this repository',
  'no_json_url': 'No JSON URL found. Please enter a valid JSON URL',
  'repository_list': 'Your repository list',
  'close': 'Close',
  'delete_repo_error': 'An error occured while deleting the repository',
  'error_downloading_files': 'Error downloading files',
};

final Map<String, String> fr = {
  'home': 'Accueil',
  'an_error_occured': 'Une erreur est survenue',
  'enter_json_repo_url': "Entrer l'URL JSON d'un dépôt DocuFetch",
  'add_pdf_from_url': 'Ajouter un PDF depuis une URL',
  'add_pdf_from_file': 'Ajouter un PDF depuis un fichier',
  'validate': 'Valider',
  'cancel': 'Annuler',
  'empty_pdf_list':
      'Liste de PDF vide. Sélectionner le bouton "☰" pour importer/télécharger des PDF',
  'downloading_pdf': 'Téléchargement en cours...',
  'url_already_saved': 'Cette URL existe déjà dans votre liste de dépôts',
  'enter_repo_name': 'Entrer un nom pour le dépôt',
  'repo_name_example': 'Exemple : Dépôt DocuFetch',
  'json_repo_url_example': 'Exemple : https://example.com/fichier.json',
  'no_json_found_repo': 'Aucun fichier JSON DocuFetch trouvé dans ce dépôt',
  'no_json_url': 'Aucune URL JSON trouvée. Veuillez entrer une URL JSON valide',
  'repository_list': 'Liste de vos dépôts',
  'close': 'Fermer',
  'delete_repo_error':
      'Une erreur est survenue lors de la suppression du dépôt',
  'error_downloading_files': 'Erreur lors du téléchargement des fichiers',
};
