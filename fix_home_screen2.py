with open(r"D:\Braj mandel\app\lib\features\home\home_screen.dart", "r", encoding="utf-8", errors="replace") as f:
    content = f.read()

# Fix 1: Fix context.push in _buildNearbyTemplesSection (line 723)
content = content.replace("context.push(\'/temple/\')", "context.push(\'/temple/${temple.id}\')")

# Fix 2: Fix the extra ); at line 819
# The structure has an extra closing - need to look at the exact pattern
# The issue is likely that the Material and InkWell are not properly closed
# Let me check the exact content around line 819

# Fix 3: Reformat the compressed FeaturedTemplesCarousel build method (line 977)
# This is very complex, let me replace the entire build method

# Fix 4: Reformat the compressed TopDestinationsSection build method (line 988)

with open(r"D:\Braj mandel\app\lib\features\home\home_screen.dart", "w", encoding="utf-8") as f:
    f.write(content)

print("Fixed basic issues")
