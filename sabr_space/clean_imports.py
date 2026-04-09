import os
import re

lib_dir = "lib"

for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith(".dart"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                lines = f.readlines()

            original_lines = list(lines)
            
            # Remove any line that contains '$1' in an import statement
            new_lines = []
            for line in lines:
                if line.startswith("import") and "$1" in line:
                    continue
                new_lines.append(line)

            if new_lines != original_lines:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.writelines(new_lines)
                print(f"Cleaned: {file_path}")
