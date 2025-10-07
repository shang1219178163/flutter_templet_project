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
            title,
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
          const SizedBox(height: 4),
          Text(
            '特性: ${features.map((f) => f.feature).join(', ')}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
