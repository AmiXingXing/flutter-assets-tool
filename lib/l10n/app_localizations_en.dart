// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Assets Tool';

  @override
  String get workspaceDirectory => 'Workspace Directory:';

  @override
  String get noWorkspaceSelected => 'No workspace selected';

  @override
  String get selectWorkspaceDirectory => 'Select Workspace Directory';

  @override
  String get recentlyUsed => 'Recently Used:';

  @override
  String get imageStorageDirectory => 'Image Storage Directory:';

  @override
  String get imageStorageDirectoryHint => 'assets/images/';

  @override
  String get selectImage => 'Select Image:';

  @override
  String get pickImage => 'Pick Image';

  @override
  String get originalFileName => 'Original File Name';

  @override
  String get resolution => 'Resolution';

  @override
  String get filePath => 'File Path';

  @override
  String get image2x => '2x Image';

  @override
  String get image3x => '3x Image';

  @override
  String get importSettings => 'Import Settings:';

  @override
  String get imageName => 'Image Name';

  @override
  String get imageNameHint => 'e.g.: img_icon.png';

  @override
  String get enableImageResize => 'Enable Image Resize';

  @override
  String get targetResolution => 'Target Resolution:';

  @override
  String get width => 'Width';

  @override
  String get height => 'Height';

  @override
  String get widthHint => '40';

  @override
  String get heightHint => '40';

  @override
  String get autoGenerateInfo => 'Will auto generate: 2x image, 3x image';

  @override
  String get resourceClassName => 'Resource Class Name';

  @override
  String get resourceClassNameHint => 'e.g.: ImgR';

  @override
  String get selectFile => 'Select File';

  @override
  String get addToProject => 'Add to Project';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get imageAddedSuccessfully => 'Image added to project successfully!';

  @override
  String get pleaseSelectWorkspace => 'Please select workspace directory first';

  @override
  String get pleaseSelectImage => 'Please select image first';

  @override
  String get pleaseEnterImageName => 'Please enter image name';

  @override
  String get addFailed => 'Add failed';

  @override
  String get checkImageInfoError => 'Error checking image info';

  @override
  String get cannotParseImageFile => 'Cannot parse image file';

  @override
  String get imageAlreadyExists => 'Image already exists in pubspec.yaml';

  @override
  String get flutterNodeNotFound => 'Flutter node not found';

  @override
  String get variableAlreadyExists => 'Variable already exists in file';

  @override
  String get selectedResourceClass => 'Selected resource class';

  @override
  String get cannotFindClassDefinition =>
      'Cannot find class definition from file';

  @override
  String get readFileFailed => 'Read file failed';

  @override
  String get pleaseSelectWorkspaceFirst =>
      'Please select workspace directory first';

  @override
  String get inFile => ' in file ';

  @override
  String get inFileEnd => '';

  @override
  String get fileFormatIncorrect => ' file format is incorrect';
}
