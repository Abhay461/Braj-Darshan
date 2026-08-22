with open(r"D:\Braj mandel\app\lib\features\home\home_screen.dart", "r", encoding="utf-8", errors="replace") as f:
    content = f.read()

# Fix 1: Add semicolons to imports
content = content.replace("import 'widgets/emergency_quick_action.dart'\n", "import 'widgets/emergency_quick_action.dart';\n")
content = content.replace("import 'widgets/daily_krishna_vani.dart'\n", "import 'widgets/daily_krishna_vani.dart';\n")
content = content.replace("import 'widgets/quick_actions_section.dart'\n", "import 'widgets/quick_actions_section.dart';\n")

# Fix 2: Fix string interpolation in context.push calls
content = content.replace("context.push('/temple/\\')", "context.push('/temple/${temple.id}')")

# Fix 3: Fix heroTag string interpolation
content = content.replace("heroTag: 'all_\\'", "heroTag: 'all_${temple.id}'")

# Fix 4: Fix _formatFestivalDateRange function
content = content.replace("return '\\ \\ - \\, \\';", "return '${months[start.month - 1]} ${start.day} - ${months[end.month - 1]} ${end.day}, ${end.year}';")
content = content.replace("return '\\ \\ - \\ \\, \\';", "return '${months[start.month - 1]} ${start.day} - ${end.day}, ${start.year}';")

# Fix 5: Fix _CategoryCard Semantics label
content = content.replace("label: 'Category: \\'", "label: 'Category: ${category.name}'")

with open(r"D:\Braj mandel\app\lib\features\home\home_screen.dart", "w", encoding="utf-8") as f:
    f.write(content)

print("Fixed home_screen.dart basic issues")
