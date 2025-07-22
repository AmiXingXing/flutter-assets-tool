# Flutter Assets Tool 🚀

[English](#english) | [中文](#中文)

---

## English

### 📖 Overview

**Flutter Assets Tool** is a powerful desktop application that streamlines the process of adding image assets to Flutter projects. Say goodbye to the tedious manual steps of copying files, updating `pubspec.yaml`, and creating resource classes!

### ✨ Features

- 🎯 **One-Click Asset Import**: Select an image and automatically handle all the integration steps
- 📱 **Multi-Resolution Support**: Automatically detects and handles @2x and @3x images
- 🌍 **Internationalization**: Supports both English and Chinese interfaces
- 🔄 **Smart Renaming**: Automatically converts Chinese characters and special symbols to valid asset names
- 📁 **Workspace Management**: Remember recent workspaces for quick access
- 🖼️ **Image Preview**: View image details including resolution and file size
- 🎨 **Custom Asset Directory**: Configure your preferred assets folder structure
- 📝 **Auto Code Generation**: Generates resource classes with camelCase naming

### 🚀 Quick Start

1. **Download and Run**: Launch the Flutter Assets Tool application
2. **Select Workspace**: Choose your Flutter project root directory
3. **Pick Image**: Select the image file you want to add
4. **Configure**: Set the asset directory and image name
5. **Import**: Click "Add to Project" and you're done!

### 📋 What It Does Automatically

When you import an image, the tool automatically:

1. **Copies Files**: 
   - Main image → `assets/images/your_image.png`
   - @2x image → `assets/images/2.0x/your_image.png`
   - @3x image → `assets/images/3.0x/your_image.png`

2. **Updates pubspec.yaml**:
   ```yaml
   flutter:
     assets:
       - assets/images/your_image.png
       - assets/images/2.0x/your_image.png
       - assets/images/3.0x/your_image.png
   ```

3. **Generates Resource Class**:
   ```dart
   class ImgR {
     static const String yourImage = "assets/images/your_image.png";
   }
   ```

### 🛠️ Installation

#### Prerequisites
- Flutter SDK 3.32.5 or higher
- Windows, macOS, or Linux

#### Build from Source
```bash
git clone https://github.com/yourusername/flutter-assets-tool.git
cd flutter-assets-tool
flutter pub get
flutter run -d windows  # or -d macos, -d linux
```

### 🎯 Use Cases

- **Rapid Prototyping**: Quickly add images to your Flutter prototypes
- **Team Development**: Standardize asset management across your team
- **Large Projects**: Efficiently manage hundreds of image assets
- **Internationalization**: Handle assets for multi-language apps

### 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 中文

### 📖 项目简介

**Flutter Assets Tool** 是一个强大的桌面应用程序，用于简化向 Flutter 项目添加图片资源的流程。告别繁琐的手动操作，一键完成文件复制、更新 `pubspec.yaml` 和创建资源类！

### ✨ 主要特性

- 🎯 **一键资源导入**: 选择图片后自动处理所有集成步骤
- 📱 **多分辨率支持**: 自动检测和处理 @2x 和 @3x 图片
- 🌍 **国际化支持**: 支持中英文界面切换
- 🔄 **智能重命名**: 自动将中文字符和特殊符号转换为有效的资源名称
- 📁 **工作区管理**: 记住最近使用的工作区，快速访问
- 🖼️ **图片预览**: 查看图片详情，包括分辨率和文件大小
- 🎨 **自定义资源目录**: 配置您偏好的资源文件夹结构
- 📝 **自动代码生成**: 生成采用驼峰命名的资源类

### 🚀 快速开始

1. **下载运行**: 启动 Flutter Assets Tool 应用程序
2. **选择工作区**: 选择您的 Flutter 项目根目录
3. **选择图片**: 选择要添加的图片文件
4. **配置设置**: 设置资源目录和图片名称
5. **导入资源**: 点击"添加到工程"即可完成！

### 📋 自动化处理流程

当您导入图片时，工具会自动：

1. **复制文件**: 
   - 主图片 → `assets/images/your_image.png`
   - 2倍图 → `assets/images/2.0x/your_image.png`
   - 3倍图 → `assets/images/3.0x/your_image.png`

2. **更新 pubspec.yaml**:
   ```yaml
   flutter:
     assets:
       - assets/images/your_image.png
       - assets/images/2.0x/your_image.png
       - assets/images/3.0x/your_image.png
   ```

3. **生成资源类**:
   ```dart
   class ImgR {
     static const String yourImage = "assets/images/your_image.png";
   }
   ```

### 🛠️ 安装说明

#### 环境要求
- Flutter SDK 3.32.5 或更高版本
- Windows、macOS 或 Linux

#### 从源码构建
```bash
git clone https://github.com/yourusername/flutter-assets-tool.git
cd flutter-assets-tool
flutter pub get
flutter run -d windows  # 或 -d macos, -d linux
```

### 🎯 使用场景

- **快速原型开发**: 快速为 Flutter 原型添加图片
- **团队开发**: 在团队中标准化资源管理流程
- **大型项目**: 高效管理数百个图片资源
- **国际化应用**: 处理多语言应用的资源管理

### 🤝 贡献指南

我们欢迎贡献！请随时提交 Pull Request。对于重大更改，请先开启 issue 讨论您想要更改的内容。

### 📄 开源协议

本项目采用 MIT 协议 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

### 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=yourusername/flutter-assets-tool&type=Date)](https://star-history.com/#yourusername/flutter-assets-tool&Date)

### 📞 联系我们

- 🐛 [报告问题](https://github.com/yourusername/flutter-assets-tool/issues)
- 💡 [功能建议](https://github.com/yourusername/flutter-assets-tool/issues)
- 📧 Email: your.email@example.com

---

**Made with ❤️ for the Flutter community**


