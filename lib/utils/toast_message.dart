


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {

  // =======================
  // ✅ SUCCESS TOAST (Flat + Green Border)
  // =======================
  static void showSuccess({
    required String message,
    String title = 'Success',
    int seconds = 3,
  }) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: Duration(seconds: seconds),

      alignment: Alignment.topRight,

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.green,
          fontSize: 16,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(color: Colors.black,fontWeight:FontWeight.w400,fontSize: 15),
      ),

      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
      showIcon: true,

      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      primaryColor: Colors.green,

      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.green, width: 1.3),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      showProgressBar: true,
      dragToClose: true,
      pauseOnHover: true,

      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.always,
        buttonBuilder: (context, onClose) {
          return IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onClose,
          );
        },
      ),
    );
  }

  // =======================
  // ❌ ERROR TOAST (Bold Red Background)
  // =======================
  static void showError({
    required String message,
    String title = 'Error',
    int seconds = 3,
  }) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: Duration(seconds: seconds),

      alignment: Alignment.topCenter,

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
            fontSize: 16,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(color: Colors.white,fontWeight:FontWeight.w400,fontSize: 15),
      ),

      icon: const Icon(Icons.error, color: Colors.white),
      showIcon: true,

      backgroundColor: Colors.red.shade600,
      foregroundColor: Colors.white,
      primaryColor: Colors.red,

      borderRadius: BorderRadius.circular(6),

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
    );
  }

  // =======================
  // ℹ️ INFO TOAST (Soft Blue + Blur)
  // =======================
  static void showInfo({
    required String message,
    String title = 'Info',
    int seconds = 3,
  }) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      autoCloseDuration: Duration(seconds: seconds),

      alignment: Alignment.bottomRight,

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.blue,
        ),
      ),
      description: Text(message),

      icon: const Icon(Icons.info_outline, color: Colors.blue),
      showIcon: true,

      backgroundColor: Colors.blue.shade50,
      foregroundColor: Colors.black,
      primaryColor: Colors.blue,

      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue.shade200, width: 1),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      applyBlurEffect: true,
      showProgressBar: true,
      pauseOnHover: true,
    );
  }
}
