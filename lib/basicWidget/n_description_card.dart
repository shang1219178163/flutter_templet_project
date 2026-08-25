import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_lang_segment_control.dart';
import 'package:flutter_templet_project/basicWidget/n_style_card.dart';

export 'n_lang_segment_control.dart' show NLangEnum, NLangSegmentControl;

/// Top-of-page description card for demo pages.
///
/// Supports English / Chinese; defaults to [NLangEnum.en].
/// Pass [child] to wrap property controls under the enhancement copy.
class NDescriptionCard extends StatefulWidget {
  const NDescriptionCard({
    super.key,
    required this.comparedTo,
    required this.items,
    this.initialLang = NLangEnum.en,
    this.child,
  });

  /// Official widget this enhances, e.g. `BottomNavigationBar`.
  final String comparedTo;

  /// Bilingual enhancement bullets keyed by [NLangEnum].
  final List<Map<NLangEnum, String>> items;

  /// Defaults to English.
  final NLangEnum initialLang;

  /// Optional property panel wrapped by this card.
  final Widget? child;

  @override
  State<NDescriptionCard> createState() => _NDescriptionCardState();
}

class _NDescriptionCardState extends State<NDescriptionCard> {
  late NLangEnum _lang = widget.initialLang;

  String get _eyebrow => switch (_lang) {
        NLangEnum.en => 'Enhancements',
        NLangEnum.zh => '说明',
      };

  String get _comparedPrefix => switch (_lang) {
        NLangEnum.en => 'Compared with',
        NLangEnum.zh => '对比组件',
      };

  void _setLanguage(NLangEnum language) {
    if (_lang == language) {
      return;
    }
    setState(() => _lang = language);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isZh = _lang == NLangEnum.zh;
    return NStyleCard(
      icon: const Icon(Icons.auto_awesome_rounded),
      header: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: Column(
          key: ValueKey(_lang),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _eyebrow,
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.35,
                ),
                children: [
                  TextSpan(text: '$_comparedPrefix '),
                  TextSpan(
                    text: widget.comparedTo,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      trailing: NLangSegmentControl(
        value: _lang,
        onChanged: _setLanguage,
      ),
      footer: widget.child,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: Column(
          key: ValueKey('items-$_lang'),
          children: [
            for (var i = 0; i < widget.items.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _NDescriptionItem(
                index: i + 1,
                text: widget.items[i][_lang] ?? '',
                compact: isZh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NDescriptionItem extends StatelessWidget {
  const _NDescriptionItem({
    required this.index,
    required this.text,
    required this.compact,
  });

  final int index;
  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.secondaryContainer,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            '$index',
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSecondaryContainer,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface,
                height: compact ? 1.4 : 1.45,
                fontSize: 13.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
