import 'package:flutter/material.dart';
import 'app_exception.dart';

class Failure{
  final String message;
  final IconData icon;

  const Failure({required this.message, required this.icon});

  factory Failure.fromException(AppException exception){
    return switch(exception){
      ConfigurationException() => Failure(message: exception.message, icon: Icons.settings_outlined), ValidationException() => Failure(message: exception.message, icon: Icons.warning_amber_outlined), NetworkException() => Failure(message: exception.message, icon: Icons.wifi_off_outlined), CloudinaryApiException() => Failure(message: exception.message,icon:Icons.error_outlined),
      InvalidPresetException() => Failure(message: exception.message, icon:Icons.lock_outlined),
      AuthErrorException() => Failure(message:exception.message, icon: Icons.hourglass_bottom_outlined),
      RateLimitException() => Failure(message:exception.message, icon: Icons.cloud_off_outlined),
      UnknownException() => Failure(message:exception.message, icon: Icons.error_outlined),
    };
  }
}