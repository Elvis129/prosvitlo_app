import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_uk.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('uk')];

  /// Назва додатку
  ///
  /// In uk, this message translates to:
  /// **'ProСвітло'**
  String get appTitle;

  /// No description provided for @ok.
  ///
  /// In uk, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In uk, this message translates to:
  /// **'Закрити'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In uk, this message translates to:
  /// **'Спробувати ще раз'**
  String get retry;

  /// No description provided for @later.
  ///
  /// In uk, this message translates to:
  /// **'Пізніше'**
  String get later;

  /// No description provided for @error.
  ///
  /// In uk, this message translates to:
  /// **'Помилка'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In uk, this message translates to:
  /// **'Завантаження...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In uk, this message translates to:
  /// **'Немає даних'**
  String get noData;

  /// No description provided for @copy.
  ///
  /// In uk, this message translates to:
  /// **'Копіювати'**
  String get copy;

  /// No description provided for @support.
  ///
  /// In uk, this message translates to:
  /// **'Підтримати'**
  String get support;

  /// No description provided for @alreadySupported.
  ///
  /// In uk, this message translates to:
  /// **'Я вже підтримав'**
  String get alreadySupported;

  /// No description provided for @errorLoadingData.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося завантажити дані'**
  String get errorLoadingData;

  /// No description provided for @errorOpeningLink.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося відкрити посилання'**
  String get errorOpeningLink;

  /// No description provided for @errorLoadingImage.
  ///
  /// In uk, this message translates to:
  /// **'Помилка завантаження зображення'**
  String get errorLoadingImage;

  /// No description provided for @errorLoadingAddress.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося отримати інформацію про адресу'**
  String get errorLoadingAddress;

  /// No description provided for @errorAddressAlreadyAdded.
  ///
  /// In uk, this message translates to:
  /// **'Ця адреса вже додана'**
  String get errorAddressAlreadyAdded;

  /// No description provided for @homeTitle.
  ///
  /// In uk, this message translates to:
  /// **'Головна'**
  String get homeTitle;

  /// No description provided for @homeNoAddressesTitle.
  ///
  /// In uk, this message translates to:
  /// **'Адрес ще немає'**
  String get homeNoAddressesTitle;

  /// No description provided for @homeNoAddressesDescription.
  ///
  /// In uk, this message translates to:
  /// **'Додайте адреси для відстеження статусу електропостачання'**
  String get homeNoAddressesDescription;

  /// No description provided for @homeAddAddress.
  ///
  /// In uk, this message translates to:
  /// **'Додати адресу'**
  String get homeAddAddress;

  /// No description provided for @homeAddOneMoreAddress.
  ///
  /// In uk, this message translates to:
  /// **'Додати ще одну адресу'**
  String get homeAddOneMoreAddress;

  /// No description provided for @homePowerOn.
  ///
  /// In uk, this message translates to:
  /// **'Є світло'**
  String get homePowerOn;

  /// No description provided for @homePowerOff.
  ///
  /// In uk, this message translates to:
  /// **'Відключення'**
  String get homePowerOff;

  /// No description provided for @homeActive.
  ///
  /// In uk, this message translates to:
  /// **'АКТИВНЕ'**
  String get homeActive;

  /// No description provided for @donationBannerTitle.
  ///
  /// In uk, this message translates to:
  /// **'Зарядити розробника'**
  String get donationBannerTitle;

  /// No description provided for @donationBannerSubtitle.
  ///
  /// In uk, this message translates to:
  /// **'Підтримати розробку додатка ☕'**
  String get donationBannerSubtitle;

  /// No description provided for @donationDialogTitle.
  ///
  /// In uk, this message translates to:
  /// **'Підтримай проєкт'**
  String get donationDialogTitle;

  /// No description provided for @donationDialogMessage.
  ///
  /// In uk, this message translates to:
  /// **'Додаток безкоштовний і підтримується зусиллями розробника. Твоя підтримка допоможе розвивати функціонал і підтримувати сервіс.'**
  String get donationDialogMessage;

  /// No description provided for @donationCardNumberTitle.
  ///
  /// In uk, this message translates to:
  /// **'Номер картки'**
  String get donationCardNumberTitle;

  /// No description provided for @donationCardNumberLabel.
  ///
  /// In uk, this message translates to:
  /// **'Підтримка розробника:'**
  String get donationCardNumberLabel;

  /// No description provided for @outageTypeEmergency.
  ///
  /// In uk, this message translates to:
  /// **'АВАРІЙНЕ'**
  String get outageTypeEmergency;

  /// No description provided for @outageTypePlanned.
  ///
  /// In uk, this message translates to:
  /// **'ПЛАНОВЕ'**
  String get outageTypePlanned;

  /// No description provided for @outageTypeScheduled.
  ///
  /// In uk, this message translates to:
  /// **'ГРАФІК'**
  String get outageTypeScheduled;

  /// No description provided for @outageEmergencyTitle.
  ///
  /// In uk, this message translates to:
  /// **'Аварійні відключення:'**
  String get outageEmergencyTitle;

  /// No description provided for @outagePlannedTitle.
  ///
  /// In uk, this message translates to:
  /// **'Планові відключення:'**
  String get outagePlannedTitle;

  /// Тип статусу відключення
  ///
  /// In uk, this message translates to:
  /// **'Тип: {type}'**
  String outageStatusType(String type);

  /// No description provided for @outageStatusPlanned.
  ///
  /// In uk, this message translates to:
  /// **'Тип: Планове відключення'**
  String get outageStatusPlanned;

  /// No description provided for @outageStatusActive.
  ///
  /// In uk, this message translates to:
  /// **'Тип: Електропостачання активне'**
  String get outageStatusActive;

  /// No description provided for @outageTodayTitle.
  ///
  /// In uk, this message translates to:
  /// **'Відключення сьогодні:'**
  String get outageTodayTitle;

  /// No description provided for @outageTomorrowTitle.
  ///
  /// In uk, this message translates to:
  /// **'Відключення на завтра:'**
  String get outageTomorrowTitle;

  /// No description provided for @outageNoMoreToday.
  ///
  /// In uk, this message translates to:
  /// **'Більше відключень на сьогодні не заплановано'**
  String get outageNoMoreToday;

  /// No description provided for @settingsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get settingsTitle;

  /// No description provided for @settingsMyAddresses.
  ///
  /// In uk, this message translates to:
  /// **'Мої адреси'**
  String get settingsMyAddresses;

  /// No description provided for @settingsAddAddress.
  ///
  /// In uk, this message translates to:
  /// **'Додати'**
  String get settingsAddAddress;

  /// No description provided for @settingsAppearance.
  ///
  /// In uk, this message translates to:
  /// **'Вигляд'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeLight.
  ///
  /// In uk, this message translates to:
  /// **'Світла тема'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In uk, this message translates to:
  /// **'Темна тема'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In uk, this message translates to:
  /// **'Системна'**
  String get settingsThemeSystem;

  /// No description provided for @settingsNotifications.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsEnable.
  ///
  /// In uk, this message translates to:
  /// **'Увімкнути сповіщення'**
  String get settingsNotificationsEnable;

  /// No description provided for @settingsNotificationsDescription.
  ///
  /// In uk, this message translates to:
  /// **'Отримувати повідомлення про відключення'**
  String get settingsNotificationsDescription;

  /// No description provided for @settingsDeleteAddressTitle.
  ///
  /// In uk, this message translates to:
  /// **'Видалити адресу?'**
  String get settingsDeleteAddressTitle;

  /// Підтвердження видалення адреси
  ///
  /// In uk, this message translates to:
  /// **'Ви впевнені що хочете видалити \"{addressName}\"?'**
  String settingsDeleteAddressMessage(String addressName);

  /// No description provided for @settingsDisableNotificationsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Вимкнути сповіщення?'**
  String get settingsDisableNotificationsTitle;

  /// No description provided for @settingsDisableNotificationsMessage.
  ///
  /// In uk, this message translates to:
  /// **'Ви не будете отримувати сповіщення про актуальні відключення.'**
  String get settingsDisableNotificationsMessage;

  /// No description provided for @settingsDisableNotifications.
  ///
  /// In uk, this message translates to:
  /// **'Вимкнути'**
  String get settingsDisableNotifications;

  /// No description provided for @addressSearchTitle.
  ///
  /// In uk, this message translates to:
  /// **'Вибір адреси'**
  String get addressSearchTitle;

  /// No description provided for @addressSearchSaving.
  ///
  /// In uk, this message translates to:
  /// **'Збереження адреси...'**
  String get addressSearchSaving;

  /// No description provided for @addressSearchSaved.
  ///
  /// In uk, this message translates to:
  /// **'Адресу збережено'**
  String get addressSearchSaved;

  /// No description provided for @addressSearchSaveButton.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти адресу'**
  String get addressSearchSaveButton;

  /// No description provided for @addressFieldCity.
  ///
  /// In uk, this message translates to:
  /// **'Населений пункт'**
  String get addressFieldCity;

  /// No description provided for @addressFieldCityHint.
  ///
  /// In uk, this message translates to:
  /// **'Почніть вводити назву міста...'**
  String get addressFieldCityHint;

  /// No description provided for @addressFieldStreet.
  ///
  /// In uk, this message translates to:
  /// **'Вулиця'**
  String get addressFieldStreet;

  /// No description provided for @addressFieldStreetHint.
  ///
  /// In uk, this message translates to:
  /// **'Почніть вводити назву вулиці...'**
  String get addressFieldStreetHint;

  /// No description provided for @addressFieldStreetDisabled.
  ///
  /// In uk, this message translates to:
  /// **'Спочатку виберіть місто'**
  String get addressFieldStreetDisabled;

  /// No description provided for @addressFieldHouse.
  ///
  /// In uk, this message translates to:
  /// **'Будинок'**
  String get addressFieldHouse;

  /// No description provided for @addressFieldHouseHint.
  ///
  /// In uk, this message translates to:
  /// **'Почніть вводити номер будинку...'**
  String get addressFieldHouseHint;

  /// No description provided for @addressFieldHouseDisabled.
  ///
  /// In uk, this message translates to:
  /// **'Спочатку виберіть вулицю'**
  String get addressFieldHouseDisabled;

  /// No description provided for @addressNameTitle.
  ///
  /// In uk, this message translates to:
  /// **'Назва адреси'**
  String get addressNameTitle;

  /// No description provided for @addressNameHint.
  ///
  /// In uk, this message translates to:
  /// **'Наприклад: Дім, Робота, Батьки...'**
  String get addressNameHint;

  /// No description provided for @addressNameDefault.
  ///
  /// In uk, this message translates to:
  /// **'Дім'**
  String get addressNameDefault;

  /// No description provided for @addressNameSuggestions.
  ///
  /// In uk, this message translates to:
  /// **'Підказки:'**
  String get addressNameSuggestions;

  /// No description provided for @addressNameRequired.
  ///
  /// In uk, this message translates to:
  /// **'Будь ласка, введіть назву адреси'**
  String get addressNameRequired;

  /// No description provided for @addressSuggestionHome.
  ///
  /// In uk, this message translates to:
  /// **'🏠 Дім'**
  String get addressSuggestionHome;

  /// No description provided for @addressSuggestionWork.
  ///
  /// In uk, this message translates to:
  /// **'💼 Робота'**
  String get addressSuggestionWork;

  /// No description provided for @addressSuggestionParents.
  ///
  /// In uk, this message translates to:
  /// **'👨‍👩‍👧 Батьки'**
  String get addressSuggestionParents;

  /// No description provided for @addressSuggestionSchool.
  ///
  /// In uk, this message translates to:
  /// **'🏫 Школа'**
  String get addressSuggestionSchool;

  /// No description provided for @addressSuggestionGrandma.
  ///
  /// In uk, this message translates to:
  /// **'👵 Бабуся'**
  String get addressSuggestionGrandma;

  /// No description provided for @addressSuggestionOffice.
  ///
  /// In uk, this message translates to:
  /// **'🏢 Офіс'**
  String get addressSuggestionOffice;

  /// Інструкція для вибору адреси
  ///
  /// In uk, this message translates to:
  /// **'Виберіть послідовно: {city} → {street} → {house}'**
  String addressSearchInstruction(String city, String street, String house);

  /// Неочікувана помилка
  ///
  /// In uk, this message translates to:
  /// **'Неочікувана помилка: {error}'**
  String errorUnexpected(String error);

  /// No description provided for @errorSearchCities.
  ///
  /// In uk, this message translates to:
  /// **'Помилка пошуку міст: {error}'**
  String errorSearchCities(String error);

  /// No description provided for @errorSelectCity.
  ///
  /// In uk, this message translates to:
  /// **'Помилка вибору міста: {error}'**
  String errorSelectCity(String error);

  /// No description provided for @errorSearchStreets.
  ///
  /// In uk, this message translates to:
  /// **'Помилка пошуку вулиць: {error}'**
  String errorSearchStreets(String error);

  /// No description provided for @errorLoadingHouses.
  ///
  /// In uk, this message translates to:
  /// **'Помилка завантаження будинків: {error}'**
  String errorLoadingHouses(String error);

  /// No description provided for @errorSearchHouses.
  ///
  /// In uk, this message translates to:
  /// **'Помилка пошуку будинків: {error}'**
  String errorSearchHouses(String error);

  /// No description provided for @onboardingAppTitle.
  ///
  /// In uk, this message translates to:
  /// **'ProСвітло'**
  String get onboardingAppTitle;

  /// No description provided for @onboardingAppSubtitle.
  ///
  /// In uk, this message translates to:
  /// **'Слідкуйте за станом електропостачання\nу Хмельницькій області'**
  String get onboardingAppSubtitle;

  /// No description provided for @addressValidationCity.
  ///
  /// In uk, this message translates to:
  /// **'Будь ласка, виберіть місто'**
  String get addressValidationCity;

  /// No description provided for @addressValidationStreet.
  ///
  /// In uk, this message translates to:
  /// **'Будь ласка, виберіть вулицю'**
  String get addressValidationStreet;

  /// No description provided for @addressValidationHouse.
  ///
  /// In uk, this message translates to:
  /// **'Будь ласка, виберіть будинок'**
  String get addressValidationHouse;

  /// No description provided for @aboutTitle.
  ///
  /// In uk, this message translates to:
  /// **'Інформація'**
  String get aboutTitle;

  /// No description provided for @aboutFeedback.
  ///
  /// In uk, this message translates to:
  /// **'Зворотній зв\'язок'**
  String get aboutFeedback;

  /// No description provided for @aboutAppInfo.
  ///
  /// In uk, this message translates to:
  /// **'Про додаток'**
  String get aboutAppInfo;

  /// No description provided for @aboutDeveloperContact.
  ///
  /// In uk, this message translates to:
  /// **'Зв\'язок з розробником'**
  String get aboutDeveloperContact;

  /// No description provided for @aboutDevMessage.
  ///
  /// In uk, this message translates to:
  /// **'Додаток знаходиться на етапі розробки та тестування. Якщо ви знайшли помилку чи маєте пропозицію — пишіть мені в Telegram.'**
  String get aboutDevMessage;

  /// No description provided for @aboutVersion.
  ///
  /// In uk, this message translates to:
  /// **'Версія'**
  String get aboutVersion;

  /// No description provided for @aboutDeveloper.
  ///
  /// In uk, this message translates to:
  /// **'Розробник'**
  String get aboutDeveloper;

  /// No description provided for @aboutDataSource.
  ///
  /// In uk, this message translates to:
  /// **'Джерело даних'**
  String get aboutDataSource;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In uk, this message translates to:
  /// **'Політика конфіденційності'**
  String get aboutPrivacyPolicy;

  /// No description provided for @disclaimerTitle.
  ///
  /// In uk, this message translates to:
  /// **'Важлива інформація'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerMessage.
  ///
  /// In uk, this message translates to:
  /// **'Це неофіційний додаток. Вся інформація про відключення електроенергії береться з офіційного сайту ДТЕК Хмельницькі електромережі (hoe.com.ua). Додаток створений для зручного доступу до графіків відключень.'**
  String get disclaimerMessage;

  /// No description provided for @scheduleTitle.
  ///
  /// In uk, this message translates to:
  /// **'Графіки відключень'**
  String get scheduleTitle;

  /// No description provided for @scheduleNotFound.
  ///
  /// In uk, this message translates to:
  /// **'Графіки не знайдено'**
  String get scheduleNotFound;

  /// No description provided for @scheduleNotFoundMessage.
  ///
  /// In uk, this message translates to:
  /// **'Спробуйте оновити пізніше'**
  String get scheduleNotFoundMessage;

  /// No description provided for @scheduleUpdateTime.
  ///
  /// In uk, this message translates to:
  /// **'щойно'**
  String get scheduleUpdateTime;

  /// No description provided for @notificationsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Поки що немає сповіщень'**
  String get notificationsEmpty;

  /// No description provided for @onboardingFeature1Title.
  ///
  /// In uk, this message translates to:
  /// **'Кілька адрес'**
  String get onboardingFeature1Title;

  /// No description provided for @onboardingFeature1Description.
  ///
  /// In uk, this message translates to:
  /// **'Відстежуйте стан за усіма вашими адресами'**
  String get onboardingFeature1Description;

  /// No description provided for @onboardingFeature2Title.
  ///
  /// In uk, this message translates to:
  /// **'Графіки'**
  String get onboardingFeature2Title;

  /// No description provided for @onboardingFeature2Description.
  ///
  /// In uk, this message translates to:
  /// **'Для планових, аварійних та погодинних відключень'**
  String get onboardingFeature2Description;

  /// No description provided for @onboardingFeature3Title.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення'**
  String get onboardingFeature3Title;

  /// No description provided for @onboardingFeature3Description.
  ///
  /// In uk, this message translates to:
  /// **'Отримуйте push-повідомлення про всі відключення'**
  String get onboardingFeature3Description;

  /// No description provided for @onboardingStart.
  ///
  /// In uk, this message translates to:
  /// **'Почати'**
  String get onboardingStart;

  /// No description provided for @errorSavingAddress.
  ///
  /// In uk, this message translates to:
  /// **'Помилка збереження адреси: {error}'**
  String errorSavingAddress(String error);

  /// No description provided for @errorSavingOnboarding.
  ///
  /// In uk, this message translates to:
  /// **'Помилка збереження: {error}'**
  String errorSavingOnboarding(String error);

  /// No description provided for @errorLoadingNotifications.
  ///
  /// In uk, this message translates to:
  /// **'Помилка завантаження повідомлень: {error}'**
  String errorLoadingNotifications(String error);

  /// No description provided for @errorLoadingAddresses.
  ///
  /// In uk, this message translates to:
  /// **'Помилка завантаження адрес: {error}'**
  String errorLoadingAddresses(String error);

  /// No description provided for @errorAddingAddress.
  ///
  /// In uk, this message translates to:
  /// **'Помилка додавання адреси: {error}'**
  String errorAddingAddress(String error);

  /// No description provided for @errorDeletingAddress.
  ///
  /// In uk, this message translates to:
  /// **'Помилка видалення адреси: {error}'**
  String errorDeletingAddress(String error);

  /// No description provided for @errorTogglingNotifications.
  ///
  /// In uk, this message translates to:
  /// **'Помилка перемикання сповіщень: {error}'**
  String errorTogglingNotifications(String error);

  /// No description provided for @errorUpdatingToken.
  ///
  /// In uk, this message translates to:
  /// **'Помилка оновлення токену: {error}'**
  String errorUpdatingToken(String error);

  /// No description provided for @errorClearingCache.
  ///
  /// In uk, this message translates to:
  /// **'Помилка очищення кешу: {error}'**
  String errorClearingCache(String error);

  /// No description provided for @errorLoadingHomeData.
  ///
  /// In uk, this message translates to:
  /// **'Помилка завантаження даних: {error}'**
  String errorLoadingHomeData(String error);

  /// No description provided for @errorGeneric.
  ///
  /// In uk, this message translates to:
  /// **'Помилка: {error}'**
  String errorGeneric(String error);

  /// No description provided for @scheduleUpdated.
  ///
  /// In uk, this message translates to:
  /// **'Оновлено: {time}'**
  String scheduleUpdated(String time);

  /// No description provided for @addressQueue.
  ///
  /// In uk, this message translates to:
  /// **'Черга: {queue}'**
  String addressQueue(String queue);

  /// No description provided for @outageTypePlannedOutage.
  ///
  /// In uk, this message translates to:
  /// **'Тип: Планове відключення'**
  String get outageTypePlannedOutage;

  /// No description provided for @outageTypeActiveSupply.
  ///
  /// In uk, this message translates to:
  /// **'Тип: Електропостачання активне'**
  String get outageTypeActiveSupply;

  /// No description provided for @lastUpdated.
  ///
  /// In uk, this message translates to:
  /// **'Оновлено: {time}'**
  String lastUpdated(String time);

  /// No description provided for @telegramChannelDescription.
  ///
  /// In uk, this message translates to:
  /// **'Підпишіться на наш Telegram канал для отримання актуальної інформації про відключення електроенергії в Хмельницькій області.'**
  String get telegramChannelDescription;

  /// No description provided for @notificationsStoragePeriod.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення зберігаються 5 днів'**
  String get notificationsStoragePeriod;

  /// No description provided for @homeDebugActiveEmergency.
  ///
  /// In uk, this message translates to:
  /// **'аварійних активних'**
  String get homeDebugActiveEmergency;

  /// No description provided for @homeDebugUpcomingEmergency.
  ///
  /// In uk, this message translates to:
  /// **'аварійних майбутніх'**
  String get homeDebugUpcomingEmergency;

  /// No description provided for @homeDebugActivePlanned.
  ///
  /// In uk, this message translates to:
  /// **'планових активних'**
  String get homeDebugActivePlanned;

  /// No description provided for @homeDebugUpcomingPlanned.
  ///
  /// In uk, this message translates to:
  /// **'планових майбутніх'**
  String get homeDebugUpcomingPlanned;

  /// No description provided for @scheduleUpdatedMinutesAgo.
  ///
  /// In uk, this message translates to:
  /// **'{minutes} хв тому'**
  String scheduleUpdatedMinutesAgo(int minutes);

  /// No description provided for @scheduleUpdatedHoursAgo.
  ///
  /// In uk, this message translates to:
  /// **'{hours} год тому'**
  String scheduleUpdatedHoursAgo(int hours);

  /// No description provided for @scheduleUpdatedDaysAgo.
  ///
  /// In uk, this message translates to:
  /// **'{days} дн тому'**
  String scheduleUpdatedDaysAgo(int days);

  /// No description provided for @pushNotificationsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Push Сповіщення'**
  String get pushNotificationsTitle;

  /// No description provided for @telegramChannelTitle.
  ///
  /// In uk, this message translates to:
  /// **'Telegram канал'**
  String get telegramChannelTitle;

  /// No description provided for @notificationChannelName.
  ///
  /// In uk, this message translates to:
  /// **'ProСвітло Повідомлення'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In uk, this message translates to:
  /// **'Повідомлення про відключення електроенергії'**
  String get notificationChannelDescription;

  /// No description provided for @serviceErrorCheckSchedule.
  ///
  /// In uk, this message translates to:
  /// **'Перегляньте графік відключень'**
  String get serviceErrorCheckSchedule;

  /// No description provided for @serviceErrorGettingData.
  ///
  /// In uk, this message translates to:
  /// **'Помилка отримання даних'**
  String get serviceErrorGettingData;

  /// No description provided for @serviceErrorInvalidAddress.
  ///
  /// In uk, this message translates to:
  /// **'Некоректний формат адреси'**
  String get serviceErrorInvalidAddress;

  /// No description provided for @serviceErrorGettingStatus.
  ///
  /// In uk, this message translates to:
  /// **'Помилка отримання статусу: {error}'**
  String serviceErrorGettingStatus(String error);

  /// No description provided for @serviceErrorGettingOutages.
  ///
  /// In uk, this message translates to:
  /// **'Помилка отримання відключень: {error}'**
  String serviceErrorGettingOutages(String error);

  /// No description provided for @serviceErrorTimeout.
  ///
  /// In uk, this message translates to:
  /// **'Час очікування вичерпано. Перевірте підключення до інтернету.'**
  String get serviceErrorTimeout;

  /// No description provided for @serviceErrorConnection.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося підключитися до сервера.'**
  String get serviceErrorConnection;

  /// No description provided for @serviceErrorScheduleNotFound.
  ///
  /// In uk, this message translates to:
  /// **'Графіки не знайдено'**
  String get serviceErrorScheduleNotFound;

  /// No description provided for @serviceErrorLoadingSchedule.
  ///
  /// In uk, this message translates to:
  /// **'Помилка завантаження графіків'**
  String get serviceErrorLoadingSchedule;

  /// No description provided for @serviceErrorInvalidResponse.
  ///
  /// In uk, this message translates to:
  /// **'Невірний формат відповіді від сервера'**
  String get serviceErrorInvalidResponse;

  /// No description provided for @serviceErrorNetwork.
  ///
  /// In uk, this message translates to:
  /// **'Помилка мережі'**
  String get serviceErrorNetwork;

  /// No description provided for @serviceErrorUnknown.
  ///
  /// In uk, this message translates to:
  /// **'Невідома помилка: {error}'**
  String serviceErrorUnknown(String error);

  /// No description provided for @serviceErrorLoadingLatestSchedule.
  ///
  /// In uk, this message translates to:
  /// **'Помилка завантаження графіка'**
  String get serviceErrorLoadingLatestSchedule;

  /// No description provided for @tooltipInfo.
  ///
  /// In uk, this message translates to:
  /// **'Інформація'**
  String get tooltipInfo;
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
      <String>['uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
