BINDIR = bin

TARGET ?= lrt
SCHEME ?= $(TARGET)
CONFIGURATION ?= Release
DEVELOPMENT_TEAM = DXEF6FH82Q

REPOSITORY_URL ?= https://github.com/Adroiti/viptag-ios
DISTRIBUTION_NOTES_FILE ?= distribution_notes.txt

PROJ_PATH = $(shell pwd)

.PHONY: all distribute clean synx

all: $(BINDIR)/$(TARGET).ipa $(BINDIR)/$(TARGET).app.dSYM.zip

### General Xcode tooling

$(BINDIR)/$(TARGET).ipa: $(BINDIR)/$(TARGET).xcarchive
	xcodebuild -exportArchive -archivePath $< -exportOptionsPlist Config/ReleaseExportOptions.plist -exportPath $(@D)

$(BINDIR)/$(TARGET).app.dSYM.zip: $(BINDIR)/$(TARGET).xcarchive
	pushd $(PROJ_PATH)/$</dSYMs/ && zip -r $(PROJ_PATH)/$@ *.dSYM && popd

$(BINDIR)/$(TARGET).xcarchive:
	set -o pipefail && xcodebuild -project $(TARGET).xcodeproj -scheme $(TARGET) -configuration '$(CONFIGURATION)' clean archive -archivePath $@ DEVELOPMENT_TEAM='$(DEVELOPMENT_TEAM)'  | xcpretty

distribute: $(BINDIR)/$(TARGET).ipa $(BINDIR)/$(TARGET).app.dSYM.zip
	curl -v "https://rink.hockeyapp.net/api/2/apps/upload" \
		-F status=2 \
		-F notify=0 \
		-F ipa=@"$(word 1,$^)" \
		-F dsym=@"$(word 2,$^)" \
		-H "X-HockeyAppToken: $(HOCKEY_APP_TOKEN)" \
		-F notes=@"$(DISTRIBUTION_NOTES_FILE)" \
		-F commit_sha="$(COMMIT_SHA1)" \
		-F build_server_url="$(BUILD_URL)" \
		-F repository_url="$(REPOSITORY_URL)"

clean:
	rm -rf $(BINDIR)

synx:
	$(BUNDLE) synx -p $(TARGET).xcodeproj
