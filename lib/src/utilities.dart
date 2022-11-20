// Credits to https://github.com/ImTung

/// Object representation of categories printers group by product line
class StarModel {
  /// Printer's product line
  String? name;

  /// Printer's emulation
  String? emulation;

  /// Printer's paper width
  int paperWidth;

  /// Model in the product line
  List<String> models;

  StarModel({
    this.name,
    this.emulation,
    this.paperWidth = 576,
    required this.models,
  });
}

/// Static list of [StarModel]
final List<StarModel> starModels = [
  StarModel(
    name: 'mC-Print2',
    emulation: 'StarPRNT',
    models: ['MCP20 (STR-001)', 'MCP21 (STR-001)', 'MCP21'],
  ),
  StarModel(
    name: 'mC-Print3',
    emulation: 'StarPRNT',
    models: ['MCP30 (STR-001)', 'MCP31 (STR-001)', 'MCP31'],
  ),
  StarModel(
    name: 'mPOP',
    emulation: 'StarPRNT',
    paperWidth: 386,
    models: ['POP10', 'POP10 BLK'],
  ),
  StarModel(
    name: 'FVP10',
    emulation: 'StarLine',
    models: ['FVP10 (STR_T-001)'],
  ),
  StarModel(
    name: 'TSP100',
    emulation: 'StarGraphic',
    models: ['TSP100', 'TSP113', 'TSP143', 'TSP143 (STR_T-001)'],
  ),
  StarModel(
    name: 'TSP650II',
    emulation: 'StarLine',
    models: [
      'TSP654II (STR_T-001)',
      'TSP654 (STR_T-001)',
      'TSP651 (STR_T-001)'
    ],
  ),
  StarModel(
    name: 'TSP700II',
    emulation: 'StarLine',
    models: ['TSP743II (STR_T-001)', 'TSP743 (STR_T-001)'],
  ),
  StarModel(
    name: 'TSP800II',
    emulation: 'StarLine',
    paperWidth: 832,
    models: ['TSP847II (STR_T-001)', 'TSP847 (STR_T-001)'],
  ),
  StarModel(
    name: 'SM-S210i',
    emulation: 'EscPosMobile',
    models: ['SM-S210i'],
  ),
  StarModel(
    name: 'SM-S220i',
    emulation: 'EscPosMobile',
    paperWidth: 386,
    models: ['SM-S220i'],
  ),
  StarModel(
    name: 'SM-S230',
    emulation: 'EscPosMobile',
    paperWidth: 386,
    models: ['SM-S230', 'SM-S230i'],
  ),
  StarModel(
    name: 'SM-T300i/T300',
    emulation: 'EscPosMobile',
    models: ['SM-T300i'],
  ),
  StarModel(
    name: 'SM-T400i',
    emulation: 'EscPosMobile',
    paperWidth: 832,
    models: ['SM-T400i'],
  ),
  StarModel(
    name: 'BSC10',
    emulation: 'EscPos',
    models: ['BSC10'],
  ),
  StarModel(
    name: 'SM-S210i StarPRNT',
    emulation: 'StarPRNT',
    models: ['SM-S210i StarPRNT'],
  ),
  StarModel(
    name: 'SM-S220i StarPRNT',
    emulation: 'StarPRNT',
    models: ['SM-S220i StarPRNT'],
  ),
  StarModel(
    name: 'SM-S230i StarPRNT',
    emulation: 'StarPRNT',
    models: ['SM-S230i StarPRNT'],
  ),
  StarModel(
    name: 'SM-T300i/T300 StarPRNT',
    emulation: 'StarPRNT',
    models: ['SM-T300i StarPRNT'],
  ),
  StarModel(
    name: 'SM-T400i StarPRNT',
    emulation: 'StarPRNT',
    models: ['SM-T400i StarPRNT'],
  ),
  StarModel(
    name: 'SM-L200',
    emulation: 'StarPRNT',
    paperWidth: 386,
    models: ['SM-L200'],
  ),
  StarModel(
    name: 'SP700',
    emulation: 'StarDotImpact',
    paperWidth: 386,
    models: [
      'SP712 (STR-001)',
      'SP717 (STR-001)',
      'SP742 (STR-001)',
      'SP747 (STR-001)'
    ],
  ),
  StarModel(
    name: 'SM-L300',
    emulation: 'StarPRNTL',
    models: ['SM-L300'],
  ),
];

/// Helper class to handle different type of printers
class StarUtils {
  /// Detects the [modelName] of the printer and return [StarModel], returns [null] if not found
  static StarModel? detectEmulation({String? modelName}) {
    if (modelName != null && modelName.isNotEmpty) {
      for (StarModel starModel in starModels) {
        for (String supportedModel in starModel.models) {
          if (supportedModel == modelName) {
            return starModel;
          }
        }
      }
    }
    return null;
  }

  static int? detectPaperWidth({String? modelName}) {
    StarModel? model = detectEmulation(modelName: modelName);
    return model != null ? model.paperWidth : null;
  }

  /// Checks if command is supported WIP
  static isCommandSupport(String command, String emulation) {}
}
