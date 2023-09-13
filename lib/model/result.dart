enum Status {
  Loading, Success, Error
}

class Result<T> {
  Status status;
  T? data;
  int? errorCode;

  Result(this.status, {this.data, this.errorCode});
}