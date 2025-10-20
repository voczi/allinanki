import os
import subprocess
import importlib.util


def main():
    aqt_dir = os.path.dirname(importlib.util.find_spec("aqt").origin)
    modules = ["about", "utils"]
    for module in modules:
        subprocess.check_output(
            [
                "git",
                "apply",
                "--ignore-whitespace",
                "--whitespace",
                "fix",
                "--unsafe-paths",
                "--directory",
                aqt_dir,
                f"./patches/{module}.py.diff",
            ]
        )
        print(f"Successfully patched module `{module}`!")


if __name__ == "__main__":
    main()
