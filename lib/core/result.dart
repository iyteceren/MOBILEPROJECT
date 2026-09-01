/// Basit `Result` tipi: bir işlem başarılı (`Success`) veya başarısız
/// (`Failure`) olabilir. Exception fırlatıp yakalamak yerine dönüş değeri
/// olarak taşınır; UI her iki durumu da açıkça ele almak zorunda kalır.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;

  /// Veri canlı API yerine yerel asset'ten geldiyse `true`.
  final bool fromCache;

  const Success(this.data, {this.fromCache = false});
}

class Failure<T> extends Result<T> {
  final String message;
  final Object? error;

  const Failure(this.message, {this.error});
}
