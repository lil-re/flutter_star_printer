# flutter_star_printer

[![Pub Version](https://img.shields.io/pub/v/flutter_star_printer)](https://pub.dev/packages/flutter_star_printer)

Flutter plugin for [Star micronics printers](https://www.starmicronics.com/pages/All-Products).

The source code is forked from the [flutter_star_prnt](https://github.com/Eddayy/flutter_star_prnt) plugin.

Native code based on React Native and Ionic/Cordova version  
React native Version ➜ [here](https://github.com/infoxicator/react-native-star-prnt)  
Ionic/Cordova Version ➜ [here](https://github.com/auctifera-josed/starprnt)

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
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            color: Colors.black,
            size: 34,
          ),
        ),
        title: Text(
          'Printers',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        actions: [Container()],
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
                        ElevatedButton(
                          onPressed: testPort,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(40),
                            primary: Colors.blue,
                            elevation: 0,
                          ),
                          child: Text(
                            'TEST PRINTER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  child: ElevatedButton(
                    onPressed: onPressed: () {
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
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(40),
                      primary: Colors.blue,
                      elevation: 0,
                    ),
                    child: Text(
                      'SEARCH PRINTERS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
import 'package:flutter/material.dart';
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
