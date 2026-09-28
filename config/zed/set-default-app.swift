// Make Zed the Finder/`open` default for each file extension passed as an argument.
// Called by ide.sh. Uses NSWorkspace, so it needs no duti or other install;
// `swift` ships with the Xcode Command Line Tools that Homebrew already requires.
// Usage: swift set-default-app.swift py ts json ...
import AppKit
import UniformTypeIdentifiers

let zed = URL(fileURLWithPath: "/Applications/Zed.app")
var failed = 0
let group = DispatchGroup()

for ext in CommandLine.arguments.dropFirst() {
  guard let type = UTType(filenameExtension: ext) else {
    print("  \(ext): no type"); failed += 1; continue
  }
  group.enter()
  NSWorkspace.shared.setDefaultApplication(at: zed, toOpen: type) { err in
    if let err { print("  \(ext): \(err.localizedDescription)"); failed += 1 }
    group.leave()
  }
}

group.wait()
exit(failed == 0 ? 0 : 1)
