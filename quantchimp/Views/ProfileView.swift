//
//  ProfileView.swift
//  quantchimp
//
//  Profile view using Theme tokens
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    @State private var showEditProfile = false

    private var profileColorValue: Color {
        Color(hex: appState.userProfile.profileColor.hex)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Colored header
            profileHeader

            // Content (no scroll - fits on screen)
            VStack(spacing: Spacing.lg) {
                // Settings sections
                settingsSection

                Spacer()
            }
            .padding(Spacing.md)
            .frame(maxHeight: .infinity)
            .background(Theme.background)
        }
        .background(Theme.background.ignoresSafeArea(edges: .top))
        .sheet(isPresented: $showEditProfile) {
            ProfileEditSheet(
                displayName: appState.userProfile.displayName,
                selectedAvatar: appState.userProfile.avatarImage,
                selectedColor: appState.userProfile.profileColor
            ) { name, avatar, color in
                appState.userProfile.displayName = name
                appState.userProfile.avatarImage = avatar
                appState.userProfile.profileColor = color
                // Update theme with saved color
                ThemeManager.shared.setAccentColor(hex: color.hex, lightHex: color.lightHex)
            }
        }
    }

    private var profileHeader: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: Spacing.md) {
                // Avatar
                Image(appState.userProfile.avatarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                // Name
                Text(appState.userProfile.displayName)
                    .font(Typography.heading2)
                    .foregroundColor(.white)
            }
            .padding(.top, 70)
            .padding(.bottom, Spacing.lg)
            .frame(maxWidth: .infinity)

            // Edit button in top right
            Button {
                showEditProfile = true
            } label: {
                Circle()
                    .fill(.white)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(profileColorValue)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(.top, 60)
            .padding(.trailing, Spacing.md)
        }
        .background(
            LinearGradient(
                colors: [profileColorValue, profileColorValue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)
        )
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "Settings")

            VStack(spacing: 0) {
                SettingsToggleRow(
                    icon: "speaker.wave.2.fill",
                    title: "Sound Effects",
                    isOn: $appState.userProfile.soundEnabled
                )

                Divider()
                    .background(Theme.surfaceBorder)
                    .padding(.leading, 52)

                SettingsToggleRow(
                    icon: "iphone.radiowaves.left.and.right",
                    title: "Haptic Feedback",
                    isOn: $appState.userProfile.hapticsEnabled
                )

                Divider()
                    .background(Theme.surfaceBorder)
                    .padding(.leading, 52)

                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    subtitle: "Coming soon"
                )
            }
            .cardStyle(hasBorder: false)

            // About section
            VStack(alignment: .leading, spacing: Spacing.md) {
                SectionHeader(title: "About")
                    .padding(.top, Spacing.sm)

                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "info.circle.fill",
                        title: "Version",
                        subtitle: "1.0.0"
                    )

                    #if DEBUG
                    Divider()
                        .background(Theme.surfaceBorder)
                        .padding(.leading, 52)

                    Button {
                        appState.hasCompletedOnboarding = false
                    } label: {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title3)
                                .foregroundColor(Theme.error)
                                .frame(width: 28)

                            Text("Reset Onboarding")
                                .font(Typography.body)
                                .foregroundColor(Theme.error)

                            Spacer()
                        }
                        .padding(Spacing.md)
                    }
                    #endif
                }
                .cardStyle(hasBorder: false)
            }
        }
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Theme.accent)
                .frame(width: 28)

            Text(title)
                .font(Typography.body)
                .foregroundColor(Theme.textPrimary)

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(Theme.accent)
        }
        .padding(Spacing.md)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Theme.accent)
                .frame(width: 28)

            Text(title)
                .font(Typography.body)
                .foregroundColor(Theme.textPrimary)

            Spacer()

            Text(subtitle)
                .font(Typography.body)
                .foregroundColor(Theme.textSecondary)
        }
        .padding(Spacing.md)
    }
}

struct ProfileEditSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var editedName: String
    @State private var editedAvatar: String
    @State private var editedColor: ProfileColor

    private let originalColor: ProfileColor

    let onSave: (String, String, ProfileColor) -> Void

    private let avatarColumns = Array(repeating: GridItem(.flexible()), count: 5)
    private let colorColumns = Array(repeating: GridItem(.flexible()), count: 3)

    init(displayName: String, selectedAvatar: String, selectedColor: ProfileColor, onSave: @escaping (String, String, ProfileColor) -> Void) {
        _editedName = State(initialValue: displayName)
        _editedAvatar = State(initialValue: selectedAvatar)
        _editedColor = State(initialValue: selectedColor)
        self.originalColor = selectedColor
        self.onSave = onSave
    }

    private var previewColorValue: Color {
        Color(hex: editedColor.hex)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Live Preview Section
                    livePreviewCard

                    // Display Name Section
                    nameEditCard

                    // Avatar Section
                    avatarSelectionCard

                    // Color Section
                    colorSelectionCard
                }
                .padding(Spacing.lg)
            }
            .background(Theme.background)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        // Restore original color
                        ThemeManager.shared.setAccentColor(hex: originalColor.hex, lightHex: originalColor.lightHex)
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedName = editedName.trimmingCharacters(in: .whitespaces)
                        if !trimmedName.isEmpty {
                            onSave(trimmedName, editedAvatar, editedColor)
                        }
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.large])
        .onAppear {
            // Set initial preview color
            updatePreviewColor()
        }
    }

    private func updatePreviewColor() {
        ThemeManager.shared.setAccentColor(hex: editedColor.hex, lightHex: editedColor.lightHex)
    }

    // MARK: - Live Preview Card

    private var livePreviewCard: some View {
        VStack(spacing: Spacing.md) {
            // Avatar
            Image(editedAvatar)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            // Name
            Text(editedName.isEmpty ? "Display Name" : editedName)
                .font(Typography.heading2)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xl)
        .background(
            LinearGradient(
                colors: [previewColorValue, previewColorValue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(Radius.lg)
        .surfaceShadow()
    }

    // MARK: - Name Edit Card

    private var nameEditCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Display Name")
                .font(Typography.heading3)
                .foregroundColor(Theme.textPrimary)

            TextField("Enter your name", text: $editedName)
                .font(Typography.body)
                .foregroundColor(Theme.textPrimary)
                .padding(Spacing.md)
                .background(Theme.surfaceElevated)
                .cornerRadius(Radius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(Theme.surfaceBorder, lineWidth: 1)
                )
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.surface)
        .cornerRadius(Radius.lg)
        .surfaceShadow()
    }

    // MARK: - Avatar Selection Card

    private var avatarSelectionCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Avatar")
                .font(Typography.heading3)
                .foregroundColor(Theme.textPrimary)

            LazyVGrid(columns: avatarColumns, spacing: Spacing.md) {
                ForEach(UserProfile.avatarOptions, id: \.self) { avatar in
                    Button {
                        Haptic.light()
                        withAnimation(Motion.spring) {
                            editedAvatar = avatar
                        }
                    } label: {
                        Image(avatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .stroke(
                                        editedAvatar == avatar ? Theme.accent : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                            .scaleEffect(editedAvatar == avatar ? 1.05 : 1.0)
                            .animation(Motion.spring, value: editedAvatar)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.surface)
        .cornerRadius(Radius.lg)
        .surfaceShadow()
    }

    // MARK: - Color Selection Card

    private var colorSelectionCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Profile Color")
                .font(Typography.heading3)
                .foregroundColor(Theme.textPrimary)

            LazyVGrid(columns: colorColumns, spacing: Spacing.lg) {
                ForEach(ProfileColor.allCases) { color in
                    Button {
                        Haptic.light()
                        withAnimation(Motion.spring) {
                            editedColor = color
                            updatePreviewColor()
                        }
                    } label: {
                        VStack(spacing: Spacing.sm) {
                            Circle()
                                .fill(Color(hex: color.hex))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            editedColor == color ? .white : Color.clear,
                                            lineWidth: 3
                                        )
                                )
                                .shadow(
                                    color: Color(hex: color.hex).opacity(editedColor == color ? 0.6 : 0.3),
                                    radius: editedColor == color ? 12 : 8,
                                    x: 0,
                                    y: editedColor == color ? 6 : 4
                                )
                                .scaleEffect(editedColor == color ? 1.05 : 1.0)
                                .animation(Motion.spring, value: editedColor)

                            Text(color.rawValue)
                                .font(Typography.caption)
                                .foregroundColor(Theme.textPrimary)
                        }
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.surface)
        .cornerRadius(Radius.lg)
        .surfaceShadow()
    }
}

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(Motion.snappy, value: configuration.isPressed)
    }
}

struct AvatarPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedAvatar: String

    private let columns = Array(repeating: GridItem(.flexible()), count: 5)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: Spacing.md) {
                    ForEach(UserProfile.avatarOptions, id: \.self) { avatar in
                        Button {
                            selectedAvatar = avatar
                            dismiss()
                        } label: {
                            Image(avatar)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Radius.md)
                                        .stroke(
                                            selectedAvatar == avatar ? Theme.accent : Color.clear,
                                            lineWidth: 3
                                        )
                                )
                                .scaleEffect(selectedAvatar == avatar ? 1.05 : 1.0)
                                .animation(Motion.spring, value: selectedAvatar)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(Spacing.md)
            }
            .background(Theme.background)
            .navigationTitle("Choose Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

struct ColorPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedColor: ProfileColor

    private let columns = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: Spacing.md) {
                    ForEach(ProfileColor.allCases) { color in
                        Button {
                            selectedColor = color
                            dismiss()
                        } label: {
                            VStack(spacing: Spacing.sm) {
                                Circle()
                                    .fill(Color(hex: color.hex))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                selectedColor == color ? .white : Color.clear,
                                                lineWidth: 3
                                            )
                                    )
                                    .shadow(color: Color(hex: color.hex).opacity(0.4), radius: 8, x: 0, y: 4)

                                Text(color.rawValue)
                                    .font(Typography.caption)
                                    .foregroundColor(Theme.textPrimary)
                            }
                            .padding(Spacing.sm)
                            .background(
                                selectedColor == color ?
                                Theme.surfaceElevated :
                                Color.clear
                            )
                            .cornerRadius(Radius.md)
                        }
                    }
                }
                .padding(Spacing.lg)
            }
            .background(Theme.background)
            .navigationTitle("Profile Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AppState())
    }
}
