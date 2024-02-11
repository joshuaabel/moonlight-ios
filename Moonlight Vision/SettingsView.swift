//

import SwiftUI

struct SettingsView: View {
    @Binding public var settings: TemporarySettings
    
    // TODO: round trip these to the raw settings values lol
    @State public var resolutionIndex: Int = 3
    
    @State public var framerateIndex: Int = 2
    
    @State public var bitrateIndex: Int = 7
    
    @State public var customWidth: Int = 0
    @State public var customHeight: Int = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Resolution", selection: $resolutionIndex) {
                    Text("360p").tag(0)
                    Text("720p").tag(1)
                    Text("1080p").tag(2)
                    Text("4K").tag(3)
                }.onChange(of: resolutionIndex) {
                    updateResolution()
                }
                Picker("Framerate", selection: $framerateIndex) {
                    Text("30").tag(0)
                    Text("60").tag(1)
                    Text("90").tag(2)
                    Text("120").tag(3)
                }.onChange(of: framerateIndex) {
                    updateFramerate()
                }
                Picker("Bitrate", selection: $bitrateIndex) {
                    Text("5Mbps").tag(0)
                    Text("10Mbps").tag(1)
                    Text("30Mbps").tag(2)
                    Text("50Mbps").tag(3)
                    Text("75Mbps").tag(4)
                    Text("100Mbps").tag(5)
                    Text("120Mbps").tag(6)
                    Text("200Mbps").tag(7)
                }
                .onChange(of: bitrateIndex) {
                    updateBitrate()
                }
                Picker("Touch Mode", selection: $settings.absoluteTouchMode) {
                    Text("Touchpad").tag(false)
                    Text("Touchscreen").tag(true)
                }
                Picker("On-Screen Controls", selection: $settings.onscreenControls) {
                    Text("Off").tag(OnScreenControlsLevel.off)
                    Text("Auto").tag(OnScreenControlsLevel.auto)
                    Text("Simple").tag(OnScreenControlsLevel.simple)
                    Text("Full").tag(OnScreenControlsLevel.full)
                    
                }
                Toggle("Optimize Game Settings", isOn: $settings.optimizeGames)
                Picker("Multi-Controller Mode", selection: $settings.multiController) {
                    Text("Single").tag(false)
                    Text("Auto").tag(true)
                }
                Toggle("Swap A/B and X/Y Buttons", isOn: $settings.swapABXYButtons)
                Toggle("Play Audio on PC", isOn: $settings.playAudioOnPC)
                Picker("Preferred Codec", selection: $settings.preferredCodec) {
                    Text("H.264").tag(PreferredCodec.h264)
                    Text("HEVC").tag(PreferredCodec.hevc)
                    Text("AV1").tag(PreferredCodec.av1)
                    Text("Auto").tag(PreferredCodec.auto)
                }
                Toggle("Enable HDR", isOn: $settings.enableHdr)
                Picker("Frame Pacing", selection: $settings.useFramePacing) {
                    Text("Lowest Latency").tag(false)
                    Text("Smoothest Video").tag(true)
                }
                Toggle("Citrix X1 Mouse Support", isOn: $settings.btMouseSupport)
                Toggle("Statistics Overlay", isOn: $settings.statsOverlay)
            }
            .navigationTitle("Settings")
            .onDisappear {
                settings.save()
            }
        }
    }
    
    static let customResolution = CGSize()
    
    // TODO: add custom resolutions
    let resolutionTable = [CGSize(width: 640, height: 360), CGSize(width: 1280, height: 720), CGSize(width: 1920, height: 1080), CGSize(width: 3840, height: 2160)]
    
    let framerateTable = [30, 60, 90, 120]
    
    let bitrateTable = [5000, 10000, 30000, 50000, 75000, 100000, 120000, 200000]
    
    @MainActor func updateResolution() {
        let resolution = resolutionTable[resolutionIndex]
        if resolution == SettingsView.customResolution {
            settings.width = Int32(customWidth)
            settings.width = Int32(customHeight)
        } else {
            settings.width = Int32(resolution.width)
            settings.height = Int32(resolution.height)
        }
    }
    
    @MainActor func updateFramerate() {
        settings.framerate = Int32(framerateTable[framerateIndex])
    }
    
    @MainActor func updateBitrate() {
        settings.bitrate = Int32(bitrateTable[bitrateIndex])
    }
    
    @MainActor func initSettingsState() {
        if let found = bitrateTable.enumerated().first(where: { $0.element == settings.bitrate }) {
            bitrateIndex = found.offset
        } else {
            bitrateIndex = 0
        }
        
        if let found = framerateTable.enumerated().first(where: { $0.element == settings.framerate }) {
            framerateIndex = found.offset
        } else {
            framerateIndex = 0
        }
        
        if let found = resolutionTable.enumerated().first(where: { NSInteger($0.element.width) == settings.width && NSInteger($0.element.height) == settings.height }) {
            resolutionIndex = found.offset
        } else {
            // last index is "custom"
            resolutionIndex = resolutionTable.count - 1
        }
    }
}

#Preview {
    @State var settings = TemporarySettings()
    return SettingsView(settings: $settings)
}
