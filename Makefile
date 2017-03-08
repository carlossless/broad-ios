BINDIR = bin

TARGET ?= lrt
SCHEME ?= $(TARGET)
CONFIGURATION ?= Release
PLIST_BUDDY = /usr/libexec/PlistBuddy
BUNDLE ?= bundle exec

REPOSITORY_URL ?= https://github.com/Adroiti/viptag-ios
DISTRIBUTION_NOTES_FILE ?= distribution_notes.txt

.PHONY: distribute clean synx

### General Xcode tooling

$(BINDIR)/$(TARGET).ipa $(BINDIR)/$(TARGET).app.dSYM.zip:
	$(BUNDLE) fastlane gym --configuration '$(CONFIGURATION)' -o $(@D) -n $(TARGET) -j ad-hoc

distribute: $(BINDIR)/$(TARGET).ipa $(BINDIR)/$(TARGET).app.dSYM.zip
	$(BUNDLE) ipa distribute:hockeyapp -f '$(word 1,$^)' -d '$(word 2,$^)' -a '$(HOCKEY_APP_TOKEN)' --notes-file '$(DISTRIBUTION_NOTES_FILE)' --commit-sha '$(COMMIT_SHA1)' --build-server-url '$(BUILD_URL)' --repository-url '$(REPOSITORY_URL)'

clean:
	rm -rf $(BINDIR)

synx:
	$(BUNDLE) synx -p $(TARGET).xcodeproj
