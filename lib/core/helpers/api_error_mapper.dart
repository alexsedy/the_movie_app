import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';

abstract class ApiErrorMapper {
  static String mapError(ApiClientException e) {
    switch (e.type) {
      case ApiClientExceptionType.network:
        return "No internet connection. Please check your network.";
      case ApiClientExceptionType.sessionExpired:
        return "Session expired. Please log in again.";
      case ApiClientExceptionType.auth:
        return "Authentication failed.";
      case ApiClientExceptionType.notFound:
        return "Requested resource not found.";
      case ApiClientExceptionType.other:
        return "Unknown error occurred. Please try again later.";
      case ApiClientExceptionType.incorrectRequest:
        return "Incorrect request. Please check your input.";
      case ApiClientExceptionType.loginNotApproved:
        return "Login not approved. Please contact support.";
    }
  }

  static String unknownError() {
    return "Unknown error occurred. Please try again later.";
  }
}