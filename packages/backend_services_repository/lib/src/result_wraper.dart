class Result<T, E> {
  final T? value;
  final E? error;

  Result._({this.value, this.error});

  factory Result.success(T value) => Result._(value: value);
  factory Result.failure(E error) => Result._(error: error);

  bool get isSuccess => value != null;
  bool get isFailure => error != null;
}