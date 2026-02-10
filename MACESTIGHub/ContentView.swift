import SwiftUI

struct ContentView: View {
    @State private var toastMessage = ""
    @State private var toastIsError = false
    @State private var showToast = false
    @State private var showInfoSheet = false
    @State private var glowOpacity: Double = 0.0
    @Environment(\.colorScheme) var colorScheme

    private var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        ZStack {
            // MARK: - Background
            backgroundGradient

            VStack(spacing: 0) {
                // MARK: - Header
                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.orange.opacity(glowOpacity * 0.25),
                                        Color.orange.opacity(glowOpacity * 0.1),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 70
                                )
                            )
                            .frame(width: 120, height: 120)
                            .blur(radius: 20)

                        Image("HubLogo")
                            .resizable()
                            .interpolation(.high)
                            .antialiased(true)
                            .scaledToFit()
                            .frame(height: 80)
                    }
                    .frame(height: 80)

                    Text("MACE STIG Hub")
                        .font(.system(size: 20, weight: .bold, design: .rounded))

                    Text("v\(version)")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.indigo)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(Color.indigo.opacity(colorScheme == .dark ? 0.12 : 0.10))
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.indigo.opacity(colorScheme == .dark ? 0.2 : 0.3), lineWidth: 0.5)
                        )
                        .padding(.top, 2)
                }
                .padding(.top, 0)
                .padding(.bottom, 6)

                // MARK: - Description
                Text("Open STIG Viewer 2 or 3 on macOS with all dependencies bundled. No extra installs or recompiling required.")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 36)
                    .padding(.bottom, 14)

                // MARK: - Launcher Buttons
                HStack(spacing: 14) {
                    LauncherButton(
                        title: "STIG Viewer 2",
                        version: "v2.18",
                        platform: "Java",
                        imageName: "SV2Icon",
                        color: .blue
                    ) {
                        launchSTIGViewer2()
                    }

                    LauncherButton(
                        title: "STIG Viewer 3",
                        version: "v3.6",
                        platform: "Electron",
                        imageName: "SV3Icon",
                        color: .green
                    ) {
                        launchSTIGViewer3()
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 14)

                // MARK: - Link Buttons
                HStack(spacing: 14) {
                    LinkButton(
                        title: "DISA STIG",
                        systemImage: "shield.checkered",
                        color: .teal,
                        url: "https://www.cyber.mil/stigs/srg-stig-tools/"
                    )

                    LinkButton(
                        title: "MACE STIG Hub",
                        systemImage: "chevron.left.slash.chevron.right",
                        color: .orange,
                        url: "https://github.com/mace-app/mace-stig-hub"
                    )
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 10)

                // MARK: - Disclaimer Card
                disclaimerSection
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
            }

            // MARK: - (?) Button
            VStack {
                Spacer()
                HStack {
                    Button(action: { showInfoSheet = true }) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
            .padding(.leading, 14)
            .padding(.bottom, 10)

            // MARK: - Toast Overlay
            VStack {
                Spacer()
                if showToast {
                    toastView
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 8)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showToast)
        }
        .frame(width: 440, height: 520)
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                glowOpacity = 1.0
            }
        }
        .sheet(isPresented: $showInfoSheet) {
            InfoSheetView {
                showInfoSheet = false
            }
        }
    }

    // MARK: - Background Gradient

    private var backgroundGradient: some View {
        ZStack {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        Color(nsColor: .windowBackgroundColor),
                        Color(nsColor: .windowBackgroundColor).opacity(0.95),
                        Color.blue.opacity(0.03),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
    }

    // MARK: - Disclaimer Section

    private var disclaimerSection: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)

            Text("STIG Viewer is developed and published by DISA for the DoD. This tool is an independent project that simplifies launching the viewers on macOS and is not affiliated with, endorsed by, or supported by DISA or the DoD.")
                .font(.system(size: 9))
                .foregroundStyle(.secondary)
                .lineSpacing(1.5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .dark ? Color.white.opacity(0.03) : Color.black.opacity(0.02))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.secondary.opacity(colorScheme == .dark ? 0.1 : 0.2), lineWidth: 0.5)
        )
    }

    // MARK: - Toast View

    private var toastView: some View {
        HStack(spacing: 6) {
            Image(systemName: toastIsError ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                .font(.system(size: 12))
                .foregroundStyle(toastIsError ? .red : .green)
            Text(toastMessage)
                .font(.system(size: 11, weight: .medium))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        )
        .overlay(
            Capsule()
                .strokeBorder(
                    toastIsError ? Color.red.opacity(0.3) : Color.green.opacity(0.3),
                    lineWidth: 0.5
                )
        )
    }

    private func showTemporaryToast(_ message: String, isError: Bool) {
        toastMessage = message
        toastIsError = isError
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showToast = false
        }
    }

    // MARK: - Architecture detection

    private var isAppleSilicon: Bool {
        #if arch(arm64)
        return true
        #else
        return false
        #endif
    }

    // MARK: - Bundled resource paths

    private var resourcesURL: URL {
        Bundle.main.resourceURL!
    }

    private var jreFolderName: String {
        isAppleSilicon ? "jre-arm64" : "jre-x64"
    }

    private var bundledJavaPath: String {
        resourcesURL
            .appendingPathComponent(jreFolderName)
            .appendingPathComponent("bin/java")
            .path
    }

    private var bundledJarPath: String {
        resourcesURL
            .appendingPathComponent("STIGViewer-2.18.jar")
            .path
    }

    private var sv2IconPath: String {
        resourcesURL
            .appendingPathComponent("stigviewer2.icns")
            .path
    }

    private var sv3FolderName: String {
        isAppleSilicon ? "sv3-arm64" : "sv3-x64"
    }

    private var bundledSV3AppURL: URL {
        resourcesURL
            .appendingPathComponent(sv3FolderName)
            .appendingPathComponent("STIG Viewer 3.app")
    }

    // MARK: - Launchers

    private func launchSTIGViewer2() {
        guard FileManager.default.fileExists(atPath: bundledJavaPath) else {
            showTemporaryToast("Bundled JRE (\(jreFolderName)) not found.", isError: true)
            return
        }
        guard FileManager.default.fileExists(atPath: bundledJarPath) else {
            showTemporaryToast("STIGViewer-2.18.jar not found in app bundle.", isError: true)
            return
        }

        let task = Process()
        task.executableURL = URL(fileURLWithPath: bundledJavaPath)
        task.arguments = [
            "-Xdock:name=STIG Viewer 2",
            "-Xdock:icon=\(sv2IconPath)",
            "-jar", bundledJarPath
        ]

        do {
            try task.run()
            showTemporaryToast("Launching STIG Viewer 2", isError: false)
        } catch {
            showTemporaryToast("Failed to launch: \(error.localizedDescription)", isError: true)
        }
    }

    private func launchSTIGViewer3() {
        let sv3Binary = bundledSV3AppURL
            .appendingPathComponent("Contents/MacOS/STIG Viewer 3")
        guard FileManager.default.fileExists(atPath: sv3Binary.path) else {
            showTemporaryToast("STIG Viewer 3.app not found in app bundle.", isError: true)
            return
        }

        let task = Process()
        task.executableURL = sv3Binary
        task.arguments = ["--no-sandbox"]
        task.currentDirectoryURL = bundledSV3AppURL.appendingPathComponent("Contents/MacOS")

        do {
            try task.run()
            showTemporaryToast("Launching STIG Viewer 3", isError: false)
        } catch {
            showTemporaryToast("Failed to launch: \(error.localizedDescription)", isError: true)
        }
    }
}

// MARK: - Badge Pill

struct BadgePill: View {
    let text: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .semibold, design: .monospaced))
            .foregroundStyle(color)
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(color.opacity(colorScheme == .dark ? 0.12 : 0.10))
            )
            .overlay(
                Capsule()
                    .strokeBorder(color.opacity(colorScheme == .dark ? 0.2 : 0.3), lineWidth: 0.5)
            )
    }
}

// MARK: - Launcher Button

struct LauncherButton: View {
    let title: String
    let version: String
    let platform: String
    let imageName: String
    let color: Color
    let action: () -> Void

    @State private var isHovering = false
    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(imageName)
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
                    .scaledToFit()
                    .frame(height: 70)
                    .shadow(color: .black.opacity(isHovering ? 0.25 : 0.1), radius: isHovering ? 6 : 3, y: isHovering ? 3 : 2)

                VStack(spacing: 3) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))

                    BadgePill(text: version, color: color)

                    BadgePill(text: platform, color: color)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 145)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isHovering
                          ? color.opacity(colorScheme == .dark ? 0.08 : 0.10)
                          : (colorScheme == .dark ? Color.white.opacity(0.03) : Color.black.opacity(0.04)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isHovering
                            ? LinearGradient(colors: [color.opacity(0.6), color.opacity(0.4)], startPoint: .top, endPoint: .bottom)
                            : LinearGradient(colors: [color.opacity(colorScheme == .dark ? 0.2 : 0.35), color.opacity(colorScheme == .dark ? 0.15 : 0.25)], startPoint: .top, endPoint: .bottom),
                        lineWidth: 1.5
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .pressEvents {
            withAnimation(.easeInOut(duration: 0.1)) { isPressed = true }
        } onRelease: {
            withAnimation(.easeInOut(duration: 0.1)) { isPressed = false }
        }
    }
}

// MARK: - Press Events Modifier

struct PressEventsModifier: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onPress() }
                    .onEnded { _ in onRelease() }
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressEventsModifier(onPress: onPress, onRelease: onRelease))
    }
}

#Preview {
    ContentView()
}
