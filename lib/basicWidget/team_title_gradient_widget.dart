import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 组队标题渐进色背景色组件
class TeamTitleGradientWidget extends StatelessWidget {
  const TeamTitleGradientWidget({
    super.key,
    this.isRevesed = true,
    required this.logo,
    this.iconSize = 20,
    required this.name,
    this.color = Colors.pink,
  });

  final bool isRevesed;
  final String logo;
  final double iconSize;
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final children = [
      const SizedBox(width: 6),
      CachedNetworkImage(
        imageUrl: logo,
        width: iconSize,
        height: iconSize,
        placeholder: (context, url) => Icon(Icons.insert_photo_outlined, size: iconSize),
        errorWidget: (context, url, error) => Icon(Icons.insert_photo_outlined, size: iconSize),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: isRevesed ? TextAlign.left : TextAlign.right,
        ),
      ),
    ];

    if (isRevesed) {
      return Container(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border(left: BorderSide(width: 3, color: color)),
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
        ),
        child: Row(
          children: children,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        border: Border(right: BorderSide(width: 3, color: color)),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
      ),
      child: Row(
        children: children.reversed.toList(),
      ),
    );
  }
}

/// 比赛标题渐进色背景色组件
class TeamNameMatchGradientWidget extends StatelessWidget {
  const TeamNameMatchGradientWidget({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    required this.logo,
    this.iconSize = 20,
    required this.name,
    this.color = Colors.pink,
    required this.awayLogo,
    required this.awayName,
    this.awayColor = Colors.green,
  });

  final EdgeInsets? padding;
  final double iconSize;

  final String logo;
  final String name;
  final Color color;

  final String awayLogo;
  final String awayName;
  final Color awayColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: TeamTitleGradientWidget(
              logo: logo,
              iconSize: iconSize,
              name: name,
              color: color,
            ),
          ),
          Expanded(
            child: TeamTitleGradientWidget(
              isRevesed: false,
              logo: awayLogo,
              iconSize: iconSize,
              name: awayName,
              color: awayColor,
            ),
          ),
        ],
      ),
    );
  }
}
