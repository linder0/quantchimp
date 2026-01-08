//
//  ProfileView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    @State private var isEditingName = false
    @State private var editedName = ""
    @State private var showAvatarPicker = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile header
                profileHeader

                // Settings sections
                settingsSection

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $showAvatarPicker) {
            AvatarPickerSheet(selectedEmoji: $appState.userProfile.avatarEmoji)
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
        VStack(spacing: 16) {
            // Avatar
            Button {
                showAvatarPicker = true
            } label: {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.orange.opacity(0.3), .yellow.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)

                    Text(appState.userProfile.avatarEmoji)
                        .font(.system(size: 60))

                    // Edit badge
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "pencil")
                                .font(.caption)
                                .foregroundColor(.white)
                        )
                        .offset(x: 40, y: 40)
                }
            }

            // Name
            Button {
                editedName = appState.userProfile.displayName
                isEditingName = true
            } label: {
                HStack(spacing: 8) {
                    Text(appState.userProfile.displayName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundColor(.orange)
                }
            }

            // Level badge
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Level \(appState.currentLevel)")
                    .fontWeight(.semibold)
            }
            .font(.subheadline)
        }
        .padding(.vertical, 20)
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)

            VStack(spacing: 0) {
                SettingsToggleRow(
                    icon: "speaker.wave.2.fill",
                    title: "Sound Effects",
                    isOn: $appState.userProfile.soundEnabled
                )

                Divider()
                    .padding(.leading, 52)

                SettingsToggleRow(
                    icon: "iphone.radiowaves.left.and.right",
                    title: "Haptic Feedback",
                    isOn: $appState.userProfile.hapticsEnabled
                )

                Divider()
                    .padding(.leading, 52)

                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    subtitle: "Coming soon"
                )
            }
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)

            // About section
            VStack(alignment: .leading, spacing: 16) {
                Text("About")
                    .font(.headline)
                    .padding(.top, 8)

                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "info.circle.fill",
                        title: "Version",
                        subtitle: "1.0.0"
                    )
                }
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            }
        }
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 28)

            Text(title)
                .font(.body)

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(.orange)
        }
        .padding()
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 28)

            Text(title)
                .font(.body)

            Spacer()

            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct AvatarPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedEmoji: String

    private let columns = Array(repeating: GridItem(.flexible()), count: 5)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(UserProfile.avatarOptions, id: \.self) { emoji in
                        Button {
                            selectedEmoji = emoji
                            dismiss()
                        } label: {
                            Text(emoji)
                                .font(.system(size: 40))
                                .frame(width: 60, height: 60)
                                .background(
                                    selectedEmoji == emoji ?
                                    Color.orange.opacity(0.2) :
                                    Color(.systemGray6)
                                )
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            selectedEmoji == emoji ? Color.orange : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
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
