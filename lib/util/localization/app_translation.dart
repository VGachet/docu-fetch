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
  'error_downloading_pdf': 'Error while downloading the PDF: @pdfTitle',
  'error_saving_pdf': 'Error while saving the PDF: @pdfTitle',
  'error_retrieving_pdf_list': 'Error retrieving the PDF list',
  'error_deleting_pdf': 'Error deleting the PDF: @pdfTitle',
  'error_saving_repository': 'Error saving the repository',
  'error_retrieving_repository': 'Error retrieving the repository list',
  'pdf_already_downloaded':
      '@pdfTitle is already downloaded (version: @pdfVersion)',
  'downloading': '@currentDownloadedSize mo / @totalSize mo',
  'version': 'Version: @version',
  'error_renaming_pdf': 'Error renaming the PDF: @pdfTitle',
  'rename': 'Rename',
  'open': 'Open',
  'delete': 'Delete',
  'enter_new_pdf_name': 'Enter a new name for the PDF',
  'delete_pdf_confirmation':
      'Are you sure you want to delete the PDF @pdfTitle?',
  'all_documents': 'All documents',
  'create_folder': 'Create a new folder',
  'enter_folder_name': 'Enter a folder name',
  'enter_new_folder_name': 'Enter a new name for the folder',
  'error_update_last_page_opened': 'Error updating the last page opened',
  'error_deleting_folder': 'Error deleting the folder: @folderTitle',
  'delete_folder_confirmation':
      'Are you sure you want to delete the folder @folderTitle?',
  'delete_selected_pdfs_confirmation':
      'Are you sure you want to delete the selected PDFs?',
  'docufetch_tutorial': 'DocuFetch Tutorial',
};

final Map<String, String> fr = {
  'home': 'Accueil',
  'an_error_occured': 'Une erreur est survenue',
  'enter_json_repo_url': "Entrer l'URL JSON d'un dépôt DocuFetch",
  'add_pdf_from_url': 'Ajouter un/des PDF depuis une URL',
  'add_pdf_from_file': 'Ajouter un/des PDF depuis un fichier',
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
  'error_downloading_pdf': 'Erreur lors du téléchargement du PDF: @pdfTitle',
  'error_saving_pdf': 'Erreur lors de la sauvegarde du PDF: @pdfTitle',
  'error_retrieving_pdf_list':
      'Erreur lors de la récupération de la liste des PDF',
  'error_deleting_pdf': 'Erreur lors de la suppression du PDF: @pdfTitle',
  'error_saving_repository': 'Erreur lors de la sauvegarde du dépôt',
  'error_retrieving_repository':
      'Erreur lors de la récupération de la liste des dépôts',
  'pdf_already_downloaded':
      '@pdfTitle est déjà téléchargé (version: @pdfVersion)',
  'downloading': '@currentDownloadedSize mo / @totalSize mo',
  'version': 'Version: @version',
  'error_renaming_pdf': 'Erreur lors du renommage du PDF: @pdfTitle',
  'rename': 'Renommer',
  'open': 'Ouvrir',
  'delete': 'Supprimer',
  'enter_new_pdf_name': 'Entrer un nouveau nom pour le PDF',
  'delete_pdf_confirmation':
      'Êtes-vous sûr de vouloir supprimer le PDF @pdfTitle ?',
  'all_documents': 'Tous les documents',
  'create_folder': 'Créer un nouveau dossier',
  'enter_folder_name': 'Entrer un nom de dossier',
  'enter_new_folder_name': 'Entrer un nouveau nom pour le dossier',
  'error_update_last_page_opened':
      "Erreur lors de la mise à jour de la dernière page ouverte",
  'error_deleting_folder':
      'Erreur lors de la suppression du dossier: @folderTitle',
  'delete_folder_confirmation':
      'Êtes-vous sûr de vouloir supprimer le dossier @folderTitle ?',
  'delete_selected_pdfs_confirmation':
      'Êtes-vous sûr de vouloir supprimer les PDF sélectionnés ?',
  'docufetch_tutorial': 'Tutoriel DocuFetch',
};
