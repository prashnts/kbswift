Workspace := kbswift.xcworkspace
Scheme := kbswift
CIFORMATTER=$(shell xcpretty-travis-formatter)

.PHONY: clean all

all: debug

debug:
	xcodebuild -workspace $(Workspace) -scheme $(Scheme) build

test:
	xcodebuild -workspace $(Workspace) -scheme $(Scheme) test | xcpretty

testci:
	xcodebuild -workspace $(Workspace) -scheme $(Scheme) test | xcpretty -f $(CIFORMATTER)

clean:
	xcodebuild -workspace $(Workspace) -scheme $(Scheme) clean
