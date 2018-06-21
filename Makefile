BINDIR = bin

TARGET ?= Broad
SCHEME ?= $(TARGET)
CONFIGURATION ?= AdHoc
DEVELOPMENT_TEAM = DXEF6FH82Q
EXPORT_OPTIONS_PATH = Config/$(CONFIGURATION)ExportOptions.plist
TEST_SIMULATOR = platform=iOS Simulator,name=iPhone 6s,OS=11.4

COMMIT_SHA1 ?= $(shell git rev-parse HEAD)
REPOSITORY_URL ?= https://github.com/carlossless/broad-ios
DISTRIBUTION_NOTES_FILE ?= distribution_notes.txt

PROJ_PATH = $(shell pwd)

.PHONY: all test distribute clean synx

all: $(BINDIR)/$(TARGET).ipa $(BINDIR)/$(TARGET).app.dSYM.zip

### General Xcode tooling

$(BINDIR)/$(TARGET).ipa: $(BINDIR)/$(TARGET).xcarchive
	xcodebuild -exportArchive -archivePath $< -exportOptionsPlist $(EXPORT_OPTIONS_PATH) -exportPath $(@D)

$(BINDIR)/$(TARGET).app.dSYM.zip: $(BINDIR)/$(TARGET).xcarchive
	pushd $(PROJ_PATH)/$</dSYMs/ && zip -r $(PROJ_PATH)/$@ *.dSYM && popd

$(BINDIR)/$(TARGET).xcarchive:
	xcodebuild -project $(TARGET).xcodeproj -scheme $(TARGET) -configuration '$(CONFIGURATION)' clean archive -archivePath $@ DEVELOPMENT_TEAM='$(DEVELOPMENT_TEAM)'

test:
	xcodebuild -project $(TARGET).xcodeproj -scheme $(TARGET) test -destination '$(TEST_SIMULATOR)'

distribute: $(BINDIR)/$(TARGET).ipa $(BINDIR)/$(TARGET).app.dSYM.zip
	curl \
		-F "notes=<$(DISTRIBUTION_NOTES_FILE)" \
		-F "notes_type=0" \
		-F "notify=1" \
		-F "status=2" \
		-F "commit_sha=$(COMMIT_SHA1)" \
		-F "build_server_url=$(BUILD_URL)" \
		-F "repository_url=$(REPOSITORY_URL)" \
		-F "ipa=@$(word 1,$^)" \
		-F "dsym=@$(word 2,$^)" \
		-H "X-HockeyAppToken: $(HOCKEY_APP_TOKEN)" \
		https://rink.hockeyapp.net/api/2/apps/upload

clean:
	rm -rf $(BINDIR)

synx:
	$(BUNDLE) synx -p $(TARGET).xcodeproj
