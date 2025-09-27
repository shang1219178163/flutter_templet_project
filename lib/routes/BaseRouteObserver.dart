
//https://www.cnblogs.com/mengqd/p/13683126.html

// class BaseRouteObserver<R extends Route<dynamic>> extends RouteObserver<R> {
//   @override
//   void didPush(Route route, Route previousRoute) {
//     super.didPush(route, previousRoute);
//     print('didPush route: $route,previousRoute:$previousRoute');
//   }
//
//   @override
//   void didPop(Route route, Route previousRoute) {
//     super.didPop(route, previousRoute);
//     print('didPop route: $route,previousRoute:$previousRoute');
//   }
//
//   @override
//   void didReplace({Route newRoute, Route oldRoute}) {
//     super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
//     print('didReplace newRoute: $newRoute,oldRoute:$oldRoute');
//   }
//
//   @override
//   void didRemove(Route route, Route previousRoute) {
//     super.didRemove(route, previousRoute);
//     print('didRemove route: $route,previousRoute:$previousRoute');
//   }
//
//   @override
//   void didStartUserGesture(Route route, Route previousRoute) {
//     super.didStartUserGesture(route, previousRoute);
//     print('didStartUserGesture route: $route,previousRoute:$previousRoute');
//   }
//
//   @override
//   void didStopUserGesture() {
//     super.didStopUserGesture();
//     print('didStopUserGesture');
//   }
// }

// abstract class RouteAwareState<T extends StatefulWidget> extends State<T>
//     with RouteAware {
//
//   @override
//   void dispose() {
//     debugPrint("$widget dispose");
//     RouteService.routeObserver.unsubscribe(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeDependencies() {
//     debugPrint("$widget didChangeDependencies");
//     RouteService.routeObserver.subscribe(this, ModalRoute.of(context)!); //Subscribe it here
//     super.didChangeDependencies();
//   }
//
//   @override
//   void didPush() {
//     debugPrint('$widget didPush');
//   }
//
//   @override
//   void didPop() {
//     debugPrint('$widget didPop');
//   }
//
//   @override
//   void didPopNext() {
//     debugPrint('$widget didPopNext');
//   }
//
//   @override
//   void didPushNext() {
//     debugPrint('$widget didPushNext');
//   }
//
// }
