// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Flutter Assets Tool';

  @override
  String get workspaceDirectory => '工作目录:';

  @override
  String get noWorkspaceSelected => '未选择工作目录';

  @override
  String get selectWorkspaceDirectory => '选择工作目录';

  @override
  String get recentlyUsed => '最近使用:';

  @override
  String get imageStorageDirectory => '图片存放目录:';

  @override
  String get imageStorageDirectoryHint => 'assets/images/';

  @override
  String get selectImage => '选择图片:';

  @override
  String get pickImage => '挑选图片';

  @override
  String get originalFileName => '原始文件名';

  @override
  String get resolution => '分辨率';

  @override
  String get filePath => '文件路径';

  @override
  String get image2x => '2倍图';

  @override
  String get image3x => '3倍图';

  @override
  String get importSettings => '导入设置:';

  @override
  String get imageName => '图片名称';

  @override
  String get imageNameHint => '例如: img_icon.png';

  @override
  String get enableImageResize => '启用图片缩放功能';

  @override
  String get targetResolution => '目标分辨率:';

  @override
  String get width => '宽度';

  @override
  String get height => '高度';

  @override
  String get widthHint => '40';

  @override
  String get heightHint => '40';

  @override
  String get autoGenerateInfo => '将自动生成: 2倍图, 3倍图';

  @override
  String get resourceClassName => '资源类名';

  @override
  String get resourceClassNameHint => '例如: ImgR';

  @override
  String get selectFile => '选择文件';

  @override
  String get addToProject => '添加到工程';

  @override
  String get success => '成功';

  @override
  String get error => '错误';

  @override
  String get imageAddedSuccessfully => '图片已成功添加到工程！';

  @override
  String get pleaseSelectWorkspace => '请先选择工作目录';

  @override
  String get pleaseSelectImage => '请先选择图片';

  @override
  String get pleaseEnterImageName => '请输入图片名称';

  @override
  String get addFailed => '添加失败';

  @override
  String get checkImageInfoError => '检查图片信息时出错';

  @override
  String get cannotParseImageFile => '无法解析图片文件';

  @override
  String get imageAlreadyExists => '图片已存在于pubspec.yaml中';

  @override
  String get flutterNodeNotFound => '找不到flutter节点';

  @override
  String get variableAlreadyExists => '变量已存在于文件中';

  @override
  String get selectedResourceClass => '已选择资源类';

  @override
  String get cannotFindClassDefinition => '无法从文件中找到类定义';

  @override
  String get readFileFailed => '读取文件失败';

  @override
  String get pleaseSelectWorkspaceFirst => '请先选择工作目录';

  @override
  String get inFile => '已存在于';

  @override
  String get inFileEnd => '中';

  @override
  String get fileFormatIncorrect => '文件格式不正确';
}
