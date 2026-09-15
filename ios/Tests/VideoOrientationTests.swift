import AVFoundation
import UIKit

// Compiled with the production scanner by run_orientation_tests.sh. No camera
// or Flutter engine is needed to verify the UIKit-to-AVFoundation conversion.
@main
enum VideoOrientationTests {
    static func main() {
        let cases: [(String, UIInterfaceOrientation, AVCaptureVideoOrientation)] = [
            ("portrait", .portrait, .portrait),
            ("portrait upside down", .portraitUpsideDown, .portraitUpsideDown),
            ("landscape left", .landscapeLeft, .landscapeLeft),
            ("landscape right", .landscapeRight, .landscapeRight),
            ("unknown falls back to portrait", .unknown, .portrait),
        ]

        var failures = 0
        for (name, interfaceOrientation, expected) in cases {
            let actual = NativeBarcodeScanner.videoOrientation(for: interfaceOrientation)
            if actual == expected {
                print("PASS: \(name)")
            } else {
                print("FAIL: \(name): expected \(expected.rawValue), got \(actual.rawValue)")
                failures += 1
            }
        }

        print("\(cases.count) orientation cases, \(failures) failures")
        exit(failures == 0 ? 0 : 1)
    }
}
