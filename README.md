# All in Anki

Community-driven, all-in-one distributions for the flashcard app [Anki](https://apps.ankiweb.net/).

## Purpose

After Anki [version 25.02.7](https://github.com/ankitects/anki/releases/tag/25.02.7), the app was no longer distributed through packages that contained all the dependencies necessary from the get-go. Instead, Anki's installer now downloads the dependencies by itself (primarily from [PyPI](https://pypi.org/)). This presents several issues, one of which concerns the archiveability of Anki as it is possible for packages to be deleted off PyPI. Such a thing could result in users finding themselves unable to install older versions of Anki.

With the above in mind, the purpose of this project is to distribute Anki in an all-in-one package that requires no Internet connection during the installation process. The project strives to make as few modifications to Anki itself as possible, just to the point where users can (hopefully) achieve a 1:1 experience using distributions from this project.

## Bug reports

If you encounter a bug and you believe that it is related to this project, then please [open an issue](https://github.com/voczi/anki_aio/issues/new/choose) here on this repo. However, if you also experience this issue using an [official distribution of Anki](https://apps.ankiweb.net/) then report the bug on [the Anki forums](https://forums.ankiweb.net/). In most cases, if you experience a bug before barely having seen the actual window of the Anki app, you can assume that the bug is to be reported here.

## Original authors

### Anki

Anki is a flashcard app created by [dae (Damien Elmes)](https://github.com/dae). Along with [numerous of other contributors](https://raw.githubusercontent.com/ankitects/anki/refs/heads/main/CONTRIBUTORS), dae has maintained the Anki project for a while. The All in Anki project only aims to perform minimal changes to the [original source code of Anki](https://github.com/ankitects/anki). At the time of writing this, the only changes made to the Anki's source code are performed by `patches/patch_aqt.py`. All this script does is add a line saying "All in Anki by voczi (https:\/\/github.com\/voczi\/allinanki)" to the about text and debug text of Anki. This is mostly for community volunteers to use, so that they can differentiate between bug reports for the [official distributions of Anki](https://apps.ankiweb.net/) and this distribution.

### Plain Anki icon and its derivatives

The original icon `anki.svg` was not created by me; it was sourced from [Wikimedia](https://commons.wikimedia.org/wiki/File:Anki-icon.svg) and is copyrighted by Alex Fraser.
Files `anki.png`, `anki.icns` and `anki.ico` (located inside the `resources` folder) were converted by me from the original SVG icon by using publically available tools.
The original icon, along with its derivatives found in this project, are licensed under GNU Affero General Public License version 3 (just like this project is).
