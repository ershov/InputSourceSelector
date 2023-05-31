#!/usr/bin/swift

// A rewrite of https://github.com/minoki/InputSourceSelector

import Foundation
import Carbon

let argc = CommandLine.argc
let argv = CommandLine.arguments

func printInputSourceName(_ inputSource: TISInputSource, allLangs: Bool = false) {
    let inputSourceID = Unmanaged<AnyObject>.fromOpaque(TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID)).takeUnretainedValue()
    let localizedName = Unmanaged<AnyObject>.fromOpaque(TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName)).takeUnretainedValue()
    let sourceLanguages = Unmanaged<AnyObject>.fromOpaque(TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceLanguages)).takeUnretainedValue() as? NSArray as? [String] ?? ["?"]
    if allLangs {
        print("\(inputSourceID) (\(localizedName)) \(sourceLanguages)")
    } else {
        let lang = sourceLanguages[0]
        print("\(inputSourceID) (\(localizedName)) [\(lang)]")
    }
}

if argc > 1 && (argv[1] == "list" || argv[1] == "list-all-langs" || argv[1] == "list-enabled" || argv[1] == "list-enabled-all-langs") {
    let listAll = !argv[1].hasPrefix("list-enabled")
    let inputSources = TISCreateInputSourceList(nil, listAll).takeUnretainedValue() as NSArray as! [TISInputSource]
    for inputSource in inputSources {
        printInputSourceName(inputSource, allLangs: argv[1].hasSuffix("-all-langs"))
    }
} else if argc > 1 && (argv[1] == "current" || argv[1] == "current-layout" || argv[1] == "current-all-langs" || argv[1] == "current-layout-all-langs") {
    let inputSourceUnmanaged = argv[1].hasPrefix("current-layout") ? TISCopyCurrentKeyboardLayoutInputSource() : TISCopyCurrentKeyboardInputSource()
    let inputSource = inputSourceUnmanaged!.takeRetainedValue()
    printInputSourceName(inputSource, allLangs: argv[1].hasSuffix("-all-langs"))
} else if argc > 2 && (argv[1] == "enable" || argv[1] == "disable" || argv[1] == "select" || argv[1] == "deselect" || argv[1] == "test-id") {
    let inputSourceID = argv[2]
    let properties = [kTISPropertyInputSourceID as String: inputSourceID]
    //let inputSources = TISCreateInputSourceList(properties as CFDictionary, true) as! [TISInputSource]
    let inputSources = TISCreateInputSourceList(properties as CFDictionary, true)?.takeUnretainedValue() as? NSArray as? [TISInputSource] ?? []
    if inputSources.count == 0 {
        fputs("\(argv[2]) : bad input source ID. Use 'list' or 'list-enabled' to get some valid ones.\n", stderr)
        exit(1)
    }
    let inputSource = inputSources[0]
    if argv[1] == "enable" {
        TISEnableInputSource(inputSource)
    } else if argv[1] == "disable" {
        TISDisableInputSource(inputSource)
    } else if argv[1] == "select" {
        TISSelectInputSource(inputSource)
    } else if argv[1] == "deselect" {
        TISDeselectInputSource(inputSource)
    } else if argv[1] == "test-id" {
        print("\(inputSourceID) : ok")
    }
} else {
    let usage = """
    Usage:
       \(argv[0]) [command]

    Available commands:
       list[-all-langs]            Lists currently installed input sources.
       list-enabled[-all-langs]    Lists currently enabled input sources.
       current[-all-langs]         Prints currently selected input source.
       current-layout[-all-langs]  Prints currently used keyboard layout.
       enable {input source ID}    Enables specified input source.
       disable {input source ID}   Disables specified input source.
       select {input source ID}    Selects specified input source.
       deselect {input source ID}  Deselects specified input source.
       test-id {input source ID}   Tests input source ID for correctness.

    -all-langs suffix lists all supported languages, not just the first one.


    """
    fputs(usage, stderr)
}

exit(0)
