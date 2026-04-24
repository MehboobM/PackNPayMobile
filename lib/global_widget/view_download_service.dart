

import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api_services/service_constants.dart';
import '../database/shared_preferences/shared_storage.dart';
import '../utils/common_funtion.dart';
import '../utils/toast_message.dart';

class ViewDownloadService {

  static Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();

      if (status.isGranted) return true;

      /// For Android 11+
      final manageStatus = await Permission.manageExternalStorage.request();
      return manageStatus.isGranted;
    }

    /// iOS doesn't need permission
    return true;
  }


  static Future<void> handlePdf({
    required BuildContext context,
    required String type,
    required String uid,
    required bool isDownload,
    String? copyType, // ✅ ADD THIS
  }) async {
    const requestPath = '/pdf/generate';

    showLoader(context);

    try {
      final token = await StorageService().getToken();
      final dio = ServicesConstant.instanceDio(token);

      final body = {
        "type": type,
        "uid": uid,
        if (copyType != null) "copyType": copyType, // ✅ ONLY SEND IF EXISTS
      };

      print("📦 PAYLOAD: $body"); // debug

      final response = await dio.post(
        requestPath,
        data: body,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        Directory dir;

        if (Platform.isAndroid) {
          if (isDownload) {
            final hasPermission = await _requestStoragePermission();
            if (!hasPermission) return;

            dir = Directory('/storage/emulated/0/Download');
          } else {
            dir = await getTemporaryDirectory();
          }
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        final filePath =
            '${dir.path}/${type}_${DateTime.now().millisecondsSinceEpoch}.pdf';

        final file = File(filePath);
        await file.writeAsBytes(List<int>.from(response.data));

        if (isDownload) {
          ToastHelper.showSuccess(
            message: Platform.isAndroid
                ? "Downloaded to:\n$filePath"
                : "Saved to Files:\n$filePath",
          );
        } else {
          final result = await OpenFile.open(filePath);
          ToastHelper.showSuccess(
            message: result.type == ResultType.done
                ? 'PDF opened successfully'
                : 'Unable to open PDF',
          );
        }
      }
    } catch (e) {
      ToastHelper.showError(
        message: 'Unable to download file',
      );
      print("❌ PDF ERROR: $e");
    } finally {
      hideLoader(context);
    }
  }




  /*
  Future<bool> _requestStoragePermistatic Future<void> handlePdf({
  required BuildContext context,
  required String type,
  required String uid,
  required bool isDownload,
  String? copyType, // ✅ ADD THIS
}) async {
  const requestPath = '/pdf/generate';

  showLoader(context);

  try {
    final token = await StorageService().getToken();
    final dio = ServicesConstant.instanceDio(token);

    final body = {
      "type": type,
      "uid": uid,
      if (copyType != null) "copyType": copyType, // ✅ ONLY SEND IF EXISTS
    };

    print("📦 PAYLOAD: $body"); // debug

    final response = await dio.post(
      requestPath,
      data: body,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode == 200) {
      Directory dir;

      if (Platform.isAndroid) {
        if (isDownload) {
          final hasPermission = await _requestStoragePermission();
          if (!hasPermission) return;

          dir = Directory('/storage/emulated/0/Download');
        } else {
          dir = await getTemporaryDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final filePath =
          '${dir.path}/${type}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final file = File(filePath);
      await file.writeAsBytes(List<int>.from(response.data));

      if (isDownload) {
        ToastHelper.showSuccess(
          message: Platform.isAndroid
              ? "Downloaded to:\n$filePath"
              : "Saved to Files:\n$filePath",
        );
      } else {
        final result = await OpenFile.open(filePath);
        ToastHelper.showSuccess(
          message: result.type == ResultType.done
              ? 'PDF opened successfully'
              : 'Unable to open PDF',
        );
      }
    }
  } catch (e) {
    ToastHelper.showError(
      message: 'Unable to download file',
    );
    print("❌ PDF ERROR: $e");
  } finally {
    hideLoader(context);
  }
}ssion() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();

      if (status.isGranted) return true;

      /// For Android 11+
      final manageStatus = await Permission.manageExternalStorage.request();
      return manageStatus.isGranted;
    }

    /// ✅ iOS doesn't need permission
    return true;
  }

  Future<void> _openInvoice(String quotationUid) async {
    final requestPath = '/pdf/generate';
    showLoader(context); // ✅ START LOADER
    try {
      final token = await StorageService().getToken();
      final dio = ServicesConstant.instanceDio(token);

      final body = {
        "type": "quotation",
        "uid": quotationUid,
      };

      final response = await dio.post(
        requestPath,
        data: body,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();

        final filePath =
            '${tempDir.path}/quotation_${DateTime.now().millisecondsSinceEpoch}.pdf';

        final file = File(filePath);

        await file.writeAsBytes(List<int>.from(response.data));

        print('📁 FILE SAVED AT: $filePath');

        /// ✅ OPEN FILE (Android + iOS)
        final result = await OpenFile.open(filePath);

        /// ✅ iOS fallback (if no app to open PDF)
        // if (Platform.isIOS && result.type != ResultType.done) {
        //   await Share.shareXFiles([XFile(filePath)]);
        // }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.type == ResultType.done
                    ? 'PDF opened successfully'
                    : 'Opening via share...',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print("❌ OPEN ERROR: $e");
    }finally {
      hideLoader(context); // ✅ STOP LOADER (VERY IMPORTANT)
    }
  }

  Future<void> _downLoadInvoice(String quotationUid) async {
    final requestPath = '/pdf/generate';
    showLoader(context); // ✅ START LOADER
    try {
      final token = await StorageService().getToken();
      final dio = ServicesConstant.instanceDio(token);

      final body = {
        "type": "quotation",
        "uid": quotationUid,
      };

      final response = await dio.post(
        requestPath,
        data: body,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        Directory dir;

        /// ✅ ANDROID
        if (Platform.isAndroid) {
          final hasPermission = await _requestStoragePermission();
          if (!hasPermission) return;

          dir = Directory('/storage/emulated/0/Download');
        }

        /// ✅ IOS
        else {
          dir = await getApplicationDocumentsDirectory();
        }

        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        final filePath = '${dir.path}/quotation_${DateTime.now().millisecondsSinceEpoch}.pdf';

        final file = File(filePath);
        await file.writeAsBytes(List<int>.from(response.data));

        print("✅ FILE SAVED: $filePath");

        /// ❌ REMOVE AUTO OPEN
        /// await OpenFile.open(filePath);

        /// ✅ Show path in Snackbar
        if (mounted) {
          ToastHelper.showSuccess(message: Platform.isAndroid
              ? "Downloaded to:\n$filePath"
              : "Saved to Files:\n$filePath",);
        }
      }
    } catch (e) {
      print("❌ DOWNLOAD ERROR: $e");
    }finally {
      hideLoader(context); // ✅ STOP LOADER (VERY IMPORTANT)
    }
  }
  */
}