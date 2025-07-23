import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Assets Tool',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('zh'), // Chinese
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AssetToolPage(),
    );
  }
}

class AssetToolPage extends StatefulWidget {
  const AssetToolPage({super.key});

  @override
  State<AssetToolPage> createState() => _AssetToolPageState();
}

class _AssetToolPageState extends State<AssetToolPage> {
  String? _workspaceDirectory;
  String _assetsDirectory = 'assets/images/';
  String? _selectedImagePath;
  String? _selectedImageName;
  String _newImageName = '';
  String _selectedClass = 'ImgR';
  String? _selectedClassPath; // 添加资源类文件路径变量
  List<String> _recentWorkspaces = []; // 最近使用的工作目录
  Uint8List? _imageBytes;
  String? _imageResolution;
  bool _has2xImage = false;
  bool _has3xImage = false;
  String _selectedClassName = '';
  int _imageWidth = 0;
  int _imageHeight = 0;
  int _targetWidth = 0;
  int _targetHeight = 0;
  bool _enableResize = false;

  final TextEditingController _assetsDirController = TextEditingController();
  final TextEditingController _imageNameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _targetWidthController = TextEditingController();
  final TextEditingController _targetHeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _assetsDirController.text = _assetsDirectory;
    _classController.text = _selectedClassName;
    _loadSettings(); // 加载保存的设置
  }

  @override
  void dispose() {
    _assetsDirController.dispose();
    _imageNameController.dispose();
    _classController.dispose();
    _targetWidthController.dispose();
    _targetHeightController.dispose();
    super.dispose();
  }

  Future<void> _selectWorkspaceDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        _workspaceDirectory = selectedDirectory;
        
        // 添加到最近使用的工作目录列表
        _recentWorkspaces.remove(selectedDirectory); // 先移除避免重复
        _recentWorkspaces.insert(0, selectedDirectory); // 添加到开头
        
        // 只保留最近5个
        if (_recentWorkspaces.length > 5) {
          _recentWorkspaces = _recentWorkspaces.take(5).toList();
        }
      });
      
      // 加载该项目的配置
      await _loadSettings();
      await _saveSettings();
    }
  }

  Future<void> _selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _selectedImagePath = file.path;
        _selectedImageName = file.name;
        _imageBytes = file.bytes;
        _newImageName = _removeChineseAndSpecialChars(file.name);
        _imageNameController.text = _newImageName;
      });

      // 检查图片分辨率
      if (file.path != null) {
        await _checkImageInfo(file.path!);
      }
    }
  }

  String _removeChineseAndSpecialChars(String fileName) {
    // 移除中文字符和特殊字符，保留英文、数字、点和下划线
    String cleaned = fileName.replaceAll(RegExp(r'[^\w\.]'), '_');
    // 如果文件名以数字开头，添加img_前缀
    if (RegExp(r'^\d').hasMatch(cleaned)) {
      cleaned = 'img_$cleaned';
    }
    return cleaned;
  }

  Future<void> _checkImageInfo(String imagePath) async {
    final localizations = AppLocalizations.of(context)!;
    
    try {
      File imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        // 获取图片目录
        String imageDir = path.dirname(imagePath);
        String baseName = path.basenameWithoutExtension(imagePath);
        String extension = path.extension(imagePath);

        // 检查2倍图
        String image2xPath = path.join(imageDir, '$baseName@2x$extension');
        _has2xImage = File(image2xPath).existsSync();

        // 检查3倍图
        String image3xPath = path.join(imageDir, '$baseName@3x$extension');
        _has3xImage = File(image3xPath).existsSync();

        // 获取图片分辨率
        final bytes = await imageFile.readAsBytes();
        final codec = await ui.instantiateImageCodec(bytes);
        final frameInfo = await codec.getNextFrame();
        final image = frameInfo.image;
        
        setState(() {
          _imageWidth = image.width;
          _imageHeight = image.height;
        });
      }
    } catch (e) {
      print('${localizations.checkImageInfoError}: $e');
      setState(() {
        _imageWidth = 0;
        _imageHeight = 0;
      });
    }
  }

  String _toCamelCase(String fileName) {
    String nameWithoutExtension = path.basenameWithoutExtension(fileName);
    List<String> parts = nameWithoutExtension.split(RegExp(r'[_\-\s]+'));
    if (parts.isEmpty) return 'image';
    
    String result = parts[0].toLowerCase();
    for (int i = 1; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        result += parts[i][0].toUpperCase() + parts[i].substring(1).toLowerCase();
      }
    }
    return result;
  }

  Future<void> _addToProject() async {
    final localizations = AppLocalizations.of(context)!;
    
    if (_workspaceDirectory == null) {
      _showMessage(localizations.pleaseSelectWorkspace);
      return;
    }

    if (_selectedImagePath == null) {
      _showMessage(localizations.pleaseSelectImage);
      return;
    }

    if (_newImageName.isEmpty) {
      _showMessage(localizations.pleaseEnterImageName);
      return;
    }

    try {
      await _copyImages();
      await _updatePubspecYaml();
      await _updateImgRClass();
      _showMessage(localizations.imageAddedSuccessfully);
      _clearSelection();
    } catch (e) {
      _showMessage('${localizations.addFailed}: $e');
    }
  }

  Future<void> _copyImages() async {
    String assetsPath = path.join(_workspaceDirectory!, _assetsDirectory);
    
    // 创建目录
    Directory(assetsPath).createSync(recursive: true);
    Directory(path.join(assetsPath, '2.0x')).createSync(recursive: true);
    Directory(path.join(assetsPath, '3.0x')).createSync(recursive: true);

    File sourceFile = File(_selectedImagePath!);
    
    if (_enableResize && _targetWidth > 0 && _targetHeight > 0) {
      // 使用缩放功能
      await _resizeAndSaveImages(sourceFile, assetsPath);
    } else {
      // 原有的复制功能
      await _copyOriginalImages(sourceFile, assetsPath);
    }
  }

  Future<void> _resizeAndSaveImages(File sourceFile, String assetsPath) async {
    final localizations = AppLocalizations.of(context)!;
    
    // 读取原始图片
    Uint8List imageBytes = await sourceFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);
    
    if (originalImage == null) {
      throw Exception(localizations.cannotParseImageFile);
    }

    // 生成1倍图 (目标分辨率)
    img.Image resized1x = img.copyResize(originalImage, 
        width: _targetWidth, height: _targetHeight);
    
    // 生成2倍图
    img.Image resized2x = img.copyResize(originalImage, 
        width: _targetWidth * 2, height: _targetHeight * 2);
    
    // 生成3倍图
    img.Image resized3x = img.copyResize(originalImage, 
        width: _targetWidth * 3, height: _targetHeight * 3);

    // 获取文件扩展名
    String extension = path.extension(_newImageName).toLowerCase();
    
    // 保存1倍图
    File target1xFile = File(path.join(assetsPath, _newImageName));
    await _saveImageWithFormat(resized1x, target1xFile, extension);
    
    // 保存2倍图
    File target2xFile = File(path.join(assetsPath, '2.0x', _newImageName));
    await _saveImageWithFormat(resized2x, target2xFile, extension);
    
    // 保存3倍图
    File target3xFile = File(path.join(assetsPath, '3.0x', _newImageName));
    await _saveImageWithFormat(resized3x, target3xFile, extension);
    
    // 更新状态，表示已生成多倍图
    setState(() {
      _has2xImage = true;
      _has3xImage = true;
    });
  }

  Future<void> _saveImageWithFormat(img.Image image, File targetFile, String extension) async {
    Uint8List bytes;
    
    switch (extension) {
      case '.png':
        bytes = Uint8List.fromList(img.encodePng(image));
        break;
      case '.jpg':
      case '.jpeg':
        bytes = Uint8List.fromList(img.encodeJpg(image, quality: 90));
        break;
      default:
        // 默认使用PNG格式
        bytes = Uint8List.fromList(img.encodePng(image));
        break;
    }
    
    await targetFile.writeAsBytes(bytes);
  }

  Future<void> _copyOriginalImages(File sourceFile, String assetsPath) async {
    // 复制主图
    File targetFile = File(path.join(assetsPath, _newImageName));
    await sourceFile.copy(targetFile.path);

    // 复制2倍图
    if (_has2xImage) {
      String sourceDir = path.dirname(_selectedImagePath!);
      String baseName = path.basenameWithoutExtension(_selectedImagePath!);
      String extension = path.extension(_selectedImagePath!);
      String source2xPath = path.join(sourceDir, '$baseName@2x$extension');
      
      File source2xFile = File(source2xPath);
      File target2xFile = File(path.join(assetsPath, '2.0x', _newImageName));
      await source2xFile.copy(target2xFile.path);
    }

    // 复制3倍图
    if (_has3xImage) {
      String sourceDir = path.dirname(_selectedImagePath!);
      String baseName = path.basenameWithoutExtension(_selectedImagePath!);
      String extension = path.extension(_selectedImagePath!);
      String source3xPath = path.join(sourceDir, '$baseName@3x$extension');
      
      File source3xFile = File(source3xPath);
      File target3xFile = File(path.join(assetsPath, '3.0x', _newImageName));
      await source3xFile.copy(target3xFile.path);
    }
  }

  Future<void> _updatePubspecYaml() async {
    final localizations = AppLocalizations.of(context)!;
    
    String pubspecPath = path.join(_workspaceDirectory!, 'pubspec.yaml');
    File pubspecFile = File(pubspecPath);
    
    if (!pubspecFile.existsSync()) {
      throw Exception('pubspec.yaml文件不存在');
    }

    String content = await pubspecFile.readAsString();
    List<String> lines = content.split('\n');
    
    // 查找assets节点
    int assetsIndex = -1;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim() == 'assets:') {
        assetsIndex = i;
        break;
      }
    }

    String assetPath = '${_assetsDirectory}$_newImageName';
    String asset2xPath = '${_assetsDirectory}2.0x/$_newImageName';
    String asset3xPath = '${_assetsDirectory}3.0x/$_newImageName';

    bool skip = false;
    bool skip2x = false;
    bool skip3x = false;
    // 检查是否已存在
    if (content.contains('- $assetPath')) {
      // 显示确认对话框
      bool? overwrite = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(localizations.assetOverwriteTitle),
            content: Text(localizations.assetOverwriteMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // 取消
                },
                child: Text(localizations.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // 覆盖
                },
                child: Text(localizations.overwrite),
              ),
            ],
          );
        },
      );
      
      // 如果用户选择取消，则抛出异常
      if (overwrite != true) {
        throw Exception('${localizations.imageAlreadyExists}: $assetPath');
      }
      // 否则继续执行，覆盖现有资源
      skip = true;

      skip2x = content.contains('- $asset2xPath');
      skip3x = content.contains('- $asset3xPath');
    }

    if (assetsIndex == -1) {
      // 没有assets节点，需要添加
      int flutterIndex = -1;
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].trim() == 'flutter:') {
          flutterIndex = i;
          break;
        }
      }
      
      if (flutterIndex == -1) {
        throw Exception(localizations.flutterNodeNotFound);
      }

      // 在flutter节点下添加assets
      lines.insert(flutterIndex + 2, '  assets:');

      // 已存在不写入
      if (!skip) {
        lines.insert(flutterIndex + 3, '    - $assetPath');
      }

      if (_has2xImage && !skip2x) {
        lines.insert(flutterIndex + 4, '    - $asset2xPath');
      }
      if (_has3xImage && !skip3x) {
        lines.insert(flutterIndex + (_has2xImage ? 5 : 4), '    - $asset3xPath');
      }
    } else {
      // 已有assets节点，添加到末尾
      int insertIndex = assetsIndex + 1;
      while (insertIndex < lines.length && 
             (lines[insertIndex].startsWith('    -') || lines[insertIndex].trim().isEmpty)) {
        insertIndex++;
      }

      if (!skip) {
        lines.insert(insertIndex, '    - $assetPath');
      }

      if (_has2xImage && !skip2x) {
        lines.insert(insertIndex + 1, '    - $asset2xPath');
      }
      if (_has3xImage && !skip3x) {
        lines.insert(insertIndex + (_has2xImage ? 2 : 1), '    - $asset3xPath');
      }
    }

    await pubspecFile.writeAsString(lines.join('\n'));
  }

  Future<void> _updateImgRClass() async {
    final localizations = AppLocalizations.of(context)!;
    
    String classFilePath;
    
    if (_selectedClassPath != null) {
      classFilePath = _selectedClassPath!;
    } else {
      // 默认路径
      classFilePath = path.join(_workspaceDirectory!, 'lib', 'img_r.dart');
    }
    
    File classFile = File(classFilePath);
    
    String variableName = _toCamelCase(_newImageName);
    String assetPath = '${_assetsDirectory}$_newImageName';
    
    if (!classFile.existsSync()) {
      // 创建新文件
      String className = _selectedClassName.isNotEmpty ? _selectedClassName : 'ImgR';
      String content = '''class $className {
  static const String $variableName = '$assetPath';
}
''';
      await classFile.writeAsString(content);
    } else {
      // 更新现有文件
      String content = await classFile.readAsString();
      
      // 检查是否已存在该变量
      if (content.contains('static const String $variableName')) {
        return;
      }
      
      // 在类的最后一个}前添加新的静态变量
      int lastBraceIndex = content.lastIndexOf('}');
      if (lastBraceIndex == -1) {
        throw Exception('${path.basename(classFilePath)}${localizations.fileFormatIncorrect}');
      }
      
      String newVariable = '  static const String $variableName = \'$assetPath\';\n';
      content = content.substring(0, lastBraceIndex) + newVariable + content.substring(lastBraceIndex);
      
      await classFile.writeAsString(content);
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedImagePath = null;
      _selectedImageName = null;
      _imageBytes = null;
      _newImageName = '';
      _imageNameController.clear();
      _has2xImage = false;
      _has3xImage = false;
      _imageWidth = 0;
      _imageHeight = 0;
      _enableResize = false;
      _targetWidth = 0;
      _targetHeight = 0;
    });
    _targetWidthController.clear();
    _targetHeightController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // 加载保存的设置
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 加载最近使用的工作目录
    _recentWorkspaces = prefs.getStringList('recent_workspaces') ?? [];
    
    // 如果有选定的工作目录，加载该项目的配置
    if (_workspaceDirectory != null) {
      String projectKey = _workspaceDirectory!.replaceAll(RegExp(r'[^\w]'), '_');
      _assetsDirectory = prefs.getString('${projectKey}_assets_directory') ?? 'assets/images/';
      _selectedClassPath = prefs.getString('${projectKey}_class_path');
      _selectedClassName = prefs.getString('${projectKey}_class_name') ?? '';
      
      // 更新UI控制器
      _assetsDirController.text = _assetsDirectory;
      _classController.text = _selectedClassName;
    }
    
    setState(() {});
  }

  // 保存设置
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 保存最近使用的工作目录
    await prefs.setStringList('recent_workspaces', _recentWorkspaces);
    
    // 如果有选定的工作目录，保存该项目的配置
    if (_workspaceDirectory != null) {
      String projectKey = _workspaceDirectory!.replaceAll(RegExp(r'[^\w]'), '_');
      await prefs.setString('${projectKey}_assets_directory', _assetsDirectory);
      if (_selectedClassPath != null) {
        await prefs.setString('${projectKey}_class_path', _selectedClassPath!);
      }
      await prefs.setString('${projectKey}_class_name', _selectedClassName);
    }
  }

  // 选择最近使用的工作目录
  Future<void> _selectRecentWorkspace(String workspace) async {
    setState(() {
      _workspaceDirectory = workspace;
      
      // 将选中的工作目录移到列表开头
      _recentWorkspaces.remove(workspace);
      _recentWorkspaces.insert(0, workspace);
    });
    
    // 加载该项目的配置
    await _loadSettings();
    await _saveSettings();
  }

  // 选择资源类文件
  Future<void> _selectClassFile() async {
    final localizations = AppLocalizations.of(context)!;
    
    if (_workspaceDirectory == null) {
      _showMessage(localizations.pleaseSelectWorkspaceFirst);
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['dart'],
      initialDirectory: path.join(_workspaceDirectory!, 'lib'),
    );

    if (result != null) {
      String filePath = result.files.first.path!;
      String fileName = path.basenameWithoutExtension(filePath);
      
      // 尝试从文件中提取类名
      try {
        File file = File(filePath);
        String content = await file.readAsString();
        
        // 使用正则表达式查找类名
        RegExp classRegex = RegExp(r'class\s+(\w+)\s*{');
        Match? match = classRegex.firstMatch(content);
        
        if (match != null) {
          String className = match.group(1)!;
          setState(() {
            _selectedClassPath = filePath;
            _selectedClassName = className;
            _classController.text = className;
          });
          await _saveSettings();
          _showMessage('${localizations.selectedResourceClass}: $className');
        } else {
          _showMessage(localizations.cannotFindClassDefinition);
        }
      } catch (e) {
        _showMessage('${localizations.readFileFailed}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 选择工作目录
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.workspaceDirectory, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _workspaceDirectory ?? localizations.noWorkspaceSelected,
                            style: TextStyle(
                              color: _workspaceDirectory != null ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _selectWorkspaceDirectory,
                          child: Text(localizations.selectWorkspaceDirectory),
                        ),
                      ],
                    ),
                    
                    // 显示最近使用的工作目录
                    if (_recentWorkspaces.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(localizations.recentlyUsed, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _recentWorkspaces.map((workspace) {
                          return ActionChip(
                            label: Text(
                              path.basename(workspace),
                              style: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () => _selectRecentWorkspace(workspace),
                            backgroundColor: _workspaceDirectory == workspace 
                                ? Theme.of(context).primaryColor.withOpacity(0.2)
                                : null,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 图片存放目录
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.imageStorageDirectory, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _assetsDirController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: localizations.imageStorageDirectoryHint,
                      ),
                      onChanged: (value) {
                        _assetsDirectory = value;
                        _saveSettings();
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 选择图片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(localizations.selectImage, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _selectImage,
                          child: Text(localizations.pickImage),
                        ),
                      ],
                    ),
                    
                    if (_selectedImagePath != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 图片预览
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_selectedImagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // 图片信息
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${localizations.originalFileName}: $_selectedImageName'),
                                if (_imageWidth > 0 && _imageHeight > 0)
                                  Text('${localizations.resolution}: ${_imageWidth} × ${_imageHeight}'),
                                Text('${localizations.filePath}: $_selectedImagePath'),
                                Row(
                                  children: [
                                    Text('${localizations.image2x}: ${_has2xImage ? "✓" : "✗"}'),
                                    const SizedBox(width: 20),
                                    Text('${localizations.image3x}: ${_has3xImage ? "✓" : "✗"}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 图片重命名和类选择
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.importSettings, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: _imageNameController,
                      decoration: InputDecoration(
                        labelText: localizations.imageName,
                        border: const OutlineInputBorder(),
                        hintText: localizations.imageNameHint,
                      ),
                      onChanged: (value) {
                        _newImageName = value;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 图片缩放功能
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _enableResize,
                                onChanged: (value) {
                                  setState(() {
                                    _enableResize = value ?? false;
                                  });
                                },
                              ),
                              Text('${localizations.enableImageResize} (${localizations.autoGenerateInfo})'),
                            ],
                          ),
                          
                          if (_enableResize) ...[
                            const SizedBox(height: 12),
                            Text(localizations.targetResolution, style: const TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _targetWidthController,
                                    decoration: InputDecoration(
                                      labelText: localizations.width,
                                      border: const OutlineInputBorder(),
                                      hintText: localizations.widthHint,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _targetWidth = int.tryParse(value) ?? 0;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('×'),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _targetHeightController,
                                    decoration: InputDecoration(
                                      labelText: localizations.height,
                                      border: const OutlineInputBorder(),
                                      hintText: localizations.heightHint,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _targetHeight = int.tryParse(value) ?? 0;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _classController,
                            decoration: InputDecoration(
                              labelText: localizations.resourceClassName,
                              border: const OutlineInputBorder(),
                              hintText: localizations.resourceClassNameHint,
                            ),
                            onChanged: (value) {
                              _selectedClassName = value;
                              _saveSettings();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _selectClassFile,
                          child: Text(localizations.selectFile),
                        ),
                      ],
                    ),
                    
                    if (_selectedClassPath != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${localizations.filePath}: ${path.relative(_selectedClassPath!, from: _workspaceDirectory ?? '')}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 添加到工程按钮
            Center(
              child: ElevatedButton(
                onPressed: (_workspaceDirectory != null && 
                           _selectedImagePath != null && 
                           _newImageName.isNotEmpty) 
                    ? _addToProject 
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text(localizations.addToProject, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
