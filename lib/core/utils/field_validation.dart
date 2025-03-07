import 'package:flutter/material.dart';

class FieldValidation {
  static FormFieldValidator<String>? validateEmail = (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address.';
    } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+\w{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  };

  static FormFieldValidator<String>? validatePassword = (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    } else if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})')
        .hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.';
    }
    return null;
  };

  static FormFieldValidator<String>? validateRequired = (value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }
    return null;
  };

  static FormFieldValidator<String>? validateYear = (value) {
    if (value == null || value.isEmpty) {
      return 'Year is required.';
    } else if (value.length != 4) {
      return 'Year must be 4 characters long';
    }
    return null;
  };

  static FormFieldValidator<String>? validateName = (value) {
    if (value == null || value.isEmpty) {
      return 'Name is required.';
    } else if (value.length > 50) {
      return 'Name must be at most 50 characters long.';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Please type your name without any numbers or special characters.';
    }
    return null;
  };

  static FormFieldValidator<String>? validatePhone = (value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    } else if (value.length != 13 && value.length != 10) {
      return 'Phone number digits long is not correct';
    } else if (!RegExp(r'^(\+966|0)5[0-9]{8}$').hasMatch(value)) {
      return 'Phone number must enter correctly';
    }
    return null;
  };
}
