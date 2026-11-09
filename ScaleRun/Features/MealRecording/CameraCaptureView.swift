import SwiftUI
import AVFoundation

/// 相机拍摄视图
struct CameraCaptureView: View {
    let onCapture: (UIImage) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var cameraSession = CameraSession()
    @State private var capturedImage: UIImage?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let image = capturedImage {
                // 预览已拍摄照片
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    HStack {
                        Button("重拍") {
                            capturedImage = nil
                            cameraSession.start()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.black.opacity(0.6)))

                        Spacer()

                        Button("使用照片") {
                            onCapture(image)
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.brandPrimary))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            } else {
                // 相机预览
                CameraPreview(session: cameraSession.session)
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    // 拍摄按钮
                    Button {
                        if let image = cameraSession.capturePhoto() {
                            capturedImage = image
                        }
                    } label: {
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .frame(width: 72, height: 72)
                            .overlay {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 58, height: 58)
                            }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            cameraSession.start()
        }
        .onDisappear {
            cameraSession.stop()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(Circle().fill(Color.black.opacity(0.4)))
                }
            }
        }
    }
}

/// 相机预览层
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        DispatchQueue.main.async {
            previewLayer.frame = view.bounds
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.frame = uiView.bounds
        }
    }
}

/// 相机会话管理
class CameraSession: ObservableObject {
    let session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()

    init() {
        session.sessionPreset = .photo
        setupCamera()
    }

    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
    }

    func start() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }

    func stop() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }
    }

    func capturePhoto() -> UIImage? {
        let settings = AVCapturePhotoSettings()
        var capturedImage: UIImage?
        let semaphore = DispatchSemaphore(value: 0)

        photoOutput.capturePhoto(with: settings, delegate: PhotoCaptureDelegate { image in
            capturedImage = image
            semaphore.signal()
        })

        semaphore.wait()
        return capturedImage
    }
}

/// 照片捕获代理
class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    let completionHandler: (UIImage?) -> Void

    init(completion: @escaping (UIImage?) -> Void) {
        self.completionHandler = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            completionHandler(nil)
            return
        }
        completionHandler(image)
    }
}
