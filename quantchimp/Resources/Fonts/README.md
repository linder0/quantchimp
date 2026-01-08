# Adding Plus Jakarta Sans Fonts

## Download

1. Visit: https://fonts.google.com/specimen/Plus+Jakarta+Sans
2. Click "Download family" button (top right)
3. Extract the ZIP file

## Required Font Files

Add these .ttf files from the `static` folder to this directory:

- `PlusJakartaSans-Regular.ttf`
- `PlusJakartaSans-Medium.ttf`
- `PlusJakartaSans-SemiBold.ttf`
- `PlusJakartaSans-Bold.ttf`
- `PlusJakartaSans-ExtraBold.ttf`

## Xcode Setup

1. Drag the .ttf files into this folder in Xcode's Project Navigator
2. In the dialog, check:
   - ☑️ Copy items if needed
   - ☑️ Add to target: quantchimp
3. Open `Info.plist` and verify "Fonts provided by application" contains all font files

## Verify Installation

After adding fonts, run the app and check the Typography preview in Xcode Previews.
If fonts load correctly, you'll see Plus Jakarta Sans instead of system fonts.

The app will gracefully fall back to system fonts if custom fonts are not installed.
