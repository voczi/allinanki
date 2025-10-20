import plistlib
import os
import sys
import PyInstaller.utils.osx as osxutils


def main():
    plist_path = "./dist/Anki.app/Contents/Info.plist"
    if not os.path.exists(plist_path):
        sys.exit("Info.plist not found")

    with open(plist_path, "rb") as plist_file:
        plist_bytes = plist_file.read()

    plist = plistlib.loads(plist_bytes)

    plist["LSApplicationCategoryType"] = "public.app-category.education"
    plist["CFBundleDocumentTypes"] = [
        {
            "CFBundleTypeExtensions": ["colpkg", "apkg", "ankiaddon"],
            "CFBundleTypeName": "Anki file",
        }
    ]

    with open(plist_path, "wb") as plist_file:
        plist_file.write(plistlib.dumps(plist))

    osxutils.sign_binary("./dist/Anki.app", deep=True)

    print("Successfully patched Info.plist")


if __name__ == "__main__":
    main()
