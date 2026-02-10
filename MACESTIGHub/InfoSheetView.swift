import SwiftUI
import AppKit

struct InfoSheetView: View {
    var onClose: () -> Void
    @Environment(\.colorScheme) var colorScheme

    @State private var logoScale: CGFloat = 0.8
    @State private var logoRotation: Double = -10
    @State private var showContent = false
    @State private var copiedFeedback = false

    private var appName: String { "MACE STIG Hub" }
    private var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    private var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
    }
    private var bundleID: String {
        Bundle.main.bundleIdentifier ?? "-"
    }
    private var osVersionString: String {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        return "macOS \(v.majorVersion).\(v.minorVersion).\(v.patchVersion)"
    }
    private var appInstallPath: String {
        Bundle.main.bundlePath
    }

    private var archString: String {
        #if arch(arm64)
        return "arm64"
        #elseif arch(x86_64)
        return "x86_64"
        #else
        return "unknown"
        #endif
    }

    private func cpuBrandString() -> String {
        var size: Int = 0
        sysctlbyname("machdep.cpu.brand_string", nil, &size, nil, 0)
        guard size > 0 else { return "" }
        var buffer = [CChar](repeating: 0, count: size)
        sysctlbyname("machdep.cpu.brand_string", &buffer, &size, nil, 0)
        return String(cString: buffer)
    }

    private var cpuPrettyString: String {
        let raw = cpuBrandString()
        if raw.lowercased().hasPrefix("apple ") {
            return raw.replacingOccurrences(of: "Apple ", with: "")
        }
        if raw.contains("Intel") {
            var s = raw
            s = s.replacingOccurrences(of: "(R)", with: "", options: .caseInsensitive)
            s = s.replacingOccurrences(of: "(TM)", with: "", options: .caseInsensitive)
            s = s.replacingOccurrences(of: "  ", with: " ")
            let parts = s.split(separator: " ")
            if let intelIndex = parts.firstIndex(where: { $0.lowercased() == "intel" || $0.lowercased().hasPrefix("intel") }) {
                let tail = parts.dropFirst(intelIndex + 1)
                let short = ([String(parts[intelIndex])]) + tail.prefix(2).map(String.init)
                return short.joined(separator: " ")
            }
            return s
        }
        return raw.isEmpty ? archString : raw
    }

    private var isSigned: Bool {
        var code: SecCode?
        let status = SecCodeCopySelf(SecCSFlags(), &code)
        guard status == errSecSuccess, let code = code else { return false }

        var staticCode: SecStaticCode?
        let staticStatus = SecCodeCopyStaticCode(code, SecCSFlags(), &staticCode)
        guard staticStatus == errSecSuccess, let staticCode = staticCode else { return false }

        var signingInfo: CFDictionary?
        let status2 = SecCodeCopySigningInformation(staticCode, SecCSFlags(rawValue: kSecCSSigningInformation), &signingInfo)
        guard status2 == errSecSuccess else { return false }
        guard let info = signingInfo as? [String: Any] else { return false }

        return info[kSecCodeInfoCertificates as String] != nil
    }

    private var diagnosticsSummary: String {
        var lines: [String] = []
        lines.append("\(appName) \(version) (\(build))")
        lines.append("Bundle ID: \(bundleID)\(isSigned ? "  [Signed]" : "  [Unsigned]")")
        lines.append("System OS: \(osVersionString)")
        lines.append("Chip: \(cpuPrettyString)")
        lines.append("Install Path: \(appInstallPath)")
        return lines.joined(separator: "\n")
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            VStack(spacing: 6) {
                Image("HubLogo")
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
                    .scaledToFit()
                    .frame(height: 80)
                    .scaleEffect(logoScale)
                    .rotationEffect(.degrees(logoRotation))

                Text(appName)
                    .font(.system(size: 24, weight: .bold, design: .rounded))

                HStack(spacing: 8) {
                    Text("v\(version)")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.tertiary)

                    HStack(spacing: 2) {
                        Image(systemName: isSigned ? "checkmark.seal.fill" : "xmark.seal.fill")
                            .font(.system(size: 9))
                        Text(isSigned ? "Signed" : "Unsigned")
                            .font(.system(size: 9, weight: .medium))
                    }
                    .foregroundStyle(isSigned ? .green : .orange)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background((isSigned ? Color.green : Color.orange).opacity(0.15))
                    .clipShape(Capsule())
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 10)

            // MARK: - Content
            VStack(spacing: 14) {
                // Description
                Text("Built by one mac admin for another.")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 10)

                // Developer Card
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.green.opacity(0.3), .teal.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)

                            Image(systemName: "person.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.white.opacity(0.8))
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Cody Keats")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Mac Admin & Developer")
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    HStack(spacing: 10) {
                        Button {
                            if let url = URL(string: "https://github.com/cocopuff2u/") {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            Label("GitHub", systemImage: "chevron.left.slash.chevron.right")
                                .lineLimit(1)
                        }
                        .buttonStyle(.bordered)

                        Button {
                            if let url = URL(string: "https://codykeats.com") {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            Label("Website", systemImage: "globe")
                                .lineLimit(1)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.03))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.secondary.opacity(0.15), lineWidth: 1)
                )
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 10)

                // System Info Card
                VStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.purple)
                        Text("System Information")
                            .font(.system(size: 11, weight: .semibold))
                        Spacer()
                    }

                    VStack(spacing: 4) {
                        systemInfoRow(icon: "desktopcomputer", label: "System", value: osVersionString, color: .blue)
                        systemInfoRow(icon: "cpu", label: "Chip", value: cpuPrettyString, color: .orange)
                        systemInfoRow(icon: "shippingbox", label: "Bundle ID", value: bundleID, color: .green)
                        systemInfoRow(icon: "folder", label: "Install Path", value: appInstallPath, color: .purple, truncate: true)
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.03))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.secondary.opacity(0.15), lineWidth: 1)
                )
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 10)
            }
            .padding(.horizontal, 20)

            Spacer(minLength: 8)

            // MARK: - Footer
            Divider()
                .padding(.horizontal, 20)

            HStack(spacing: 12) {
                Button(action: {
                    let pb = NSPasteboard.general
                    pb.clearContents()
                    pb.setString(diagnosticsSummary, forType: .string)
                    copiedFeedback = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        copiedFeedback = false
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: copiedFeedback ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 10))
                        Text(copiedFeedback ? "Copied!" : "Copy Info")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .frame(width: 100)
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
                .foregroundStyle(copiedFeedback ? .green : .primary)

                Spacer()

                Button(action: { onClose() }) {
                    Text("Close")
                        .font(.system(size: 11, weight: .semibold))
                        .frame(width: 80)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .controlSize(.regular)
                .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .frame(width: 420, height: 490)
        .background(Color(nsColor: .windowBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.5),
                            colorScheme == .dark ? Color.white.opacity(0.05) : Color.white.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                logoScale = 1.0
                logoRotation = 0
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                showContent = true
            }
        }
    }

    // MARK: - System Info Row

    private func systemInfoRow(icon: String, label: String, value: String, color: Color, truncate: Bool = false) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(color)
                .frame(width: 14)

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 65, alignment: .leading)

            if truncate {
                Text(value)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.primary.opacity(0.8))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .textSelection(.enabled)
            } else {
                Text(value)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.primary.opacity(0.8))
                    .textSelection(.enabled)
            }

            Spacer()
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Link Button

struct LinkButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let url: String

    @State private var isHovering = false
    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button {
            guard let url = URL(string: url) else { return }
            NSWorkspace.shared.open(url)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .medium))
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.tertiary)
            }
            .foregroundStyle(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isHovering
                          ? color.opacity(colorScheme == .dark ? 0.12 : 0.10)
                          : color.opacity(colorScheme == .dark ? 0.06 : 0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        isHovering
                            ? color.opacity(colorScheme == .dark ? 0.5 : 0.6)
                            : color.opacity(colorScheme == .dark ? 0.2 : 0.35),
                        lineWidth: 1
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

#Preview {
    InfoSheetView(onClose: {})
}
