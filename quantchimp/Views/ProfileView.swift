//
//  ProfileView.swift
//  quantchimp
//
//  Profile view using Theme tokens
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    @State private var isEditingName = false
    @State private var editedName = ""
    @State private var showAvatarPicker = false
    @State private var showColorPicker = false

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
        .sheet(isPresented: $showAvatarPicker) {
            AvatarPickerSheet(selectedAvatar: $appState.userProfile.avatarImage)
        }
        .sheet(isPresented: $showColorPicker) {
            ColorPickerSheet(selectedColor: $appState.userProfile.profileColor)
        }
        .alert("Edit Name", isPresented: $isEditingName) {
            TextField("Display Name", text: $editedName)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                if !editedName.trimmingCharacters(in: .whitespaces).isEmpty {
                    appState.userProfile.displayName = editedName.trimmingCharacters(in: .whitespaces)
                }
            }
        } message: {
            Text("Enter your display name")
        }
    }

    private var profileHeader: some View {
        VStack(spacing: Spacing.md) {
            // Avatar with edit button
            Button {
                showAvatarPicker = true
            } label: {
                ZStack {
                    Image(appState.userProfile.avatarImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)

                    // Edit badge
                    Circle()
                        .fill(.white)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "pencil")
                                .font(.caption)
                                .foregroundColor(profileColorValue)
                        )
                        .offset(x: 44, y: 44)
                }
            }

            // Name with edit button
            Button {
                editedName = appState.userProfile.displayName
                isEditingName = true
            } label: {
                HStack(spacing: Spacing.sm) {
                    Text(appState.userProfile.displayName)
                        .font(Typography.heading2)
                        .foregroundColor(.white)

                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                }
            }

            // Color picker button
            Button {
                showColorPicker = true
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "paintpalette.fill")
                        .font(.caption)
                    Text("Change Color")
                        .font(Typography.caption)
                }
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(.white.opacity(0.2))
                .cornerRadius(Radius.full)
            }
        }
        .padding(.top, 70)
        .padding(.bottom, Spacing.lg)
        .frame(maxWidth: .infinity)
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
                                .frame(width: 50, height: 50)
                                .padding(5)
                                .background(
                                    selectedAvatar == avatar ?
                                    Theme.accent.opacity(0.2) :
                                    Theme.surfaceElevated
                                )
                                .cornerRadius(Radius.md)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Radius.md)
                                        .stroke(
                                            selectedAvatar == avatar ? Theme.accent : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                        }
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
