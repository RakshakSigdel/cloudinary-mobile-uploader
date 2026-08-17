sealed class AppException implements Exception{
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

//Configuration Exception
class ConfigurationException extends AppException {
  const ConfigurationException([super.message = 'Cloudinary is not configured yet']);
}

//Validation Exception
class ValidationException extends AppException{
  const ValidationException(super.message);
}
//Network Exception
class NetworkException extends AppException{

  const NetworkException([super.message = "Network Error. Please Check Your Connection"]);
}
//CloudinaryApiException
class CloudinaryApiException extends AppException{
  final int? statusCode;
  const CloudinaryApiException(super.message, {this.statusCode});
}
//InvalidPresetException
class InvalidPresetException extends AppException{
  const InvalidPresetException([super.message = "Invalid or missing upload preset"]);
}
//AuthErrorException
class AuthErrorException extends AppException{
  const AuthErrorException([super.message = "Authentication Error with Cloudinary"]);
}
//RateLimitException
class RateLimitException extends AppException{
  const RateLimitException([super.message = "Too many request. Try again shortly"]);
}
//Unknown Exception
class UnknownException extends AppException{
  const UnknownException([super.message = "Something went wrong"]);
}