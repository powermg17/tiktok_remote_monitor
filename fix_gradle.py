import os
for root, dirs, files in os.walk("."):
    if "build.gradle" in files and "app" in root:
        path = os.path.join(root, "build.gradle")
        with open(path, "r") as f:
            content = f.read()
        if "kotlinOptions" not in content and "android {" in content:
            new_content = content.replace("android {", "android {\n    kotlinOptions {\n        languageVersion = \"2.0\"\n    }")
            with open(path, "w") as f:
                f.write(new_content)
            print(f"Updated: {path}")
