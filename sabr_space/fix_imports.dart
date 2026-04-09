import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    var content = file.readAsStringSync();
    var originalContent = content;

    content = content.replaceAll(RegExp(r"import\s+'(?:\.\./)+core/([^']+)'"), "import 'package:sabr_space/core/\$1'");
    content = content.replaceAll(RegExp(r"import\s+'(?:\.\./)+features/([^']+)'"), "import 'package:sabr_space/features/\$1'");
    
    // Fix intro widgets imports
    if (file.path.contains('intro')) {
      content = content.replaceAll(RegExp(r"import\s+'\.\./widgets/([^']+)'"), "import 'package:sabr_space/features/intro/presentation/widgets/\$1'");
      content = content.replaceAll(RegExp(r"import\s+'\.\.\/\.\.\/\.\.\/intro/presentation/widgets/([^']+)'"), "import 'package:sabr_space/features/intro/presentation/widgets/\$1'");
    }

    if (content != originalContent) {
      file.writeAsStringSync(content);
      stdout.writeln('Fixed: ${file.path}');
    }
  }
}
