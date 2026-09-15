import AVFoundation
import XCTest
@testable import qr_code_scanner_plus

final class CameraSelectionTests: XCTestCase {
    func testBackCameraPrefersMacroCapableVirtualDevices() {
        let actual = NativeBarcodeScanner.preferredDeviceTypes(for: .back)

        XCTAssertEqual(
            actual.map(\.rawValue),
            [
                AVCaptureDevice.DeviceType.builtInTripleCamera,
                .builtInDualWideCamera,
                .builtInWideAngleCamera
            ].map(\.rawValue)
        )
    }

    func testFrontCameraUsesWideAngleDevice() {
        let actual = NativeBarcodeScanner.preferredDeviceTypes(for: .front)

        XCTAssertEqual(
            actual.map(\.rawValue),
            [AVCaptureDevice.DeviceType.builtInWideAngleCamera.rawValue]
        )
    }

    func testVirtualWideAndUltraWideDevicesStartAtWideAngleZoom() {
        let switchOverFactors = [NSNumber(value: 2.0), NSNumber(value: 6.0)]

        for deviceType in [
            AVCaptureDevice.DeviceType.builtInTripleCamera,
            .builtInDualWideCamera
        ] {
            XCTAssertEqual(
                NativeBarcodeScanner.initialZoomFactorForAutomaticCameraSwitching(
                    deviceType: deviceType,
                    switchOverFactors: switchOverFactors
                ),
                2.0
            )
        }
    }

    func testPhysicalCameraKeepsDefaultZoom() {
        XCTAssertNil(
            NativeBarcodeScanner.initialZoomFactorForAutomaticCameraSwitching(
                deviceType: .builtInWideAngleCamera,
                switchOverFactors: [NSNumber(value: 2.0)]
            )
        )
    }

    func testVirtualCameraWithoutSwitchOverFactorKeepsDefaultZoom() {
        XCTAssertNil(
            NativeBarcodeScanner.initialZoomFactorForAutomaticCameraSwitching(
                deviceType: .builtInTripleCamera,
                switchOverFactors: []
            )
        )
    }
}
