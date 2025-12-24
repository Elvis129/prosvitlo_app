/// Static strings for service layer
/// These are fallback strings used when l10n context is not available
/// They should match the Ukrainian translations in app_uk.arb
class ServiceStrings {
  ServiceStrings._();

  static const checkSchedule = 'Перегляньте графік відключень';
  static const errorGettingData = 'Помилка отримання даних';
  static const invalidAddress = 'Некоректний формат адреси';
  static const timeout =
      'Час очікування вичерпано. Перевірте підключення до інтернету.';
  static const connectionError = 'Не вдалося підключитися до сервера.';
  static const scheduleNotFound = 'Графіки не знайдено';
  static const errorLoadingSchedule = 'Помилка завантаження графіків';
  static const invalidResponse = 'Невірний формат відповіді від сервера';
  static const networkError = 'Помилка мережі';
  static const errorLoadingLatestSchedule = 'Помилка завантаження графіка';

  static String errorGettingStatus(Object error) =>
      'Помилка отримання статусу: $error';
  static String errorGettingOutages(Object error) =>
      'Помилка отримання відключень: $error';
  static String unknownError(Object error) => 'Невідома помилка: $error';

  // API Client errors
  static const unexpectedResponseFormat =
      'Неочікуваний формат відповіді сервера';
  static String unexpectedError(Object error) => 'Неочікувана помилка: $error';
  static const requestTimeout =
      'Час очікування відповіді сервера вичерпано. Перевірте інтернет-з\'єднання.';
  static const badRequest = 'Некоректний запит. Перевірте введені дані.';
  static const notFound = 'Дані не знайдено. Можливо, адреса не існує в базі.';
  static const serverError = 'Помилка сервера. Спробуйте пізніше.';
  static const serviceUnavailable =
      'Сервер тимчасово недоступний. Спробуйте пізніше.';
  static String serverErrorWithCode(dynamic code) =>
      'Помилка сервера: ${code ?? "невідомо"}';
  static const requestCancelled = 'Запит скасовано';
  static const noConnection =
      'Немає підключення до інтернету або сервер недоступний';
  static const connectionFailed = 'Не вдалося з\'єднатися з сервером';

  // Time formatting
  static const justNow = 'щойно';

  static const notificationChannelName = 'ПроСвітло Повідомлення';
  static const notificationChannelDescription =
      'Повідомлення про відключення електроенергії';
}
