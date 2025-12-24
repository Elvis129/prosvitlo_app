// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'ProСвітло';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get delete => 'Видалити';

  @override
  String get edit => 'Редагувати';

  @override
  String get close => 'Закрити';

  @override
  String get retry => 'Спробувати ще раз';

  @override
  String get later => 'Пізніше';

  @override
  String get error => 'Помилка';

  @override
  String get loading => 'Завантаження...';

  @override
  String get noData => 'Немає даних';

  @override
  String get copy => 'Копіювати';

  @override
  String get support => 'Підтримати';

  @override
  String get errorLoadingData => 'Не вдалося завантажити дані';

  @override
  String get errorOpeningLink => 'Не вдалося відкрити посилання';

  @override
  String get errorLoadingImage => 'Помилка завантаження зображення';

  @override
  String get errorLoadingAddress => 'Не вдалося отримати інформацію про адресу';

  @override
  String get errorAddressAlreadyAdded => 'Ця адреса вже додана';

  @override
  String get homeTitle => 'Головна';

  @override
  String get homeNoAddressesTitle => 'Адрес ще немає';

  @override
  String get homeNoAddressesDescription =>
      'Додайте адреси для відстеження статусу електропостачання';

  @override
  String get homeAddAddress => 'Додати адресу';

  @override
  String get homeAddOneMoreAddress => 'Додати ще одну адресу';

  @override
  String get homePowerOn => 'Є світло';

  @override
  String get homePowerOff => 'Відключення';

  @override
  String get homeActive => 'АКТИВНЕ';

  @override
  String get donationBannerTitle => 'Зарядити розробника';

  @override
  String get donationBannerSubtitle => 'Підтримати розробку додатка ☕';

  @override
  String get donationDialogTitle => 'Підтримай проєкт';

  @override
  String get donationDialogMessage =>
      'Додаток безкоштовний і підтримується зусиллями розробника. Твоя підтримка допоможе розвивати функціонал і підтримувати сервіс.';

  @override
  String get donationCardNumberTitle => 'Номер картки';

  @override
  String get donationCardNumberLabel => 'Підтримка розробника:';

  @override
  String get outageTypeEmergency => 'АВАРІЙНЕ';

  @override
  String get outageTypePlanned => 'ПЛАНОВЕ';

  @override
  String get outageTypeScheduled => 'ГРАФІК';

  @override
  String get outageEmergencyTitle => 'Аварійні відключення:';

  @override
  String get outagePlannedTitle => 'Планові відключення:';

  @override
  String outageStatusType(String type) {
    return 'Тип: $type';
  }

  @override
  String get outageStatusPlanned => 'Тип: Планове відключення';

  @override
  String get outageStatusActive => 'Тип: Електропостачання активне';

  @override
  String get outageTodayTitle => 'Відключення сьогодні:';

  @override
  String get outageTomorrowTitle => 'Відключення на завтра:';

  @override
  String get outageNoMoreToday =>
      'Більше відключень на сьогодні не заплановано';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsMyAddresses => 'Мої адреси';

  @override
  String get settingsAddAddress => 'Додати';

  @override
  String get settingsAppearance => 'Вигляд';

  @override
  String get settingsThemeLight => 'Світла тема';

  @override
  String get settingsThemeDark => 'Темна тема';

  @override
  String get settingsThemeSystem => 'Системна';

  @override
  String get settingsNotifications => 'Сповіщення';

  @override
  String get settingsNotificationsEnable => 'Увімкнути сповіщення';

  @override
  String get settingsNotificationsDescription =>
      'Отримувати повідомлення про відключення';

  @override
  String get settingsDeleteAddressTitle => 'Видалити адресу?';

  @override
  String settingsDeleteAddressMessage(String addressName) {
    return 'Ви впевнені що хочете видалити \"$addressName\"?';
  }

  @override
  String get settingsDisableNotificationsTitle => 'Вимкнути сповіщення?';

  @override
  String get settingsDisableNotificationsMessage =>
      'Ви не будете отримувати сповіщення про актуальні відключення.';

  @override
  String get settingsDisableNotifications => 'Вимкнути';

  @override
  String get addressSearchTitle => 'Вибір адреси';

  @override
  String get addressSearchSaving => 'Збереження адреси...';

  @override
  String get addressSearchSaved => 'Адресу збережено';

  @override
  String get addressSearchSaveButton => 'Зберегти адресу';

  @override
  String get addressFieldCity => 'Населений пункт';

  @override
  String get addressFieldCityHint => 'Почніть вводити назву міста...';

  @override
  String get addressFieldStreet => 'Вулиця';

  @override
  String get addressFieldStreetHint => 'Почніть вводити назву вулиці...';

  @override
  String get addressFieldStreetDisabled => 'Спочатку виберіть місто';

  @override
  String get addressFieldHouse => 'Будинок';

  @override
  String get addressFieldHouseHint => 'Почніть вводити номер будинку...';

  @override
  String get addressFieldHouseDisabled => 'Спочатку виберіть вулицю';

  @override
  String get addressNameTitle => 'Назва адреси';

  @override
  String get addressNameHint => 'Наприклад: Дім, Робота, Батьки...';

  @override
  String get addressNameDefault => 'Дім';

  @override
  String get addressNameSuggestions => 'Підказки:';

  @override
  String get addressNameRequired => 'Будь ласка, введіть назву адреси';

  @override
  String get addressSuggestionHome => '🏠 Дім';

  @override
  String get addressSuggestionWork => '💼 Робота';

  @override
  String get addressSuggestionParents => '👨‍👩‍👧 Батьки';

  @override
  String get addressSuggestionSchool => '🏫 Школа';

  @override
  String get addressSuggestionGrandma => '👵 Бабуся';

  @override
  String get addressSuggestionOffice => '🏢 Офіс';

  @override
  String addressSearchInstruction(String city, String street, String house) {
    return 'Виберіть послідовно: $city → $street → $house';
  }

  @override
  String errorUnexpected(String error) {
    return 'Неочікувана помилка: $error';
  }

  @override
  String errorSearchCities(String error) {
    return 'Помилка пошуку міст: $error';
  }

  @override
  String errorSelectCity(String error) {
    return 'Помилка вибору міста: $error';
  }

  @override
  String errorSearchStreets(String error) {
    return 'Помилка пошуку вулиць: $error';
  }

  @override
  String errorLoadingHouses(String error) {
    return 'Помилка завантаження будинків: $error';
  }

  @override
  String errorSearchHouses(String error) {
    return 'Помилка пошуку будинків: $error';
  }

  @override
  String get onboardingAppTitle => 'ProСвітло';

  @override
  String get onboardingAppSubtitle =>
      'Слідкуйте за станом електропостачання\nу Хмельницькій області';

  @override
  String get addressValidationCity => 'Будь ласка, виберіть місто';

  @override
  String get addressValidationStreet => 'Будь ласка, виберіть вулицю';

  @override
  String get addressValidationHouse => 'Будь ласка, виберіть будинок';

  @override
  String get aboutTitle => 'Інформація';

  @override
  String get aboutFeedback => 'Зворотній зв\'язок';

  @override
  String get aboutAppInfo => 'Про додаток';

  @override
  String get aboutDeveloperContact => 'Зв\'язок з розробником';

  @override
  String get aboutDevMessage =>
      'Додаток знаходиться на етапі розробки та тестування. Якщо ви знайшли помилку чи маєте пропозицію — пишіть мені в Telegram.';

  @override
  String get aboutVersion => 'Версія';

  @override
  String get aboutDeveloper => 'Розробник';

  @override
  String get aboutDataSource => 'Джерело даних';

  @override
  String get aboutPrivacyPolicy => 'Політика конфіденційності';

  @override
  String get disclaimerTitle => 'Важлива інформація';

  @override
  String get disclaimerMessage =>
      'Це неофіційний додаток. Вся інформація про відключення електроенергії береться з офіційного сайту ДТЕК Хмельницькі електромережі (hoe.com.ua). Додаток створений для зручного доступу до графіків відключень.';

  @override
  String get scheduleTitle => 'Графіки відключень';

  @override
  String get scheduleNotFound => 'Графіки не знайдено';

  @override
  String get scheduleNotFoundMessage => 'Спробуйте оновити пізніше';

  @override
  String get scheduleUpdateTime => 'щойно';

  @override
  String get notificationsTitle => 'Сповіщення';

  @override
  String get notificationsEmpty => 'Поки що немає сповіщень';

  @override
  String get onboardingFeature1Title => 'Кілька адрес';

  @override
  String get onboardingFeature1Description =>
      'Відстежуйте стан за усіма вашими адресами';

  @override
  String get onboardingFeature2Title => 'Графіки';

  @override
  String get onboardingFeature2Description =>
      'Для планових, аварійних та погодинних відключень';

  @override
  String get onboardingFeature3Title => 'Сповіщення';

  @override
  String get onboardingFeature3Description =>
      'Отримуйте push-повідомлення про всі відключення';

  @override
  String get onboardingStart => 'Почати';

  @override
  String errorSavingAddress(String error) {
    return 'Помилка збереження адреси: $error';
  }

  @override
  String errorSavingOnboarding(String error) {
    return 'Помилка збереження: $error';
  }

  @override
  String errorLoadingNotifications(String error) {
    return 'Помилка завантаження повідомлень: $error';
  }

  @override
  String errorLoadingAddresses(String error) {
    return 'Помилка завантаження адрес: $error';
  }

  @override
  String errorAddingAddress(String error) {
    return 'Помилка додавання адреси: $error';
  }

  @override
  String errorDeletingAddress(String error) {
    return 'Помилка видалення адреси: $error';
  }

  @override
  String errorTogglingNotifications(String error) {
    return 'Помилка перемикання сповіщень: $error';
  }

  @override
  String errorUpdatingToken(String error) {
    return 'Помилка оновлення токену: $error';
  }

  @override
  String errorClearingCache(String error) {
    return 'Помилка очищення кешу: $error';
  }

  @override
  String errorLoadingHomeData(String error) {
    return 'Помилка завантаження даних: $error';
  }

  @override
  String errorGeneric(String error) {
    return 'Помилка: $error';
  }

  @override
  String scheduleUpdated(String time) {
    return 'Оновлено: $time';
  }

  @override
  String addressQueue(String queue) {
    return 'Черга: $queue';
  }

  @override
  String get outageTypePlannedOutage => 'Тип: Планове відключення';

  @override
  String get outageTypeActiveSupply => 'Тип: Електропостачання активне';

  @override
  String lastUpdated(String time) {
    return 'Оновлено: $time';
  }

  @override
  String get telegramChannelDescription =>
      'Підпишіться на наш Telegram канал для отримання актуальної інформації про відключення електроенергії в Хмельницькій області.';

  @override
  String get notificationsStoragePeriod => 'Сповіщення зберігаються 5 днів';

  @override
  String get homeDebugActiveEmergency => 'аварійних активних';

  @override
  String get homeDebugUpcomingEmergency => 'аварійних майбутніх';

  @override
  String get homeDebugActivePlanned => 'планових активних';

  @override
  String get homeDebugUpcomingPlanned => 'планових майбутніх';

  @override
  String scheduleUpdatedMinutesAgo(int minutes) {
    return '$minutes хв тому';
  }

  @override
  String scheduleUpdatedHoursAgo(int hours) {
    return '$hours год тому';
  }

  @override
  String scheduleUpdatedDaysAgo(int days) {
    return '$days дн тому';
  }

  @override
  String get pushNotificationsTitle => 'Push Сповіщення';

  @override
  String get telegramChannelTitle => 'Telegram канал';

  @override
  String get notificationChannelName => 'ProСвітло Повідомлення';

  @override
  String get notificationChannelDescription =>
      'Повідомлення про відключення електроенергії';

  @override
  String get serviceErrorCheckSchedule => 'Перегляньте графік відключень';

  @override
  String get serviceErrorGettingData => 'Помилка отримання даних';

  @override
  String get serviceErrorInvalidAddress => 'Некоректний формат адреси';

  @override
  String serviceErrorGettingStatus(String error) {
    return 'Помилка отримання статусу: $error';
  }

  @override
  String serviceErrorGettingOutages(String error) {
    return 'Помилка отримання відключень: $error';
  }

  @override
  String get serviceErrorTimeout =>
      'Час очікування вичерпано. Перевірте підключення до інтернету.';

  @override
  String get serviceErrorConnection => 'Не вдалося підключитися до сервера.';

  @override
  String get serviceErrorScheduleNotFound => 'Графіки не знайдено';

  @override
  String get serviceErrorLoadingSchedule => 'Помилка завантаження графіків';

  @override
  String get serviceErrorInvalidResponse =>
      'Невірний формат відповіді від сервера';

  @override
  String get serviceErrorNetwork => 'Помилка мережі';

  @override
  String serviceErrorUnknown(String error) {
    return 'Невідома помилка: $error';
  }

  @override
  String get serviceErrorLoadingLatestSchedule =>
      'Помилка завантаження графіка';

  @override
  String get tooltipInfo => 'Інформація';
}
