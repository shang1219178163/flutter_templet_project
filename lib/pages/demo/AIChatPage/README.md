# AI 流式对话 Demo

OpenAI 兼容接口的流式聊天示例：DeepSeek / Kimi（Moonshot），支持 Mock 与真实 SSE。

> 全局约定见 [doc/Ai_Rules.md](../../../../doc/Ai_Rules.md)：**代码精简时保留中文注释**。

## 目录结构

```
AIChatPage/
├── AIChatPage.dart              # 聊天页 UI 编排
├── AIChatSettingPage.dart       # 设置页（提供商 / Key 只读 / 模型列表）
├── README.md                    # 本文档
├── enum/
│   ├── ai_provider.dart         # 提供商
│   ├── ai_chat_role.dart        # 消息角色
│   ├── ai_stream_event_kind.dart# 流式事件类型
│   ├── ai_reply_phase.dart      # 回复相位
│   └── ai_sse_progress.dart     # SSE 流进度
├── controller/
│   └── ai_chat_controller.dart  # 状态：消息、流式、打字缓冲、配置缓存
├── model/
│   ├── ai_chat_models.dart      # barrel：消息 / 会话 / 流式事件
│   ├── ai_chat_message.dart     # 单条消息
│   ├── ai_chat_session.dart     # 历史会话
│   └── ai_stream_event.dart     # 流式事件
├── parser/
│   ├── ai_chat_stream_source.dart  # Mock / Dio SSE 数据源
│   ├── sse_event_parser.dart       # SSE 行缓冲解析
│   ├── ai_chat_error.dart          # 链接中断等错误文案
│   ├── api_client.dart             # ApiClient：非流式拉取 /models
│   ├── ai_provider_config.dart     # 运行态配置（Key / URL / model / 列表）
│   └── ai_env_service.dart         # 从 .env 读取各 provider 的 API Key
└── widget/
    ├── ai_chat_app_bar_actions.dart
    ├── ai_chat_error_banner.dart
    ├── ai_chat_history_drawer.dart  # 历史会话（NOverlayDialog 左滑）
    ├── ai_chat_input_bar.dart
    ├── ai_chat_message_list.dart
    └── ai_chat_message_bubble.dart
```

## 数据流

```
用户发送
  → AiChatController.send
  → SwitchingAiChatStreamSource（Mock 或 DioSse）
  → AiStreamEvent（delta / done / error）
  → 打字队列（按 rune）→ Timer 吐到气泡
  → ChangeNotifier → UI ListenableBuilder 刷新
```

## 提供商与配置

| 类型 | 职责 |
|------|------|
| `AiProvider` | 枚举身份 + `label` / `defaultBaseUrl` / `defaultModel` |
| `AiProviderConfig` | 可变运行态：`apiKey` / `baseUrl` / `model` / `models` |

每个 `AiChatController` 持有一份 `Map<AiProvider, AiProviderConfig>`，互不共享可变状态。

### 持久化（CacheKey）

- `aiProvider`：当前选中的提供商名
- `aiDeepseekConfig` / `aiKimiConfig`：整包 Map  
  `{ baseUrl, model, models }`（**不含 apiKey**）
- `aiChatSessions`：历史会话列表 JSON

API Key **不写 SharedPreferences**，每次从 `.env`（`AiEnvService`）或 `--dart-define=DEEPSEEK_API_KEY`（仅 DeepSeek）解析，改 Key 后重启即生效。

设置页中 Key / 请求地址为**只读**展示；可切换提供商并刷新模型列表。生成中不可切换提供商。

AppBar 左侧 `more_horiz` 打开历史会话（`NOverlayDialog.drawer` 从左滑入）；右侧「新会话」会先归档再清空上下文。

### 切换提供商

1. 落盘当前配置  
2. 载入目标配置并同步 remote（URL / Key / model）  
3. **清空会话**（避免带着 A 的历史让 B「接着扮演 A」）  
4. 自动拉取模型列表  

## 本地配置

### `.env`（assets，git 忽略）

```json
[
  { "name": "deepseek", "key": "sk-xxx" },
  { "name": "kimi", "key": "sk-xxx" }
]
```

`name` 与 `AiProvider` 枚举名一致。启动时调用 `AiEnvService.load()`。

### dart-define

```bash
flutter run --dart-define=DEEPSEEK_API_KEY=sk-xxx
```

## 路由

- 聊天：`AppRouter.aiChatPage`
- 设置：`AppRouter.aiChatSettingPage`（`Get.to` 构造器传入共享 `AiChatController`，勿放 arguments）

## 注意事项

- 流式中禁止切换 Mock/Remote、禁止切换 provider。  
- SSE 使用有状态 `Utf8Decoder`，避免中文跨包截断。  
- Kimi 使用中国区 `api.moonshot.cn`；国际区 `api.moonshot.ai` 会 401。  
- API Key 仅来自 `.env` / dart-define，不写入缓存；正式环境勿把真实 Key 打进 assets。
