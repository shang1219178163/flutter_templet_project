import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_lang_segment_control.dart';

export 'n_lang_segment_control.dart' show NLangEnum, NLangSegmentControl;

/// Top-of-page description card for demo pages.
///
/// Supports English / Chinese; defaults to [NLangEnum.en].
/// Pass [child] to wrap property controls under the enhancement copy.
class NDescriptionCard extends StatefulWidget {
  const NDescriptionCard({
    super.key,
    this.initialLang = NLangEnum.en,
    required this.title,
    this.subtitle,
    required this.items,
    this.child,
  });

  /// Defaults to English.
  final NLangEnum initialLang;

  /// 主色标题，按语言取文案。
  final Map<NLangEnum, String> title;

  /// 副标题，按语言取文案。
  final Map<NLangEnum, String>? subtitle;

  /// Bilingual enhancement bullets keyed by [NLangEnum].
  final List<Map<NLangEnum, String>> items;

  /// Optional property panel wrapped by this card.
  final Widget? child;

  @override
  State<NDescriptionCard> createState() => _NDescriptionCardState();
}

class _NDescriptionCardState extends State<NDescriptionCard> {
  late NLangEnum _lang = widget.initialLang;

  void onChangedLang(NLangEnum v) {
    if (_lang == v) {
      return;
    }
    setState(() => _lang = v);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isZh = _lang == NLangEnum.zh;
    return NDecorationCard(
      icon: const Icon(Icons.auto_awesome_rounded),
      header: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: Column(
          key: ValueKey(_lang),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title[_lang] ?? '',
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.subtitle![_lang] ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
            ],
          ],
        ),
      ),
      trailing: NLangSegmentControl(
        value: _lang,
        onChanged: onChangedLang,
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
