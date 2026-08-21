import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_box_segment_control.dart';

export 'n_box_segment_control.dart' show NBoxSegmentControl;

/// Display language for bilingual demo copy.
enum NDescriptionLanguage {
  en('EN'),
  zh('中文');

  const NDescriptionLanguage(this.label);

  /// Segment control display text.
  final String label;
}

/// One enhancement bullet in English and Chinese.
class NDescriptionItem {
  const NDescriptionItem({
    required this.en,
    required this.zh,
  });

  final String en;
  final String zh;

  String text(NDescriptionLanguage language) {
    return language == NDescriptionLanguage.zh ? zh : en;
  }
}

/// Top-of-page description card for demo pages.
///
/// Supports English / Chinese; defaults to [NDescriptionLanguage.en].
class NDescriptionCard extends StatefulWidget {
  const NDescriptionCard({
    super.key,
    required this.comparedTo,
    required this.items,
    this.initialLanguage = NDescriptionLanguage.en,
  });

  /// Official widget this enhances, e.g. `BottomNavigationBar`.
  final String comparedTo;

  /// Bilingual enhancement bullets.
  final List<NDescriptionItem> items;

  /// Defaults to English.
  final NDescriptionLanguage initialLanguage;

  @override
  State<NDescriptionCard> createState() => _NDescriptionCardState();
}

class _NDescriptionCardState extends State<NDescriptionCard> {
  late NDescriptionLanguage _language = widget.initialLanguage;

  String get _eyebrow => switch (_language) {
        NDescriptionLanguage.en => 'Enhancements',
        NDescriptionLanguage.zh => '增强说明',
      };

  String get _subtitle => switch (_language) {
        NDescriptionLanguage.en => 'Compared with',
        NDescriptionLanguage.zh => '对比组件',
      };

  void _setLanguage(NDescriptionLanguage language) {
    if (_language == language) {
      return;
    }
    setState(() => _language = language);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isZh = _language == NDescriptionLanguage.zh;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.65),
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.primary,
                      scheme.tertiary,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            size: 20,
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: Column(
                              key: ValueKey(_language),
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      TextSpan(text: '$_subtitle '),
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
                        ),
                        const SizedBox(width: 8),
                        NBoxSegmentControl<NDescriptionLanguage>(
                          labels: NDescriptionLanguage.values,
                          index: _language.index,
                          onChanged: (i) => _setLanguage(NDescriptionLanguage.values[i]),
                          itemBuilder: (context, language, selected) {
                            return Text(language.label);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(
                      height: 1,
                      color: scheme.outlineVariant.withValues(alpha: 0.55),
                    ),
                    const SizedBox(height: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: Column(
                        key: ValueKey('items-$_language'),
                        children: [
                          for (var i = 0; i < widget.items.length; i++) ...[
                            if (i > 0) const SizedBox(height: 8),
                            _NDescriptionRow(
                              index: i + 1,
                              text: widget.items[i].text(_language),
                              compact: isZh,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NDescriptionRow extends StatelessWidget {
  const _NDescriptionRow({
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
