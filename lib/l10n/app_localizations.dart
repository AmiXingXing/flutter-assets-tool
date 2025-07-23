import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flutter Assets Tool'**
  String get appTitle;

  /// Label for workspace directory
  ///
  /// In en, this message translates to:
  /// **'Workspace Directory:'**
  String get workspaceDirectory;

  /// Text when no workspace is selected
  ///
  /// In en, this message translates to:
  /// **'No workspace selected'**
  String get noWorkspaceSelected;

  /// Button text for selecting workspace directory
  ///
  /// In en, this message translates to:
  /// **'Select Workspace Directory'**
  String get selectWorkspaceDirectory;

  /// Label for recently used workspaces
  ///
  /// In en, this message translates to:
  /// **'Recently Used:'**
  String get recentlyUsed;

  /// Label for image storage directory
  ///
  /// In en, this message translates to:
  /// **'Image Storage Directory:'**
  String get imageStorageDirectory;

  /// Hint text for image storage directory
  ///
  /// In en, this message translates to:
  /// **'assets/images/'**
  String get imageStorageDirectoryHint;

  /// Label for image selection
  ///
  /// In en, this message translates to:
  /// **'Select Image:'**
  String get selectImage;

  /// Button text for picking image
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;

  /// Label for original file name
  ///
  /// In en, this message translates to:
  /// **'Original File Name'**
  String get originalFileName;

  /// Label for image resolution
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get resolution;

  /// Label for file path
  ///
  /// In en, this message translates to:
  /// **'File Path'**
  String get filePath;

  /// Label for 2x image
  ///
  /// In en, this message translates to:
  /// **'2x Image'**
  String get image2x;

  /// Label for 3x image
  ///
  /// In en, this message translates to:
  /// **'3x Image'**
  String get image3x;

  /// Label for import settings
  ///
  /// In en, this message translates to:
  /// **'Import Settings:'**
  String get importSettings;

  /// Label for image name input
  ///
  /// In en, this message translates to:
  /// **'Image Name'**
  String get imageName;

  /// Hint text for image name input
  ///
  /// In en, this message translates to:
  /// **'e.g.: img_icon.png'**
  String get imageNameHint;

  /// Label for enable image resize checkbox
  ///
  /// In en, this message translates to:
  /// **'Enable Image Resize'**
  String get enableImageResize;

  /// Label for target resolution
  ///
  /// In en, this message translates to:
  /// **'Target Resolution:'**
  String get targetResolution;

  /// Label for width input
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// Label for height input
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// Hint text for width input
  ///
  /// In en, this message translates to:
  /// **'40'**
  String get widthHint;

  /// Hint text for height input
  ///
  /// In en, this message translates to:
  /// **'40'**
  String get heightHint;

  /// Text showing auto generation info
  ///
  /// In en, this message translates to:
  /// **'Will auto generate: 2x image, 3x image'**
  String get autoGenerateInfo;

  /// Label for resource class name input
  ///
  /// In en, this message translates to:
  /// **'Resource Class Name'**
  String get resourceClassName;

  /// Hint text for resource class name input
  ///
  /// In en, this message translates to:
  /// **'e.g.: ImgR'**
  String get resourceClassNameHint;

  /// Button text for selecting file
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// Button text for adding to project
  ///
  /// In en, this message translates to:
  /// **'Add to Project'**
  String get addToProject;

  /// Success message title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Error message title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message for image addition
  ///
  /// In en, this message translates to:
  /// **'Image added to project successfully!'**
  String get imageAddedSuccessfully;

  /// Error message when workspace not selected
  ///
  /// In en, this message translates to:
  /// **'Please select workspace directory first'**
  String get pleaseSelectWorkspace;

  /// Error message when image not selected
  ///
  /// In en, this message translates to:
  /// **'Please select image first'**
  String get pleaseSelectImage;

  /// Error message when image name not entered
  ///
  /// In en, this message translates to:
  /// **'Please enter image name'**
  String get pleaseEnterImageName;

  /// Error message when add operation fails
  ///
  /// In en, this message translates to:
  /// **'Add failed'**
  String get addFailed;

  /// Error message when checking image info fails
  ///
  /// In en, this message translates to:
  /// **'Error checking image info'**
  String get checkImageInfoError;

  /// Error message when image file cannot be parsed
  ///
  /// In en, this message translates to:
  /// **'Cannot parse image file'**
  String get cannotParseImageFile;

  /// Error message when image already exists
  ///
  /// In en, this message translates to:
  /// **'Image already exists in pubspec.yaml'**
  String get imageAlreadyExists;

  /// Error message when flutter node not found
  ///
  /// In en, this message translates to:
  /// **'Flutter node not found'**
  String get flutterNodeNotFound;

  /// Error message when variable already exists
  ///
  /// In en, this message translates to:
  /// **'Variable already exists in file'**
  String get variableAlreadyExists;

  /// Label for selected resource class
  ///
  /// In en, this message translates to:
  /// **'Selected resource class'**
  String get selectedResourceClass;

  /// Error message when class definition cannot be found
  ///
  /// In en, this message translates to:
  /// **'Cannot find class definition from file'**
  String get cannotFindClassDefinition;

  /// Error message when file reading fails
  ///
  /// In en, this message translates to:
  /// **'Read file failed'**
  String get readFileFailed;

  /// Error message when workspace not selected first
  ///
  /// In en, this message translates to:
  /// **'Please select workspace directory first'**
  String get pleaseSelectWorkspaceFirst;

  /// Text for 'in file'
  ///
  /// In en, this message translates to:
  /// **' in file '**
  String get inFile;

  /// Text for end of 'in file' message
  ///
  /// In en, this message translates to:
  /// **''**
  String get inFileEnd;

  /// Error message when file format is incorrect
  ///
  /// In en, this message translates to:
  /// **' file format is incorrect'**
  String get fileFormatIncorrect;

  /// Title for asset overwrite confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Asset Already Exists'**
  String get assetOverwriteTitle;

  /// Message for asset overwrite confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'The asset already exists in pubspec.yaml. Do you want to overwrite it?'**
  String get assetOverwriteMessage;

  /// Button text for overwrite confirmation
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite;

  /// Button text for cancel operation
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
