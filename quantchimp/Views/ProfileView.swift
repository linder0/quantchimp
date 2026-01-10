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

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Profile header
                profileHeader

                // Settings sections
                settingsSection

                Spacer(minLength: 40)
            }
            .padding(Spacing.md)
            .padding(.top, 40)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .sheet(isPresented: $showAvatarPicker) {
            AvatarPickerSheet(selectedAvatar: $appState.userProfile.avatarImage)
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
            // Avatar
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
                        .fill(Theme.accent)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "pencil")
                                .font(.caption)
                                .foregroundColor(Theme.background)
                        )
                        .offset(x: 44, y: 44)
                }
            }

            // Name
            Button {
                editedName = appState.userProfile.displayName
                isEditingName = true
            } label: {
                HStack(spacing: Spacing.sm) {
                    Text(appState.userProfile.displayName)
                        .font(Typography.heading2)
                        .foregroundColor(Theme.textPrimary)

                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundColor(Theme.accent)
                }
            }
        }
        .padding(.vertical, Spacing.lg)
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("SETTINGS")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

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
            .cardStyle()

            // About section
            VStack(alignment: .leading, spacing: Spacing.md) {
                Text("ABOUT")
                    .font(Typography.headline)
                    .foregroundColor(Theme.textPrimary)
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
                .cardStyle()
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

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AppState())
    }
}
