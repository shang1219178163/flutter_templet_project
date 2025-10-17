import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_fe_app/pages/matches/basketball/basketball_matcher_details/widget/basketball_no_live.dart';
import 'package:social_fe_app/pages/matches/football/live_details/widget/no_live_view.dart';
import 'package:social_fe_app/widget/sliver_app_bar_delegate.dart';

class SliverDetailsView extends StatefulWidget {
  const SliverDetailsView({
    super.key,
    required this.header,
    required this.bottomWidget,
    required this.tab,
    required this.sportType,
  });

  final Widget header;
  final Widget tab;
  final Widget bottomWidget;
  final String sportType;

  @override
  State<SliverDetailsView> createState() => _SliverDetailsViewState();
}

class _SliverDetailsViewState extends State<SliverDetailsView> {
  num? height;

  final ValueNotifier<double> _opacity = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var size = Size(double.infinity, queryData.size.height * 267 / 844);
    height ??= size.height - 98;
    return Stack(
      children: [
        NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: (_, __) {
            return [
              // SliverAppBar(
              //   expandedHeight: size.height,
              //   pinned: false, // 允许继续滑动
              //   automaticallyImplyLeading: false,
              //   flexibleSpace: FlexibleSpaceBar(
              //     background: header,
              //   ),
              // ),
              // 固定 Header（在高度不足 76 时固定）
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                    minHeight: Platform.isIOS ? 108 : 100,
                    maxHeight: size.height,
                    child: widget.header,
                    onHeightChanged: (double value) {
                      Future.microtask(() {
                        if (mounted) {
                          if (height != null) {
                            double opacity = value / height!;

                            _opacity.value = opacity > 1
                                ? 1
                                : opacity < 0
                                    ? 0
                                    : opacity;
                          }
                        }
                      });
                    }),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  minHeight: 36,
                  maxHeight: 36,
                  child: widget.tab,
                ),
              ),
            ];
          },
          body: widget.bottomWidget,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: queryData.padding.top - (Platform.isIOS ? 6 : 0)),
            child: widget.sportType == 'football'
                ? NoLiveHeaderView(
                    scrollOffset: _opacity,
                  )
                : BasketballNoLiveAppBar(
                    scrollOffset: _opacity,
                  ),
          ),
        ),
      ],
    );
  }
}
