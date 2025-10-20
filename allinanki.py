import sys
import tempfile
import os
from os import path


def main():
    log_path = path.join(tempfile.gettempdir(), "allinanki.log")
    with open(log_path, "w") as sys.stdout:
        sys.stderr = sys.stdout

        print("All in Anki by voczi (https://github.com/voczi/allinanki)")

        if os.name == "nt":
            # Environment variable for taskbar grouping on Windows
            os.environ["ANKI_LAUNCHER"] = path.abspath(
                path.join(sys._MEIPASS, "../Anki.exe")
            )

        import aqt

        aqt.run()


if __name__ == "__main__":
    main()
