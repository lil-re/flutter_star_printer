import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_star_printer/src/enums.dart';
import 'package:flutter_star_printer/src/portInfo.dart';
import 'package:flutter_star_printer/src/print_commands.dart';
import 'package:flutter_star_printer/src/utilities.dart';
import 'printer_response_status.dart';

/// Class to handle printer communication
class StarPrnt {
  static const MethodChannel _channel =
      const MethodChannel('flutter_star_printer');

  /// Scan for available printers. Have specify [StarPortType] of the printer
  static Future<List<PortInfo>> portDiscovery(StarPortType portType) async {
    dynamic result =
        await _channel.invokeMethod('portDiscovery', {'type': portType.text});
    if (result is List) {
      return result.map<PortInfo>((port) {
        return PortInfo(port);
      }).toList();
    } else {
      return [];
    }
  }

  /// Check status of printer. Have specify [portName] and [modelName]. Returns [PrinterResponseStatus]. Use [StarMicronicsUtilities] to find suitable emulations.
  static Future<PrinterResponseStatus> getStatus({
    required String portName,
    required String modelName,
  }) async {
    dynamic result = await _channel.invokeMethod('checkStatus', {
      'portName': portName,
      'emulation': emulationFor(modelName),
    });
    return PrinterResponseStatus.fromMap(
      Map<String, dynamic>.from(result),
    );
  }

  /// Sends [PrintCommands] to the printer. Have to specify [portName] and [modelName]. Returns [PrinterResponseStatus]
  static Future<PrinterResponseStatus> sendCommands({
    required String portName,
    required String modelName,
    required PrintCommands printCommands,
  }) async {
    dynamic result = await _channel.invokeMethod('print', {
      'portName': portName,
      'emulation': emulationFor(modelName),
      'printCommands': printCommands.getCommands(),
    });
    return PrinterResponseStatus.fromMap(
      Map<String, dynamic>.from(result),
    );
  }

  static String emulationFor(String modelName) {
    String emulation = 'StarGraphic';

    if (modelName.isNotEmpty) {
      StarMicronicsModel? model = StarMicronicsUtilities.detectEmulation(
        modelName: modelName,
      );

      if (model != null) {
        emulation = model.emulation!;
      }
    }
    return emulation;
  }
}
