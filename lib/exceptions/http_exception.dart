class HttpException implements Exception{
  String msg;

  HttpException(String msg){
    this.msg = msg;
  }

  @override
  String toString() {
    return msg;
  }
}