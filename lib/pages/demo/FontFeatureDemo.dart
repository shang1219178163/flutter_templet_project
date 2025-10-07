import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FontFeatureDemo extends StatefulWidget {
  const FontFeatureDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<FontFeatureDemo> createState() => _FontFeatureDemoState();
}

class _FontFeatureDemoState extends State<FontFeatureDemo> {
  final scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant FontFeatureDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildFontFeature(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFontFeature() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection('数字样式特性', [
          _buildFeatureItem('等宽数字 (tabular)', '金额: \$12,345.00', [FontFeature.tabularFigures()]),
          _buildFeatureItem('等宽数字 (tnum)', '1234567890', [FontFeature.enable('tnum')]),
          _buildFeatureItem('比例数字 (proportional)', '电话号码: 123-456-7890', [FontFeature.proportionalFigures()]),
          _buildFeatureItem('旧式数字 (oldstyle)', '年份: 2024', [FontFeature.oldstyleFigures()]),
          _buildFeatureItem('衬线数字 (lining)', '统计: 1,234,567', [FontFeature.liningFigures()]),
          _buildFeatureItem('斜线零 (slashed zero)', '代码: 10010', [FontFeature.slashedZero()]),
        ]),
        _buildSection('连字特性', [
          _buildFeatureItem('标准连字', 'office offer affinity', [FontFeature.enable('liga')]),
          _buildFeatureItem('自由连字', 'often first act', [FontFeature.enable('dlig')]),
          _buildFeatureItem('禁用连字', 'office offer affinity', [FontFeature.disable('liga')]),
        ]),
        _buildSection('字符变体', [
          _buildFeatureItem('小型大写字母', 'Hello WORLD Flutter', [FontFeature.enable('smcp')]),
          _buildFeatureItem('标准分数', '食谱: 1/2杯面粉 3/4茶匙盐', [FontFeature.enable('frac')]),
          _buildFeatureItem('上标', '数学公式: x² + y² = z²', [FontFeature.enable('sups')]),
          _buildFeatureItem('下标', '化学式: H₂O CO₂ CH₄', [FontFeature.enable('subs')]),
          _buildFeatureItem('替代样式', '特殊符号: check → ✓', [FontFeature.enable('salt')]),
        ]),
        _buildSection('组合特性', [
          _buildFeatureItem(
              '等宽数字 + 小型大写', 'CODE: ABC123 XYZ789', [FontFeature.tabularFigures(), FontFeature.enable('smcp')]),
          _buildFeatureItem('旧式数字 + 连字', 'fi fl 123456', [FontFeature.oldstyleFigures(), FontFeature.enable('liga')]),
        ]),
        _buildSection('高级特性', [
          _buildFeatureItem('样式集 1', '风格化文本', [FontFeature.stylisticSet(1)]),
          _buildFeatureItem('样式集 2', '另一种风格', [FontFeature.stylisticSet(2)]),
          // _buildFeatureItem('字符宽度', '压缩文本',
          //     [FontFeature.characterWidth(3)]), // 1-9
          _buildFeatureItem('替代注释形式', '数字注释', [FontFeature.alternative(1)]),
        ]),
        _buildSection('序数形式 (ordn)', [
          _buildFeatureItem('启用序数', '1st 2nd 3rd 4th', [FontFeature.ordinalForms()]),
        ]),
        _buildSection('小型大写字母变体', [
          _buildFeatureItem('小型大写 (smcp)', 'Hello WORLD', [FontFeature.enable('smcp')]),
          _buildFeatureItem('大写转小型大写 (c2sc)', 'Hello WORLD', [FontFeature.enable('c2sc')]),
          _buildFeatureItem('smcp + c2sc', 'Hello WORLD', [FontFeature.enable('smcp'), FontFeature.enable('c2sc')]),
        ]),
        _buildSection('字距和间距', [
          _buildFeatureItem('启用字距 (kern)', 'AVATAR WAVE', [FontFeature.enable('kern')]),
          _buildFeatureItem('禁用字距', 'AVATAR WAVE', [FontFeature.disable('kern')]),
        ]),
        _buildSection('样式集 (ss01-ss20)', [
          _buildFeatureItem('样式集1 (stylisticSet)', 'abc 123', [FontFeature.stylisticSet(1)]),
          _buildFeatureItem('样式集1 (ss01)', 'abc 123', [FontFeature.enable('ss01')]),
          _buildFeatureItem('样式集2 (ss02)', 'abc 123', [FontFeature.enable('ss02')]),
        ]),
        _buildSection('字符变体 (cv01-cv99)', [
          _buildFeatureItem('字符变体1', 'a g 0 7', [FontFeature.enable('cv01')]),
          _buildFeatureItem('字符变体2', 'a g 0 7', [FontFeature.enable('cv02')]),
        ]),
        _buildSection('历史形式和装饰', [
          _buildFeatureItem('历史形式 (hist)', 'historical text', [FontFeature.enable('hist')]),
          _buildFeatureItem('花体字 (swsh)', 'Swash Text', [FontFeature.enable('swsh')]),
          _buildFeatureItem('标题替代字 (titl)', 'Title Text', [FontFeature.enable('titl')]),
        ]),
        _buildSection('大小写相关', [
          _buildFeatureItem('大小写形式 (case)', 'Text Case', [FontFeature.enable('case')]),
          _buildFeatureItem('全部小型大写 (unic)', 'Unicase Text', [FontFeature.enable('unic')]),
        ]),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildFeatureItem(String title, String demoText, List<FontFeature> features) {
    final featureDesc = features.map((f) => f.feature).join(', ');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title <$featureDesc>",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                demoText,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                demoText,
                style: TextStyle(
                  fontSize: 16,
                  fontFeatures: features,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 4),
          // Text(
          //   '特性: ${features.map((f) => f.feature).join(', ')}',
          //   style: const TextStyle(
          //     fontSize: 12,
          //     color: Colors.grey,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class AllFontFeatures {
  // 数字样式
  static const tabularNumbers = FontFeature.tabularFigures();
  static const proportionalNumbers = FontFeature.proportionalFigures();
  static const oldstyleNumbers = FontFeature.oldstyleFigures();
  static const liningNumbers = FontFeature.liningFigures();
  static const slashedZero = FontFeature.slashedZero();
  static const ordinalForms = FontFeature.ordinalForms();

  // 连字
  static const standardLigatures = FontFeature.enable('liga');
  static const discretionaryLigatures = FontFeature.enable('dlig');
  static const historicalLigatures = FontFeature.enable('hlig');
  static const contextualLigatures = FontFeature.enable('clig');
  static const noLigatures = FontFeature.disable('liga');

  // 大小写
  static const smallCaps = FontFeature.enable('smcp');
  static const capsToSmallCaps = FontFeature.enable('c2sc');
  static const unicase = FontFeature.enable('unic');
  static const caseForms = FontFeature.enable('case');

  // 位置
  static const superscript = FontFeature.enable('sups');
  static const subscript = FontFeature.enable('subs');
  static const numerators = FontFeature.enable('numr');
  static const denominators = FontFeature.enable('dnom');

  // 分数
  static const fractions = FontFeature.enable('frac');
  static const noFractions = FontFeature.disable('frac');

  // 间距
  static const kerning = FontFeature.enable('kern');
  static const noKerning = FontFeature.disable('kern');

  // 本地化
  static const localizedForms = FontFeature.enable('locl');

  // 替代样式
  static const stylisticAlternates = FontFeature.enable('salt');
  static const historicalForms = FontFeature.enable('hist');
  static const swash = FontFeature.enable('swsh');
  static const titling = FontFeature.enable('titl');

  // 数字间距
  static const tabularFigures = FontFeature.enable('tnum');
  static const proportionalFigures = FontFeature.enable('pnum');
}
