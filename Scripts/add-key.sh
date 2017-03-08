#!/bin/sh

#create, setup and unlock keychain
security create-keychain -p travis ios-build.keychain
security default-keychain -s ios-build.keychain
security unlock-keychain -p travis ios-build.keychain
security set-keychain-settings ios-build.keychain

#add certificates and keys to the keychain
security import ./Signing/Certificates/apple.cer -k ~/Library/Keychains/ios-build.keychain -A
security import ./Signing/Certificates/dist.cer -k ~/Library/Keychains/ios-build.keychain -A
security import ./Signing/Certificates/dist.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -A
security import ./Signing/Certificates/dev.cer -k ~/Library/Keychains/ios-build.keychain -A
security import ./Signing/Certificates/dev.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -A

#copy all provisioning profiles to the designated directory
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./Signing/Provisioning/* ~/Library/MobileDevice/Provisioning\ Profiles/
