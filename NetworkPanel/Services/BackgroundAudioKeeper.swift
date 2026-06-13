import AVFoundation
import Foundation

@MainActor
final class BackgroundAudioKeeper {
    static let shared = BackgroundAudioKeeper()

    private let engine = AVAudioEngine()
    private var isPrepared = false

    private init() {}

    func start() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
            prepareEngineIfNeeded()
            if !engine.isRunning {
                try engine.start()
            }
        } catch {
            stop()
        }
    }

    func stop() {
        engine.stop()
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
        } catch {}
    }

    private func prepareEngineIfNeeded() {
        guard !isPrepared else { return }
        let source = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let buffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for buffer in buffers {
                guard let data = buffer.mData else { continue }
                memset(data, 0, Int(buffer.mDataByteSize))
            }
            return noErr
        }
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 2)!
        engine.attach(source)
        engine.connect(source, to: engine.mainMixerNode, format: format)
        isPrepared = true
    }
}
