import os
import re

lib_dir = "lib"

KNOWN_IMPORTS = {
    "AppColors": "import 'package:sabr_space/core/theme/app_colors.dart';",
    "AppTypography": "import 'package:sabr_space/core/theme/app_typography.dart';",
    "AppGradients": "import 'package:sabr_space/core/theme/app_gradients.dart';",
    "AppSpacing": "import 'package:sabr_space/core/constants/app_spacing.dart';",
    "AppStrings": "import 'package:sabr_space/core/constants/app_strings.dart';",
    "GradientButton": "import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';",
    "AuthTextField": "import 'package:sabr_space/features/intro/presentation/widgets/auth_text_field.dart';",
    "AuthTabToggle": "import 'package:sabr_space/features/intro/presentation/widgets/auth_tab_toggle.dart';",
    "SocialLoginButton": "import 'package:sabr_space/features/intro/presentation/widgets/social_login_button.dart';",
    "SanctuaryLogo": "import 'package:sabr_space/features/intro/presentation/widgets/sanctuary_logo.dart';",
}

SCREEN_IMPORTS = [
    "import 'package:sabr_space/features/intro/presentation/screens/intro_screen/intro_screen.dart';",
    "import 'package:sabr_space/features/intro/presentation/screens/login_screen/login_screen.dart';",
    "import 'package:sabr_space/features/intro/presentation/screens/signup_screen/signup_screen.dart';",
    "import 'package:sabr_space/features/home/presentation/screens/home_screen/home_screen.dart';",
    "import 'package:sabr_space/features/home/presentation/screens/mood_check_screen/mood_check_screen.dart';",
    "import 'package:sabr_space/features/sanctuary/presentation/screens/ayah_carousel_screen/ayah_carousel_screen.dart';",
    "import 'package:sabr_space/features/sanctuary/presentation/screens/supportive_ayah_screen/supportive_ayah_screen.dart';",
    "import 'package:sabr_space/features/sanctuary/presentation/screens/breathe_session_screen/breathe_session_screen.dart';",
    "import 'package:sabr_space/features/sanctuary/presentation/screens/breathe_completion_screen/breathe_completion_screen.dart';",
    "import 'package:sabr_space/features/sanctuary/presentation/screens/breathe_minimal_screen/breathe_minimal_screen.dart';",
    "import 'package:sabr_space/features/sanctuary/presentation/screens/grief_writing_screen/grief_writing_screen.dart';",
    "import 'package:sabr_space/features/sanctuary/presentation/screens/grief_burn_screen/grief_burn_screen.dart';",
    "import 'package:sabr_space/features/sanctuary/presentation/screens/grief_completion_screen/grief_completion_screen.dart';",
    "import 'package:sabr_space/features/sanctuary/presentation/screens/milestone_screen/milestone_screen.dart';",
    "import 'package:sabr_space/features/sanctuary/presentation/screens/mindfulness_screen/mindfulness_screen.dart';",
    "import 'package:sabr_space/features/profile/presentation/screens/profile_screen/profile_screen.dart';",
    "import 'package:sabr_space/features/profile/presentation/screens/support_options_screen/support_options_screen.dart';",
    "import 'package:sabr_space/features/profile/presentation/screens/premium_screen/premium_screen.dart';",
]

for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith(".dart"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()

            original_content = content
            imports_to_add = set()

            for class_name, import_stmt in KNOWN_IMPORTS.items():
                # check if class is used (simple word match)
                if re.search(r'\b' + class_name + r'\b', content) and import_stmt not in content:
                    # don't import into itself
                    base_name = os.path.splitext(file)[0]
                    class_snake = re.sub(r'(?<!^)(?=[A-Z])', '_', class_name).lower()
                    if base_name != class_snake:
                        imports_to_add.add(import_stmt)

            if file == "app_router.dart":
                for stmt in SCREEN_IMPORTS:
                    if stmt not in content:
                        imports_to_add.add(stmt)

            if imports_to_add:
                # Add imports right after the last import statement, or at the top if none
                lines = content.split('\n')
                last_import_idx = -1
                for i, line in enumerate(lines):
                    if line.startswith("import "):
                        last_import_idx = i

                sorted_imports = sorted(list(imports_to_add))
                
                if last_import_idx != -1:
                    lines = lines[:last_import_idx+1] + sorted_imports + lines[last_import_idx+1:]
                else:
                    lines = sorted_imports + lines

                content = '\n'.join(lines)
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(content)
                print(f"Added imports to: {file_path}")
