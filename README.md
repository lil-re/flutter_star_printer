# flutter_star_printer

[![Pub Version](https://img.shields.io/pub/v/flutter_star_printer)](https://pub.dev/packages/flutter_star_printer)

Flutter plugin for [Star micronics printers](https://www.starmicronics.com/pages/All-Products).

The source code is forked from the [flutter_star_prnt](https://github.com/Eddayy/flutter_star_prnt) plugin.

Native code based on React Native and Ionic/Cordova version  
React native Version ➜ [here](https://github.com/infoxicator/react-native-star-prnt)  
Ionic/Cordova Version ➜ [here](https://github.com/auctifera-josed/starprnt)

## Updating from 1.0.4 and lower

If you're having trouble please run these commands

```bash
rm -rf ios/Pods && rm ios/Podfile.lock && flutter clean
```

## Getting started

### Android

Permissions required depending on your printer:

```xml
<uses-permission android:name="android.permission.INTERNET"></uses-permission>
<uses-permission android:name="android.permission.BLUETOOTH"></uses-permission>
```

### Ios

Need to add this into your info.plist for bluetooth printers

```xml
<key>UISupportedExternalAccessoryProtocols</key>
  <array>
    <string>jp.star-m.starpro</string>
  </array>
```

### Example

```dart
// printers.dart
import 'package:erplain_pos/screens/settings/widgets/settings_available_printers.dart';
import 'package:erplain_pos/utilities/theme/theme.dart';
import 'package:erplain_pos/widgets/custom_button.dart';
import 'package:erplain_pos/widgets/custom_container.dart';
import 'package:erplain_pos/widgets/custom_text.dart';
import 'package:erplain_pos/widgets/nav/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_star_printer/flutter_star_printer.dart';

class Printers extends StatefulWidget {
  const Printers({Key? key}) : super(key: key);

  @override
  State<Printers> createState() => _PrintersState();
}

class _PrintersState extends State<Printers> {
  /// [ports] contains info of printer connections found by the app
  List<PortInfo> ports = [];

  /// [selectedPort] contains info of the selected printer connection
  PortInfo? selectedPort;

  bool loading = false;

  @override
  void initState() {
    searchPorts();
    super.initState();
  }

  void setLoading() {
    setState(() {
      loading = !loading;
    });
  }

  void setSelectedPort(PortInfo port) {
    setState(() {
      selectedPort = port;
    });
  }

  void searchPorts() async {
    setLoading();

    List<PortInfo> list = await StarPrnt.portDiscovery(StarPortType.All);

    setState(() {
      ports = list;
    });

    setLoading();
  }

  void testSelectedPort() async {
    PrintCommands commands = PrintCommands();
    commands.push({'appendBitmapText': "Hello World !"});
    commands.push({'appendCutPaper': "FullCutWithFeed"});

    if (selectedPort != null && selectedPort!.portName != null) {
      await StarPrnt.sendCommands(
        portName: selectedPort!.portName!,
        modelName: selectedPort!.modelName!,
        printCommands: commands,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Printers',
        actions: [Container()],
        displayNavigation: true,
        onNavigationTap: () {
          Navigator.pop(context);
        },
      ),
      body: loading
          ? Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                if (selectedPort != null)
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Selected printer'),
                          subtitle: Text(selectedPort!.portName!),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade300,
                        ),
                        CustomButton(
                          text: Text('Test printer'),
                          onPressed: testSelectedPort,
                        ),
                      ],
                    ),
                  ),
                Container(
                  child: CustomButton(
                    text: Text('Search printers'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SettingsAvailablePrinters(
                            ports: ports,
                            onSelected: setSelectedPort,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

```

```dart
// search_printers.dart
import 'package:erplain_pos/widgets/nav/custom_app_bar_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_star_printer/flutter_star_printer.dart';

class SearchPrinters extends StatelessWidget {
  final List<PortInfo> ports;
  final Function(PortInfo) onSelected;

  const SearchPrinters({
    Key? key,
    required this.ports,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            height: 340,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Search printers'
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: IconButton(
                        onPressed: onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                if (ports.isEmpty)
                  Text('No printer found'),
                if (ports.isNotEmpty)
                  Expanded(
                    child: ListView(
                      children: ports.map((PortInfo port) {
                        return ListTile(
                          title: Text(port.portName!),
                          onTap: () {
                            onSelected(port);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

```

## Work in progress

- [ ] Added documentations in README.md

Documentation work in progress, please refer to the [sample project](https://github.com/lil-re/flutter_star_printer/tree/master/example).
