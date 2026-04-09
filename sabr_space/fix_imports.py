import os
import re

lib_dir = "lib"

for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith(".dart"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()

            original_content = content
            
            # Replace relative core/ and features/ imports with absolute package imports
            content = re.sub(r"import\s+['\"](?:\.\./)+core/(.*?)['\"];", r"import 'package:sabr_space/core/\1';", content)
            content = re.sub(r"import\s+['\"](?:\.\./)+features/(.*?)['\"];", r"import 'package:sabr_space/features/\1';", content)
            
            # Also occasionally there's `import '../../../../../core/...` etc depending on nesting depth. The `(?:\.\./)+` matches 1 or more `../`

            # Specifically for intro screens: they incorrectly import widgets via `../widgets/`
            if "features" in root and "intro" in root:
                content = re.sub(r"import\s+['\"]\.\./widgets/(.*?)['\"];", r"import 'package:sabr_space/features/intro/presentation/widgets/\1';", content)
                content = re.sub(r"import\s+['\"]\.\./\.\./\.\./intro/presentation/widgets/(.*?)['\"];", r"import 'package:sabr_space/features/intro/presentation/widgets/\1';", content)

            if content != original_content:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(content)
                print(f"Fixed: {file_path}")
