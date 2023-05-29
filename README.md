# InputSourceSelector
A utility program to manipulate Input Sources on Mac OS X.

This is a rewrite of [minoki/InputSourceSelector](https://github.com/minoki/InputSourceSelector)
in Swift with addition of a few useful features:
testing for a layout ID and displaying the language code for the input method.

For a more robust solution that works aroung MacOs errors, check out
[laishulu/macism](https://github.com/laishulu/macism).

## Installing

```
$ git clone https://github.com/ershov/InputSourceSelector.git
$ cd InputSourceSelector
$ make
$ copy InputSourceSelector /usr/local/bin/    # or another directory in $PATH
```

## Usage

Running it without arguments prints usage information:

```
$ InputSourceSelector
Usage:
   InputSourceSelector [command]

Available commands:
   list                        Lists currently installed input sources.
   list-enabled                Lists currently enabled input sources.
   current                     Prints currently selected input source.
   current-layout              Prints currently used keyboard layout.
   enable [input source ID]    Enables specified input source.
   disable [input source ID]   Disables specified input source.
   select [input source ID]    Selects specified input source.
   deselect [input source ID]  Deselects specified input source.
   test-id [input source ID]   Tests input source ID for correctness.
```

Where `input source ID` is something like `com.apple.keylayout.US`.

## Output examples

```
$ InputSourceSelector list
com.apple.keylayout.Czech-QWERTY (Czech – QWERTY) [cs]
com.apple.keylayout.Czech (Czech) [cs]
com.apple.keylayout.Estonian (Estonian) [et]
com.apple.keylayout.Hungarian-QWERTY (Hungarian – QWERTY) [hu]
.... (270 lines skipped)
com.apple.inputmethod.SCIM.WBX (Wubi - Simplified) [zh-Hans]
com.apple.inputmethod.SCIM.WBH (Stroke - Simplified) [zh-Hans]
com.apple.inputmethod.TransliterationIM.mr (Marathi – Transliteration (A→अ)) [mr]
com.apple.inputmethod.TransliterationIM.pa (Punjabi – Transliteration (A→ਅ)) [pa]
com.apple.inputmethod.TransliterationIM.ur (Urdu – Transliteration (A→ع)) [ur]
com.apple.inputmethod.TransliterationIM.gu (Gujarati – Transliteration (A→અ)) [gu]
com.apple.inputmethod.TransliterationIM.hi (Hindi – Transliteration (A→अ)) [hi]
com.apple.inputmethod.TransliterationIM.bn (Bangla – Transliteration (A→অ)) [bn]
```

```
$ InputSourceSelector list-enabled
com.apple.CharacterPaletteIM (Emoji & Symbols) [en]
com.apple.keylayout.US (U.S.) [en]
com.apple.inputmethod.ironwood (Dictation) [en]
org.unknown.keylayout.Русская-BG46 (Русская - BG46) []
```

```
$ InputSourceSelector current
com.apple.keylayout.US (U.S.) [en]
```

```
$ InputSourceSelector current-layout
com.apple.keylayout.US (U.S.) [en]
```

```
$ InputSourceSelector select com.apple.keylayout.US   # US layout is selected
```

```
$ InputSourceSelector test-id com.apple.keylayout.US
com.apple.keylayout.US : ok
$ echo $?
0
```

```
$ InputSourceSelector test-id qwe
qwe : bad input source ID. Use 'list' or 'list-enabled' to get some valid ones.
$ echo $?
1
```
