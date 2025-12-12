//
//  AeReportPage.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/25 18:09.
//  Copyright © 2024/6/25 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_address_choose_item.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_card.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_choose_item.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_date_choose_item.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_horizal_choose_item.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_horizal_choose_mutil_item.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_input_item.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_judge_item.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_patient_card.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_section_header.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_single_choose_item.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_upload_document_item.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_upload_image_item.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_skeleton_screen.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:flutter_templet_project/basicWidget/upload_document/asset_upload_document_model.dart';
import 'package:flutter_templet_project/enum/ActivityType.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/flutter_picker_util.dart';
import 'package:get/get.dart';

/// 不良事件上报
class AeReportPage extends StatefulWidget {
  const AeReportPage({super.key});

  @override
  State<AeReportPage> createState() => _AeReportPageState();
}

class _AeReportPageState extends State<AeReportPage> with SafeSetStateMixin {
  /// userNo-用户编号
  Map arguments = Get.arguments ?? {};

  /// 受试者id
  late String? userId = arguments["userId"];

  /// 受试者编号
  late String? userNo = arguments["userNo"];

  /// 不良事件id
  late String? aeId = arguments["aeId"] ?? arguments["id"];
  late String? from = arguments["from"];

  /// 是否仅读
  // late bool readOnly = arguments["readOnly"] ?? diaryId != null;
  late bool readOnly = arguments["readOnly"] ?? false;

  late String title = readOnly ? "不良事件详情" : '上报不良事件';

  AdverseEventRecord aeModel = AdverseEventRecord();

  /// 初始化数据
  var selectedModels = <AssetUploadModel>[];

  final aeNameController = TextEditingController();
  final aeLevelController = TextEditingController();

  final drugRelated = ValueNotifier<ActivityType?>(null);
  final drugMeasures = ValueNotifier<ActivityType?>(null);

  final aePrognosisMuti = ValueNotifier<List<ActivityType>?>(null);
  final aePrognosis = ValueNotifier<ActivityType?>(null);
  final aePrognosisNew = ValueNotifier<List<ActivityType>?>(null);

  /// 体重
  final weightData = <List<String>>[
    List.generate(240, (index) => '${index + 10}').toList(),
    List.generate(10, (index) => '.$index').toList(),
  ];
  final weightDataVN = ValueNotifier<List<String>?>(null);

  final dateBegin = ValueNotifier<DateTime?>(null);
  final dateEnd = ValueNotifier<DateTime?>(null);

  /// 是否采取措施
  final isTakeMeasures = ValueNotifier<bool?>(null);

  /// 是否为SAE
  final isSae = ValueNotifier<bool?>(null);

  late final judgeItems = <ChooseItemRecord<ValueNotifier<bool?>>>[
    (title: '是否采取措施', key: "TakeMeasures", value: isTakeMeasures),
    (title: '是否为SAE', key: "SAE", value: isSae),
  ];

  final remarkController = TextEditingController();

  final addressVN = ValueNotifier<AddressPickerModel?>(null);

  final isUploading = ValueNotifier(false);
  final isUploadingDoc = ValueNotifier(false);

  final selectedModelsVN = ValueNotifier<List<AssetUploadModel>>([]);
  final selectedModelsDocVN = ValueNotifier<List<AssetUploadDocumentModel>>([]);

  final isLoading = ValueNotifier(false);

  @override
  void dispose() {
    aeNameController.dispose();
    aeLevelController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    isLoading.value = true;

    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
        title: Text(title),
        titleTextStyle: TextStyle(
          color: AppColor.fontColor,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: const IconThemeData(color: AppColor.fontColor, size: 20),
        elevation: 0.0,
        backgroundColor: AppColor.bgColor,
        actions: [
          IconButton(
            onPressed: () {
              readOnly = !readOnly;
              setState(() {});
            },
            icon: Icon(Icons.currency_exchange),
          )
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          ToolUtil.removeInputFocus(); // 触摸收起键盘
        },
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, value, child) {
        if (value) {
          return const NSkeletonScreen();
        }

        return Column(
          children: [
            Expanded(
              child: buildScrollView(),
            ),
            buildButtonBar(),
          ],
        );
      },
    );
  }

  Widget buildScrollView() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          // color: Colors.green, //add test
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AeCard(
              children: [
                AePatientCard(
                  title: '张三',
                  avatar: '',
                  remark: '超级赛亚人',
                  section: '龙组',
                  status: '终极状态',
                ),
              ],
            ),
            AeCard(
              children: [
                AeInputItem(
                  title: 'AE名称',
                  enable: !readOnly,
                  controller: aeNameController,
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 30,
                  softWrap: false,
                  header: const AeSectionHeader(
                    title: 'AE名称',
                    isRequired: true,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeDateChooseItem(
                  enable: !readOnly,
                  selectVN: dateBegin,
                  onChanged: (e) {
                    DLog.d(e);
                  },
                  header: const AeSectionHeader(
                    title: '开始日期',
                    isRequired: true,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                ValueListenableBuilder(
                  valueListenable: dateBegin,
                  builder: (context, value, child) {
                    return AeDateChooseItem(
                      enable: !readOnly,
                      minDateTime: dateBegin.value,
                      selectVN: dateEnd,
                      onChanged: (e) {
                        DLog.d(e);
                      },
                      header: const AeSectionHeader(
                        title: '结束日期',
                        isRequired: false,
                      ),
                      // footer: const SizedBox(height: 15),
                    );
                  },
                ),
              ],
            ),
            AeCard(
              margin: const EdgeInsets.only(bottom: 0),
              children: [
                AeSingleChooseItem(
                  enable: !readOnly,
                  title: 'AE转归',
                  dataList: ActivityType.values,
                  selectVN: aePrognosis,
                  convertCb: (e) => e.desc,
                  onChanged: (e) {
                    DLog.d(e);
                  },
                  header: const AeSectionHeader(
                    title: 'AE转归',
                    isRequired: false,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeChooseItem(
                  enable: !readOnly,
                  title: 'AE转归多选Muti',
                  dataList: ActivityType.values,
                  selectVN: aePrognosisMuti,
                  convertCb: (e) => e.desc,
                  onChanged: (e) {
                    DLog.d(e);
                  },
                  header: const AeSectionHeader(
                    title: 'AE转归多选Muti',
                    isRequired: false,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeHorizalChooseMutilItem(
                  enable: !readOnly,
                  title: 'AE转归多选',
                  dataList: [ActivityType.values, ActivityType.values],
                  selectVN: aePrognosisNew,
                  convertCb: (e) => e.map((e) => e.desc).toList(),
                  onChanged: (e) {
                    DLog.d(e);
                  },
                  header: const AeSectionHeader(
                    title: 'AE转归多选',
                    isRequired: false,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeHorizalChooseItem(
                  enable: !readOnly,
                  title: '体重',
                  dataList: weightData,
                  selectVN: weightDataVN,
                  onChanged: (e) {
                    DLog.d(e);
                  },
                  header: const AeSectionHeader(
                    title: '体重',
                    isRequired: false,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeInputItem(
                  title: 'AE分级',
                  enable: !readOnly,
                  controller: aeLevelController,
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 30,
                  softWrap: false,
                  header: const AeSectionHeader(
                    title: 'AE分级',
                    isRequired: true,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeSingleChooseItem(
                  enable: !readOnly,
                  title: "药物相关性",
                  dataList: ActivityType.values,
                  selectVN: drugRelated,
                  convertCb: (e) => e.desc,
                  onChanged: (e) {
                    DLog.d(e);
                  },
                  header: const AeSectionHeader(
                    title: "药物相关性",
                    isRequired: false,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                ValueListenableBuilder(
                  valueListenable: drugRelated,
                  builder: (context, value, child) {
                    return AeSingleChooseItem(
                      enable: !readOnly,
                      title: "对实验用药采取的措施",
                      dataList: ActivityType.values,
                      selectVN: drugMeasures,
                      convertCb: (e) => e.desc,
                      onChanged: (e) {
                        DLog.d(e);
                      },
                      header: const AeSectionHeader(
                        title: "对实验用药采取的措施",
                        isRequired: false,
                      ),
                      footer: const SizedBox(height: 15),
                    );
                  },
                ),
                ...judgeItems.map((v) {
                  return AeJudgeItem(
                    enable: !readOnly,
                    keyName: v.key,
                    isYes: v.value,
                    onChanged: (keyName, val) {
                      DLog.d("$keyName, $val");
                    },
                    header: AeSectionHeader(
                      title: v.title,
                      isRequired: false,
                    ),
                    footer: const SizedBox(height: 15),
                  );
                }).toList(),
                AeAddressChooseItem(
                  selectVN: addressVN,
                  convertCb: (AddressPickerModel e) {
                    return [e.province, e.city, e.town].where((e) => e?.isNotEmpty == true).join();
                  },
                  onChanged: (e) {
                    DLog.d("$e");
                  },
                  header: const AeSectionHeader(
                    title: "地址信息",
                    isRequired: false,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeInputItem(
                  title: '备注',
                  enable: !readOnly,
                  controller: remarkController,
                  softWrap: true,
                  maxLines: null,
                  maxLength: null,
                  header: const AeSectionHeader(
                    title: '备注',
                    isRequired: false,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeInputItem(
                  title: '备注1',
                  enable: !readOnly,
                  controller: remarkController,
                  softWrap: true,
                  maxLines: 6,
                  maxLength: 2000,
                  showCounter: true,
                  isCounterInner: true,
                  header: const AeSectionHeader(
                    title: '备注1',
                    isRequired: false,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeInputItem(
                  title: '备注2',
                  enable: !readOnly,
                  controller: remarkController,
                  softWrap: true,
                  maxLines: 6,
                  showCounter: true,
                  isCounterInner: false,
                  header: const AeSectionHeader(
                    title: '备注2',
                    isRequired: false,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeUploadImageItem(
                  enable: !readOnly,
                  maxCount: 30,
                  selectedModels: selectedModelsVN.value,
                  // imgUrlsVN: null,
                  onUpload: (list) {
                    selectedModelsVN.value = list;
                  },
                  isUploading: isUploading,
                  header: const AeSectionHeader(
                    title: '上传图片',
                    isRequired: false,
                  ),
                  footer: const SizedBox(height: 15),
                ),
                AeUploadDocumentItem(
                  enable: !readOnly,
                  maxCount: 30,
                  selectedModels: selectedModelsDocVN.value,
                  // imgUrlsVN: null,
                  onUpload: (list) {
                    selectedModelsDocVN.value = list;
                    setState(() {});
                  },
                  isUploading: isUploadingDoc,
                  header: const AeSectionHeader(
                    title: '任务凭证上传（最多9个）',
                    isRequired: false,
                  ),
                  // footer: const SizedBox(height: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonBar() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        aeNameController,
        dateBegin,
        dateEnd,
        aePrognosis,
        aeLevelController,
        drugRelated,
        drugMeasures,
        isTakeMeasures,
        isSae,
        remarkController,
        isUploading,
        selectedModelsVN,
      ]),
      builder: (context, child) {
        aeModel.aeName = aeNameController.text;
        aeModel.startTime = dateBegin.value?.millisecondsSinceEpoch;
        aeModel.endTime = dateEnd.value?.millisecondsSinceEpoch;

        // aeModel.startTime =
        //     DateTimeExt.stringFromDateNew(date: dateBegin.value);
        // aeModel.endTime =
        //     DateTimeExt.stringFromDateNew(date: dateEnd.value);

        aeModel.aeLevel = aeLevelController.text;
        aeModel.remark = remarkController.text;

        aeModel.aePrognosis = aePrognosis.value?.name;
        aeModel.drugCorrelation = drugRelated.value?.name;
        aeModel.takenForDrugUse = drugMeasures.value?.name;

        aeModel.isTakeAction = isTakeMeasures.value?.toValue();
        aeModel.isSae = isSae.value?.toValue();

        // DLog.d([aeModel.aeName, aeModel.aeLevel, aeModel.remark]);

        final imageList = selectedModelsVN.value.map((e) {
          final name = e.file?.path.split("/").lastOrNull ?? "";
          return ProofDetailModel(name: name, url: e.url);
        }).toList();

        aeModel.imageUrls = imageList;

        var enable = true;

        return NFooterButtonBar(
          cancelTitle: "编辑",
          confirmTitle: readOnly ? '上传SAE资料' : "提交",
          hideCancel: !readOnly,
          hideConfirm: readOnly,
          boxShadow: const [],
          enable: !readOnly,
          onCancel: onCancel.debounce,
          onConfirm: () {},
          onConfirmTitle: (val) => onSubmit.debounce(val),
          // onConfirmTap: (v) {
          //   _debounce(() => onSubmit(v));
          // },
        );
      },
    );
  }

  /// 编辑
  Future<void> onCancel() async {
    ToolUtil.removeInputFocus();

    readOnly = false;
    title = "不良事件编辑";
    setState(() {});
  }

  Future<void> onSubmit(String btnTitle) async {
    ToolUtil.removeInputFocus();
  }
}

/// 不良事件详情
class AdverseEventRecord {
  AdverseEventRecord({
    this.id,
    this.createTime,
    this.updateTime,
    this.createBy,
    this.updateBy,
    this.remark,
    this.adverseEventId,
    this.aeName,
    this.startTime,
    this.endTime,
    this.aePrognosis,
    this.aeLevel,
    this.drugCorrelation,
    this.takenForDrugUse,
    this.isTakeAction,
    this.isSae,
    this.imageUrls,
  });

  String? id;
  int? createTime;
  int? updateTime;
  String? createBy;
  String? updateBy;
  String? remark;
  String? adverseEventId;
  String? aeName;
  int? startTime;
  int? endTime;
  String? aePrognosis;
  String? aeLevel;
  String? drugCorrelation;
  String? takenForDrugUse;
  String? isTakeAction;
  String? isSae;
  List<ProofDetailModel>? imageUrls;

  bool? get isTakeActionBool => isTakeAction?.toBool();
  bool? get isSaeBool => isSae?.toBool();

  ActivityType? get aePrognosisEnum {
    final result = ActivityType.values.where((e) => e.name == aePrognosis).firstOrNull;
    return result;
  }

  ActivityType? get drugCorrelationEnum {
    final result = ActivityType.values.where((e) => e.name == drugCorrelation).firstOrNull;
    return result;
  }

  ActivityType? get takenForDrugUseEnum {
    final result = ActivityType.values.where((e) => e.name == takenForDrugUse).firstOrNull;
    return result;
  }

  AdverseEventRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    createBy = json['createBy'];
    updateBy = json['updateBy'];
    remark = json['remark'];
    adverseEventId = json['adverseEventId'];
    aeName = json['aeName'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    aePrognosis = json['aePrognosis'];
    aeLevel = json['aeLevel'];
    drugCorrelation = json['drugCorrelation'];
    takenForDrugUse = json['takenForDrugUse'];
    isTakeAction = json['isTakeAction'];
    isSae = json['isSae'];
    if (json['imageUrls'] != null) {
      imageUrls = <ProofDetailModel>[];
      json['imageUrls'].forEach((v) {
        imageUrls!.add(ProofDetailModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['createBy'] = createBy;
    data['updateBy'] = updateBy;
    data['remark'] = remark;
    data['adverseEventId'] = adverseEventId;
    data['aeName'] = aeName;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['aePrognosis'] = aePrognosis;
    data['aeLevel'] = aeLevel;
    data['drugCorrelation'] = drugCorrelation;
    data['takenForDrugUse'] = takenForDrugUse;
    data['isTakeAction'] = isTakeAction;
    data['isSae'] = isSae;

    if (imageUrls != null) {
      data['imageUrls'] = imageUrls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// 上传凭证
class ProofDetailModel {
  ProofDetailModel({
    this.name,
    this.url,
  });

  /// 文件名
  String? name;

  /// 地址
  String? url;

  ProofDetailModel copyWith({
    String? name,
    String? url,
  }) {
    return ProofDetailModel(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  ProofDetailModel.fromJson(Map<String, dynamic> json) {
    name = (json['name'] as String?);
    url = (json['url'] as String?);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['url'] = url;
    return map;
  }
}
