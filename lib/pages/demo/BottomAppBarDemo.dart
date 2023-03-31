//
//  BottomAppBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 5:47 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/floating_action_button_location_ext.dart';

class BottomAppBarDemo extends StatefulWidget {
  const BottomAppBarDemo({Key? key}) : super(key: key);

  @override
  State createState() => _BottomAppBarDemoState();
}

class _BottomAppBarDemoState extends State<BottomAppBarDemo> {
  bool _showFab = true;
  bool _showNotch = true;
  FloatingActionButtonLocation _fabLocation = FloatingActionButtonLocation.endDocked;

  final locations = FloatingActionButtonLocationExt.allCases;

  void _onShowFabChanged(bool value) {
    setState(() {
      _showFab = value;
    });
  }

  void _onFabLocationChanged(FloatingActionButtonLocation? value) {
    setState(() {
      _fabLocation = value ?? FloatingActionButtonLocation.endDocked;
      _showNotch = _fabLocation.toString().contains("Docked");
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return _buildPage1();//非圆形

    return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: const Text('Bottom App Bar Demo'),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 88),
          children: <Widget>[
            SwitchListTile(
              title: const Text(
                'Floating Action Button',
              ),
              value: _showFab,
              onChanged: _onShowFabChanged,
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Floating action button position:', style: TextStyle(fontSize: 18),),
            ),

            Column(
              children: locations.map((e) => RadioListTile<FloatingActionButtonLocation>(
                title: Text(e.toString().split(".").last),
                value: e,
                groupValue: _fabLocation,
                onChanged: _onFabLocationChanged,
              )).toList(),
            ),
          ],
        ),
        floatingActionButton: _showFab
            ? FloatingActionButton(
                onPressed: () {},
                tooltip: 'Create',
                child: const Icon(Icons.add),
              )
            : null,
        floatingActionButtonLocation: _fabLocation,
        bottomNavigationBar: _DemoBottomAppBar(
          fabLocation: _fabLocation,
          shape: _showNotch ? const CircularNotchedRectangle() : null,
        ),
      );
  }
  
  _buildPage1() {
    ShapeBorder? buttonShape = BeveledRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    );
    buttonShape = StadiumBorder(side: BorderSide(color: Colors.transparent));
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text('Bottom App Bar Demo'),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(),
            buttonShape
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home), onPressed: () {  },
            ),
            IconButton(
              icon: Icon(Icons.people), onPressed: () {  },
            )
          ],
        ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          shape: buttonShape,
          icon: Icon(Icons.add),
          label: const Text("label"),
        ),
      );
    }
}

class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  static final List<FloatingActionButtonLocation> centerLocations = [
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            if (fabLocation == FloatingActionButtonLocation.startDocked) const Spacer(),
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.photo),
              onPressed: () {},
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
