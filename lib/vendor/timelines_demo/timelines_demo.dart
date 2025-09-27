import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/timelines_demo/component_page.dart';
import 'package:flutter_templet_project/vendor/timelines_demo/logistics_time_line.dart';
import 'package:flutter_templet_project/vendor/timelines_demo/showcase/package_delivery_tracking.dart';
import 'package:flutter_templet_project/vendor/timelines_demo/showcase/process_timeline.dart';
import 'package:flutter_templet_project/vendor/timelines_demo/showcase/timeline_status.dart';
import 'package:flutter_templet_project/vendor/timelines_demo/showcase_page.dart';
import 'package:flutter_templet_project/vendor/timelines_demo/theme_page.dart';
import 'package:flutter_templet_project/vendor/timelines_demo/timelines_widgets.dart';
import 'package:timelines/timelines.dart';

class TimelinesDemo extends StatelessWidget {
  const TimelinesDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timelines Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      onGenerateRoute: (settings) {
        var path = Uri.tryParse(settings.name!)?.path;
        Widget child;
        switch (path) {
          case '/theme':
            child = ThemePage();
            break;
          case '/timeline_status':
            child = TimelineStatusPage();
            break;
          case '/package_delivery_tracking':
            child = PackageDeliveryTrackingPage();
            break;
          case '/process_timeline':
            child = ProcessTimelinePage();
            break;
          default:
            child = ExamplePage();
        }

        return MaterialPageRoute(builder: (context) => HomePage(child: child));
      },
      initialRoute: '/',
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState?.canPop() ?? false) {
          _navigatorKey.currentState?.maybePop();
          return false;
        } else {
          return true;
        }
      },
      child: Column(
        children: [
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => widget.child,
              ),
            ),
          ),
          if (kIsWeb) WebAlert()
        ],
      ),
    );
  }
}

class WebAlert extends StatelessWidget {
  const WebAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: Material(
        child: Center(
          child: Text(
            'You are using the web version now.\nSome UI can be broken.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTheme(
      data: TimelineThemeData(
        indicatorTheme: IndicatorThemeData(size: 15.0),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Timelines Example'),
        ),
        body: ListView(
          padding: EdgeInsets.all(10.0),
          children: [
            _NavigationCard(
              name: 'Components',
              navigationBuilder: () => ComponentPage(),
            ),
            _NavigationCard(
              name: 'Theme',
              navigationBuilder: () => ThemePage(),
            ),
            _NavigationCard(
              name: 'Showcase',
              navigationBuilder: () => ShowcasePage(),
            ),
            _NavigationCard(
              name: 'LogisticsTimeLine',
              navigationBuilder: () => LogisticsTimeLine(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({
    Key? key,
    required this.name,
    this.navigationBuilder,
  }) : super(key: key);

  final String name;
  final NavigateWidgetBuilder? navigationBuilder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NavigationCard(
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        borderRadius: BorderRadius.circular(8),
        navigationBuilder: navigationBuilder,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Text(name),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
