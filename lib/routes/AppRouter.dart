//
//  AppRouter.dart
//  flutter_templet_project
//
//  Route name constants + thin accessors. GetPages live in app_router_core / app_router_lazy.
//

import 'package:flutter_templet_project/routes/app_router_core.dart';
import 'package:flutter_templet_project/routes/app_router_lazy_loader.dart';
import 'package:get/get.dart';

class AppRouter {
  static const String unknown = '/unknownPage';
  static const String sandboxFileDirectory = '/sandboxFileDirectory';

  static const String appTabPage = '/AppTabPage';
  static const String yamlParsePage = '/yamlParsePage';

  static const String compileEnvironmentPage = '/compileEnvironmentPage';

  static const String appLifecycleObserverDemo = '/appLifecycleObserverDemo';
  static const String themeColorDemo = '/themeColorDemo';
  static const String themeColorSchemePage = '/themeColorSchemePage';

  static const String launchPage = '/APPLaunchPage';
  static const String emojiPage = '/emojiPage';
  static const String developToolList = '/developToolList';

  static const String mediaQueryScreeenDemo = '/mediaQueryScreeenDemo';
  static const String mediaQueryVsScreenManager = '/mediaQueryVsScreenManager';

  static const String autoLayoutDemo = '/AutoLayoutDemo';
  static const String afterLayoutDemo = '/AfterLayoutDemo';
  static const String appBarDemo = '/appBarDemo';
  static const String textDemo = '/textDemo';

  static const String login = '/login';
  static const String loginPageOne = '/loginPageOne';
  static const String loginPageTwo = '/loginPageTwo';

  static const String signinPage = '/SigninPage';

  static const String buttonPage = '/buttonPage';
  static const String listViewOffsetPage = '/listViewOffsetPage';
  static const String shadow3DTextPage = '/shadow3DTextPage';

  static const String pageBuilderDemo = '/pageBuilderDemo';

  static const String stringTransformPage = '/stringTransformPage';

  static const String enumDemo = '/enumDemo';
  static const String reflectDemo = '/moldelReflectDemo';
  static const String appRouteObserverDemo = '/appRouteObserverDemo';
  static const String appRouteObserverDemoOne = '/appRouteObserverDemoOne';
  static const String pageLifecycleObserverDemo = '/pageLifecycleObserverDemo';
  static const String pageLifecycleFuncTest = '/pageLifecycleFuncTest';
  static const String mediaQueryDemo = '/mediaQueryDemo';
  static const String mediaQueryDemoOne = '/mediaQueryDemoOne';
  static const String platformDispatcherDemo = '/PlatformDispatcherDemo';

  static const String tabBarDemo = '/TabBarDemo';
  static const String tabContainerDemo = '/tabContainerDemo';
  static const String widgetListPage = '/WidgetListPage';
  static const String animatedDemo = '/AnimatedDemo';
  static const String animatedWidgetDemo = '/AnimatedWidgetDemo';
  static const String animatedSwitcherDemo = '/AnimatedSwitcherDemo';
  static const String animatedListDemo = '/animatedListDemo';
  static const String animatedGroupDemo = '/animatedGroupDemo';
  static const String animatedBuilderDemo = '/animatedBuilderDemo';
  static const String animatedListSample = '/animatedListSample';
  static const String animatedSizeDemo = '/animatedSizeDemo';
  static const String animatedHaloPage = '/animatedHaloPage';

  static const String textlessDemo = '/textlessDemo';
  static const String alertDialogDemo = '/AlertDialogDemo';
  static const String alertDialogTagSelectDemo = '/alertDialogTagSelectDemo';

  static const String alertSheetDemo = '/AlertSheetDemo';
  static const String systemIconsPage = '/systemIconsPage';
  static const String systemColorPage = '/systemColorPage';
  static const String systemCurvesPage = '/systemCurvesPage';

  static const String gridViewDemo = '/GridViewDemo';
  static const String gridPaperDemo = '/GridPaperDemo';

  static const String pageViewDemo = '/PageViewDemo';
  static const String pageViewVerticalDemo = '/pageViewVerticalDemo';
  static const String pageViewDemoThree = '/pageViewDemoThree';

  static const String snackBarDemo = '/SnackBarDemo';
  static const String cupertinoTabScaffoldDemo = '/CupertinoTabScaffoldDemo';
  static const String pickerDemo = '/PickerDemo';
  static const String datePickerDemo = '/datePickerDemo';
  static const String datePickerPage = '/DatePickerPage';
  static const String showSearchDemo = '/ShowSearchDemo';
  static const String localNotifationDemo = '/LocalNotifationDemo';
  static const String progressHudDemoNew = '/ProgressHudDemoNew';
  static const String toastContext = '/ToastContext';
  static const String toastNoContext = '/ToastNoContext';
  static const String listDismissibleDemo = '/listDismissibleDemo';
  static const String slidableDemo = '/SlidaableDemo';
  static const String settingsPage = '/AppSettingsPage';
  static const String containerDemo = '/containerDemo';
  static const String containerComparePage = '/containerComparePage';
  static const String containerDemoNew = '/containerDemoNew';
  static const String animatedContainerDemo = '/animatedContainerDemo';
  static const String animatedContainerExample = '/animatedContainerExample';
  static const String draggableDemo = '/DraggableDemo';
  static const String forgetPasswordPage = '/ForgetPasswordPage';
  static const String dataTableDemo = '/DataTableDemo';
  static const String dataTableByPaginatedDemo = '/dataTableByPaginatedDemo';
  static const String segmentedControlDemo = '/segmentedControlDemo';
  static const String segmentedControlDemoOne = '/segmentedControlDemoOne';
  static const String segmentedButtonDemo = '/SegmentedButtonDemo';

  static const String sliderDemo = '/sliderDemo';
  static const String draggableScrollableSheetDemo = '/DraggableScrollableSheetDemo';
  static const String indicatorDemo = '/IndicatorDemo';
  static const String appWebViewDemo = '/AppWebViewDemo';
  static const String carouselViewDemo = '/carouselViewDemo';
  static const String carouselSliderDemo = '/carouselSliderDemo';
  static const String sliverAppBarDemo = '/SliverAppBarDemo';
  static const String sliverFamilyDemo = '/SliverFamilyDemo';
  static const String sliverStickyHeaderDemo = '/sliverStickyHeaderDemo';
  static const String sliverRefreshControlDemo = '/sliverRefreshControlDemo';
  static const String sliverFamilyPageViewDemo = '/sliverFamilyPageViewDemo';

  static const String reorderableListViewDemo = '/ReorderableListViewDemo';
  static const String expandIconDemoNew = '/ExpandIconDemoNew';
  static const String expandIconDemo = '/ExpandIconDemo';
  static const String stepperDemo = '/StepperDemo';
  static const String numberStepperDemo = '/NumberStepperDemo';
  static const String tableViewDemo = '/TableViewDemo';
  static const String githubRepoDemo = '/GithubRepoDemo';
  static const String progressHudDemo = '/ProgressHudDemo';
  static const String locationPopView = '/LocationPopView';
  static const String backdropFilterDemo = '/BackdropFilterDemo';
  static const String richTextDemo = '/RichTextDemo';
  static const String numberFormatDemo = '/NumberFormatDemo';
  static const String dateTimeDemo = '/DateTimeDemo';
  static const String textFieldDemo = '/TextFieldDemo';
  static const String textFieldDemoOne = '/TextFieldDemoOne';
  static const String textFieldDemoTwo = '/textFieldDemoTwo';
  static const String textFieldWidgetDemo = '/TextFieldWidgetDemo';
  static const String editableTextDemo = '/EditableTextDemo';
  static const String uint8ListDemo = '/Uint8ListDemo';
  static const String extendedImageDemo = '/ExtendedImageDemo';

  static const String cupertinoFormDemo = '/CupertinoFormDemo';
  static const String contextMenuActionDemo = '/ContextMenuActionDemo';
  static const String providerRoute = '/ProviderRoute';
  static const String providerListDemo = '/providerListDemo';
  static const String sliverPersistentHeaderDemo = '/SliverPersistentHeaderDemo';
  static const String layoutBuilderDemo = '/LayoutBuilderDemo';
  static const String tableDemo = '/TableDemo';
  static const String widgetDemoList = '/WidgetDemoList';

  static const String futureBuilderDemo = '/FutureBuilderDemo';
  static const String streamBuilderDemo = '/StreamBuilderDemo';
  static const String nestedScrollViewDemo = '/NestedScrollViewDemo';

  static const String tabBarViewDemo = '/tabBarViewDemo';

  static const String homePage = '/homePage';
  static const String tabBarPageViewDemo = '/tabBarPageViewDemo';
  static const String tabBarPageViewDemoNew = '/tabBarPageViewDemoNew';
  static const String tabBarReusePageDemo = '/tabBarReusePageDemo';
  static const String absorbPointerDemo = '/AbsorbPointerDemo';
  static const String willPopScopeDemo = '/WillPopScopeDemo';
  static const String bannerDemo = '/bannerDemo';
  static const String indexedStackDemo = '/IndexedStackDemo';

  static const String rxDartProviderDemo = '/RxDartProviderDemo';
  static const String stateManagerDemo = '/StateManagerDemo';

  static const String getxStateDemo = '/getxStateDemo';
  static const String getxStateDemoNew = '/getxStateDemoNew';

  static const String responsiveColumnDemo = '/responsiveColumnDemo';
  static const String testPage = '/testPage';
  static const String testPageOne = '/testPageOne';
  static const String offstageDemo = '/OffstageDemo';
  static const String bottomAppBarDemo = '/bottomAppBarDemo';
  static const String calendarDatePickerDemo = '/CalendarDatePickerDemo';
  static const String callbackShortcutsDemo = '/CallbackShortcutsDemo';
  static const String chipDemo = '/ChipDemo';
  static const String chipFilterDemo = '/chipFilterDemo';
  static const String bottomSheetDemo = '/bottomSheetDemo';
  static const String timePickerDemo = '/timePickerDemo';
  static const String shaderMaskDemo = '/ShaderMaskDemo';
  static const String blurViewDemo = '/blurViewDemo';
  static const String boxDemo = '/BoxDemo';
  static const String mouseRegionDemo = '/MouseRegionDemo';
  static const String timelineDemo = '/timelineDemo';
  static const String timelinesDemo = '/timelinesDemo';
  static const String hitTest = '/hitTest';
  static const String navgationBarDemo = '/transparentNavgationBarDemo';
  static const String borderDemo = '/borderDemo';
  static const String clipDemo = '/clipDemo';
  static const String steperConnectorDemo = '/steperConnectorDemo';
  static const String textViewDemo = '/textViewDemo';
  static const String navigationBarDemo = '/navigationBarDemo';
  static const String qrCodeScannerDemo = '/qrCodeScannerDemo';
  static const String qrFlutterDemo = '/qrFlutterDemo';
  static const String scribbleDemo = '/scribbleDemo';
  static const String aestheticDialogsDemo = '/aestheticDialogsDemo';
  static const String customTimerDemo = '/customTimerDemo';
  static const String countDownPage = '/countDownPage';
  static const String skeletonDemo = '/skeletonDemo';

  static const String flutterFFiTest = '/flutterFFiTest';
  static const String smartDialogPageDemo = '/smartDialogPageDemo';
  static const String mergeImagesDemo = '/mergeImagesDemo';
  static const String mergeNetworkImagesDemo = '/mergeNetworkImagesDemo';
  static const String drawImageNineDemo = '/drawImageNineDemo';
  static const String proxyProviderDemo = '/proxyProviderDemo';
  static const String ratingBarDemo = '/ratingBarDemo';
  static const String shortcutsDemo = '/shortcutsDemo';
  static const String shortcutsDemoOne = '/shortcutsDemoOne';
  static const String dragAndDropDemo = '/dragAndDropDemo';
  static const String transformDemo = '/transformDemo';
  static const String fittedBoxDemo = '/fittedBoxDemo';
  static const String positionedDirectionalDemo = '/positionedDirectionalDemo';
  static const String statefulBuilderDemo = '/statefulBuilderDemo';
  static const String valueListenableBuilderDemo = '/valueListenableBuilderDemo';
  static const String overflowBarDemo = '/overflowBarDemo';
  static const String navigationToolbarDemo = '/navigationToolbarDemo';
  static const String selectableTextDemo = '/SelectableTextDemo';
  static const String materialBannerDemo = '/materialBannerDemo';
  static const String routeNameSearchPage = '/routeNameSearchPage';

  static const String autofillGroupDemo = '/autofillGroupDemo';
  static const String promptBuilderDemo = '/promptBuilderDemo';
  static const String rotatedBoxDemo = '/rotatedBoxDemo';
  static const String dismissibleDemo = '/dismissibleDemo';
  static const String modalBarrierDemo = '/modalBarrierDemo';
  static const String isolateDemo = '/isolateDemo';
  static const String listViewDemo = '/listViewDemo';
  static const String listViewStyleDemo = '/listViewStyleDemo';
  static const String builderDemo = '/builderDemo';
  static const String overlayDemo = '/overlayDemo';
  static const String overlayDemoOne = '/overlayDemoOne';
  static const String overlayMixinDemo = '/overlayMixinDemo';

  static const String decorationDemo = '/decorationDemo';
  static const String stackDemo = '/stackDemo';
  static const String stackDemoOne = '/stackDemoOne';
  static const String stackDemoTwo = '/stackDemoTwo';

  static const String badgeDemo = '/badgeDemo';
  static const String badgesDemo = '/badgesDemo';
  static const String flutterSwiperDemo = '/flutterSwiperDemo';
  static const String flutterSwiperIndicatorDemo = '/flutterSwiperIndicatorDemo';
  static const String homeSrollDemo = '/homeSrollDemo';
  static const String homeNavDemo = '/homeNavDemo';
  static const String wrapDemo = '/wrapDemo';
  static const String nWrapPageViewDemo = '/nWrapPageViewDemo';
  static const String boxConstraintsDemo = '/boxConstraintsDemo';
  static const String gradientDemo = '/gradientDemo';
  static const String imageBlendModeDemo = '/imageBlendModeDemo';
  static const String customSwipperDemo = '/customSwipperDemo';
  static const String visibilityDetectorDemo = '/visibilityDetectorDemo';
  static const String svgaImageDemo = '/svgaImageDemo';
  static const String providerDemo = '/providerDemo';
  static const String providerDemoOne = '/providerDemoOne';
  static const String inheritedWidgetDemo = '/inheritedWidgetDemo';
  static const String notificationListenerDemo = '/notificationListenerDemo';
  static const String scrollbarDemo = '/scrollbarDemo';
  static const String notificationCustomDemo = '/notificationCustomDemo';
  static const String scrollPhysicsPage = '/scrollPhysicsPage';
  static const String trackingScrollDemo = '/trackingScrollDemo';
  static const String scrollControllerDemo = '/scrollControllerDemo';
  static const String scrollControllerDemoOne = '/scrollControllerDemoOne';
  static const String scrollControllerDemoTwo = '/scrollControllerDemoTwo';

  static const String colorConverterDemo = '/colorConverterDemo';
  static const String intrinsicHeightDemo = '/intrinsicHeightDemo';
  static const String flexDemo = '/flexDemo';
  static const String flexibleDemo = '/flexibleDemo';

  static const String physicalModelDemo = '/physicalModelDemo';
  static const String neumorphismDemo = '/neumorphismDemo';
  static const String wechatAssetsPickerDemo = '/wechatAssetsPickerDemo';
  static const String wechatPhotoPickerDemo = '/wechatPhotoPickerDemo';
  static const String visibilityDemo = '/visibilityDemo';
  static const String ignorePointerDemo = '/ignorePointerDemo';
  static const String horizontalCellDemo = '/horizontalCellDemo';
  static const String boxShadowDemo = '/boxShadowDemo';
  static const String listViewSeparatedDemo = '/listViewSeparatedDemo';
  static const String listViewOneDemo = '/listViewOneDemo';
  static const String marqueeWidgetDemo = '/marqueeWidgetDemo';
  static const String animatedStaggerDemo = '/animatedStaggerDemo';
  static const String buttonStyleDemo = '/buttonStyleDemo';
  static const String ticketDemo = '/ticketDemo';
  static const String myPopverDemo = '/myPopverDemo';
  static const String keyDemo = '/keyDemo';
  static const String customScrollBarDemo = '/customScrollBarDemo';
  static const String overflowDemo = '/overflowDemo';
  static const String segmentTabBarNewDemo = '/segmentTabBarNewDemo';
  static const String enhanceTabBarDemo = '/enhanceTabBarDemo';
  static const String collectionNavWidgetDemo = '/collectionNavWidgetDemo';
  static const String materialDemo = '/materialDemo';
  static const String flexibleSpaceDemo = '/flexibleSpaceDemo';
  static const String nnHorizontalScrollWidgetDemo = '/nnHorizontalScrollWidgetDemo';
  static const String netStateListenerDemo = '/netStateListenerDemo';
  static const String netStateListenerDemoOne = '/netStateListenerDemoOne';
  static const String interactiveViewerDemo = '/interactiveViewerDemo';
  static const String defaultTabControllerDemo = '/defaultTabControllerDemo';
  static const String regExpDemo = '/regExpDemo';
  static const String inputDatePickerFormFieldDemo = '/inputDatePickerFormFieldDemo';
  static const String dateRangePickerDialogDemo = '/dateRangePickerDialogDemo';
  static const String mergeableMaterialDemo = '/mergeableMaterialDemo';
  static const String navigationRailDemo = '/navigationRailDemo';
  static const String listTileDemo = '/listTileDemo';
  static const String refreshIndicatorDemo = '/refreshIndicatorDemo';
  static const String refreshIndicatorDemoOne = '/refreshIndicatorDemoOne';
  static const String tooltipDemo = '/tooltipDemo';
  static const String filterDemo = '/filterDemo';
  static const String filterDemoOne = '/filterDemoOne';
  static const String videoPlayerScreenDemo = '/videoPlayerScreenDemo';
  static const String boxWidgetDemo = '/boxWidgetDemo';
  static const String fractionallySizedBoxDemo = '/fractionallySizedBoxDemo';
  static const String listWheelScrollViewDemo = '/listWheelScrollViewDemo';
  static const String nnsliverPersistentHeaderDemo = '/nnsliverPersistentHeaderDemo';
  static const String nestedScrollViewDemoOne = '/nestedScrollViewDemoOne';
  static const String nestedScrollViewDemoTwo = '/nestedScrollViewDemoTwo';
  static const String testFunction = '/testFunction';
  static const String nSkeletonDemo = '/nSkeletonDemo';
  static const String nTreeDemo = '/nTreeDemo';
  static const String azlistviewDemo = '/azlistviewDemo';
  static const String expansionTileCard = '/expansionTileCard';
  static const String dialogChoiceChipDemo = '/dialogChoiceChipDemo';
  static const String textFieldLoginDemo = '/textFieldLoginDemo';
  static const String pageViewAndBarDemo = '/pageViewAndBarDemo';
  static const String pageViewDemoOne = '/pageViewDemoOne';
  static const String dropBoxChoicDemo = '/dropBoxChoicDemo';
  static const String dropBoxChoicDemoNew = '/dropBoxChoicDemoNew';
  static const String dropBoxMutiRowChoicDemo = '/dropBoxMutiRowChoicDemo';
  static const String slidableDemoOne = '/slidableDemoOne';
  static const String discussListPage = '/discussListPage';
  static const String imChatPage = '/imChatPage';
  static const String imChatSettingPage = '/imChatSettingPage';
  static const String imChatBubbleChange = '/ImChatBubbleChange';
  static const String aiChatPage = '/AIChatPage';
  static const String aiChatSettingPage = '/AIChatSettingPage';
  static const String imConversationPage = '/ImConversationPage';
  static const String livestreamEffectPage = '/livestreamEffectPage';
  static const String soundPlayDemo = '/soundPlayDemo';
  static const String wPopupMenuDemo = '/wPopupMenuDemo';
  static const String expandTextDemo = '/expandTextDemo';
  static const String syncfusionFlutterDatepickerDemo = '/syncfusionFlutterDatepickerDemo';
  static const String tableCalenderMain = '/tableCalenderMain';
  static const String neomorphismHomePage = '/neomorphismHomePage';
  static const String uploadFileDemo = '/uploadFileDemo';
  static const String fileUploadBoxDemo = '/fileUploadBoxDemo';

  static const String customSingleChildLayoutDemo = '/customSingleChildLayoutDemo';
  static const String customMultiChildLayoutDemo = '/customMultiChildLayoutDemo';
  static const String refreshListView = '/refreshListView';
  static const String npageViewDemo = '/npageViewDemo';
  static const String boxShadowDemoOne = '/boxShadowDemoOne';
  static const String getxDemo = '/getxDemo';
  static const String globalIsolateDemo = '/globalIsolateDemo';
  static const String longCaptureWidgetDemo = '/LongCaptureWidgetDemo';
  static const String jsonToModel = '/jsonToModel';
  static const String assetUploadBoxDemo = '/assetUploadBoxDemo';
  static const String keyboardAttachDemo = '/keyboardAttachDemo';
  static const String keyboardObserverDemo = '/keyboardObserverDemo';
  static const String dashLineDemo = '/dashLineDemo';
  static const String scaffoldBottomSheet = '/scaffoldBottomSheet';
  static const String floatingActionButtonDemo = '/floatingActionButtonDemo';
  static const String flutterPickersDemo = '/flutterPickersDemo';
  static const String imageStretchDemo = '/imageStretchDemo';
  static const String dropdownMenuDemo = '/dropdownMenuDemo';
  static const String searchDemo = '/searchDemo';
  static const String switchDemo = '/switchDemo';
  static const String gestureDetectorDemo = '/gestureDetectorDemo';
  static const String compositedTransformTargetDemo = '/compositedTransformTargetDemo';
  static const String drawCanvasDemo = '/drawCanvasDemo';
  static const String contextMenuDemo = '/contextMenuDemo';
  static const String targetFollowerDemo = '/targetFollowerDemo';
  static const String tapRegionDemo = '/tapRegionDemo';
  static const String glowingOverscrollIndicatorDemo = '/glowingOverscrollIndicatorDemo';
  static const String progressClipperDemo = '/progressClipperDemo';
  static const String heroDemo = '/heroDemo';
  static const String hitTestBehaviorDemo = '/hitTestBehaviorDemo';
  static const String qrcodePage = '/qrcodePage';
  static const String menuAnchorDemo = '/menuAnchorDemo';
  static const String menuBarDemo = '/MenuBarDemo';
  static const String choiceBoxOneDemo = '/choiceBoxOneDemo';
  static const String apiConvertPage = '/apiConvertPage';
  static const String selectListDemo = '/selectListDemo';
  static const String avatarGroupDemo = '/avatarGroupDemo';
  static const String overlayPortalDemo = '/overlayPortalDemo';
  static const String appBarColorChangerDemo = '/appBarColorChangerDemo';
  static const String footerButtonBarDemo = '/footerButtonBarDemo';
  static const String sectionHeaderDemo = '/sectionHeaderDemo';
  static const String todoListTabPage = '/todoListTabPage';
  static const String studentTabPage = '/studentTabPage';
  static const String orderListTabPage = '/orderListTabPage';
  static const String componentMiddlePage = '/componentMiddlePage';
  static const String sliverMainAxisGroupDemo = '/sliverMainAxisGroupDemo';
  static const String twoDimensionalGridViewDemo = '/TwoDimensionalGridViewDemo';
  static const String listenerHeaderPage = '/listenerHeaderPage';
  static const String nwebViewDemo = '/nwebViewDemo';
  static const String iconConvertPage = '/iconConvertPage';
  static const String alignmentDrawDemo = '/alignmentDrawDemo';
  static const String displayFeatureDemo = '/displayFeatureDemo';
  static const String preferredSizeDemo = '/preferredSizeDemo';
  static const String ntabBarPageDemo = '/ntabBarPageDemo';
  static const String nTabBarViewCustomDemo = '/nTabBarViewCustomDemo';
  static const String textFieldTabDemo = '/textFieldTabDemo';
  static const String textPaintDemo = '/textPaintDemo';
  static const String segmentedPageViewDemo = '/segmentedPageViewDemo';
  static const String nPinnedTabBarPageDemo = '/nPinnedTabBarPageDemo';
  static const String nRefreshViewDemo = '/nRefreshViewDemo';
  static const String tracelessLoadDemo = '/tracelessLoadDemo';
  static const String nestedScrollViewDemoThree = '/nestedScrollViewDemoThree';
  static const String apiCreatePage = '/apiCreatePage';
  static const String formDemo = '/formDemo';
  static const String asyncDemo = '/asyncDemo';
  static const String choiceExpansionDemo = '/nchoiceExpansionDemo';
  static const String riverPodPageCreate = '/riverPodPageCreate';
  static const String getxRouteCreatePage = '/getxRouteCreatePage';
  static const String getxControllerDemo = '/GetxControllerDemo';
  static const String nTransformViewDemo = '/nTransformViewDemo';
  static const String dataTypeDemo = '/dataTypeDemo';
  static const String compareToPage = '/compareToPage';
  static const String queueAlertDemo = '/queueAlertDemo';
  static const String flutterPickerUtilDemo = '/flutterPickerUtilDemo';
  static const String audioPlayPage = '/AudioPlayPage';
  static const String audioPlayPageDemo = '/AudioPlayPageDemo';
  static const String chewiePlayerPage = '/chewiePlayerPage';
  static const String segmentVerticalDemo = '/segmentVerticalDemo';
  static const String decoratedBoxTransitionDemo = '/decoratedBoxTransitionDemo';
  static const String aeReportPage = '/aeReportPage';
  static const String scaffoldDemo = '/scaffoldDemo';
  static const String sliverMainAxisGroupDemoOne = '/SliverMainAxisGroupDemoOne';
  static const String listBodyDemo = '/listBodyDemo';
  static const String scanAnimationDemo = '/scanAnimationDemo';
  static const String lerpDemo = '/lerpDemo';
  static const String convertFlle = '/ConvertFlle';
  static const String splitViewDemo = '/SplitViewDemo';
  static const String directoryTestDemo = '/directoryTestDemo';
  static const String nestedNavigatorDemo = '/nestedNavigatorDemo';
  static const String nTweenTransitionDemo = '/nTweenTransitionDemo';
  static const String hapticFeedbackDemo = '/hapticFeedbackDemo';
  static const String webviewDemo = '/webviewDemo';
  static const String secureKeyboardDemo = '/secureKeyboardDemo';
  static const String popScopeDemo = '/popScopeDemo';
  static const String nestedScrollViewDemoHome = '/nestedScrollViewDemoHome';
  static const String nestedScrollViewDemoFive = '/nestedScrollViewDemoFive';
  static const String nestedScrollViewDemoSix = '/nestedScrollViewDemoSix';
  static const String irregularClipperDemo = '/irregularClipperDemo';
  static const String ocrPhotoDemo = '/ocrPhotoDemo';
  static const String recognizeTextPage = '/recognizeTextPage';
  static const String translationTextPage = '/translationTextPage';
  static const String floatingButtonDemo = '/floatingButtonDemo';
  static const String floatingButtonDemoOne = '/floatingButtonDemoOne';
  static const String floatingButtonDemoTwo = '/floatingButtonDemoTwo';
  static const String floatingButtonDemoThree = '/floatingButtonDemoThree';

  static const String urlLauncherDemo = '/urlLauncherDemo';
  static const String iteratorDemo = '/iteratorDemo';
  static const String chemotherapyRegimenDrugCaculator = '/chemotherapyRegimenDrugCaculator';
  static const String expressionsCalulatorDemo = '/expressionsCalulatorDemo';
  static const String jPushInfoPage = '/jPushInfoPage';
  static const String scanBarcodeDemo = '/scanBarcodeDemo';
  static const String animatedModalBarrierDemo = '/animatedModalBarrierDemo';
  static const String metaDataDemo = '/metaDataDemo';
  static const String appLocalePage = '/appLocalePage';
  static const String backgroundTaskDemo = '/backgroundTaskDemo';
  static const String colorSchemeDemo = '/colorSchemeDemo';
  static const String concurrentExecutorDemo = '/concurrentExecutorDemo';
  static const String gameMatchPage = '/gameMatchPage';
  static const String gameMatchPageNew = '/gameMatchPageNew';
  static const String gameMatchHorizalPage = '/gameMatchHorizalPage';
  static const String localAuthDemo = '/localAuthDemo';
  static const String deviceBrightnessAndVolumeDemo = '/deviceBrightnessAndVolumeDemo';
  static const String clickNotificationDemo = '/clickNotificationDemo';

  static const String colorFilterDemo = '/colorFilterDemo';
  static const String colorOpacityCompareDemo = '/colorOpacityCompareDemo';
  static const String pageTopBackgroudImageDemo = '/pageTopBackgroudImageDemo';
  static const String fingerViewDemo = '/fingerViewDemo';
  static const String dividerDemo = '/dividerDemo';
  static const String userDetailPage = '/userDetailPage';
  static const String animatedToggleSwitchDemo = '/animatedToggleSwitchDemo';
  static const String customTabbarPage = '/customTabbarPage';
  static const String pageRouteDemo = '/pageRouteDemo';
  static const String pageRouteAnimationDemo = '/pageRouteAnimationDemo';
  static const String fontFeatureDemo = '/fontFeatureDemo';
  static const String colorAnimationDemo = '/colorAnimationDemo';
  static const String restorationMixinDemo = '/restorationMixinDemo';
  static const String listenableDemo = '/listenableDemo';
  static const String autocompletePage = '/autocompletePage';
  static const String customRefreshIndicatorDemo = '/customRefreshIndicatorDemo';
  static const String nestedScrollViewDemoSeven = '/nestedScrollViewDemoSeven';
  static const String stackDemoThree = '/stackDemoThree';
  static const String themeMaterial3Page = '/themeMaterial3Page';
  static const String footballTeamPage = '/footballTeamPage';
  static const String scrollablePositionedListDemo = '/scrollablePositionedListDemo';
  static const String animatedPositionedDemo = '/animatedPositionedDemo';
  static const String tagSortPage = '/tagSortPage';
  static const String musicPlayerPage = '/musicPlayerPage';
  static const String articleDetailPage = '/articleDetailPage';
  static const String gradientPlaygroundPage = '/gradientPlaygroundPage';
  static const String redPacketRainDemo = '/redPacketRainDemo';
  static const String keyboardShortcutsDemo = '/keyboardShortcutsDemo';
  static const String overlayAnimationDemo = '/overlayAnimationDemo';
  static const String streamControllerDemo = '/streamControllerDemo';
  static const String nFlexSeparatedDemo = '/nFlexSeparatedDemo';
  static const String suffixTransitionDemo = '/suffixTransitionDemo';
  static const String tweenSequenceDemo = '/tweenSequenceDemo';
  static const String staggeredAnimationDemo = '/staggeredAnimationDemo';
  static const String ratingsStarPage = '/ratingsStarPage';
  static const String overlayEntryPage = '/overlayEntryPage';
  static const String inputAccessoryViewDemo = '/InputAccessoryViewDemo';
  static const String trackEventPage = '/trackEventPage';
  static const String pointShop = '/pointShop';
  static const String horizalStepPage = '/horizalStepPage';
  static const String textThemeDemo = '/textThemeDemo';
  static const String linkifyPage = '/linkifyPage';
  static const String annotatedRegion = '/AnnotatedRegion';
  static const String shimmerDemo = '/shimmerDemo';
  static const String w3ThemeColorPage = '/w3ThemeColorPage';
  static const String rebuildChainPage = '/rebuildChainPage';

  static const String INITIAL = AppRouter.appTabPage;
  // static const String INITIAL = AppRouter.developToolList;

  static GetPage get unknownRoute => AppRouterCore.unknownRoute;

  /// Core routes only. Demo routes are registered via [lazyLoadRoutes].
  static List<GetPage> get pages => AppRouterCore.pages;

  /// Load and register all demo [GetPage]s (idempotent, retryable on failure).
  static Future<void> lazyLoadRoutes() => AppRouterLazyLoader.ensure();

  /// Whether [name] is a known core route, or a demo route already registered.
  static bool hasRoute(String name) {
    if (pages.any((e) => e.name == name)) {
      return true;
    }
    return AppRouterLazyLoader.hasRoute(name);
  }
}
