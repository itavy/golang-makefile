PRECOMMIT_HOOK_FILE ?= .git/hooks/pre-commit

.PHONY: install-precommit-hook
install-precommit-hook:
	@/usr/bin/printf "%s\n" "#!/bin/sh " > $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "# Copyright 2012 The Go Authors. All rights reserved. " >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "# Use of this source code is governed by a BSD-style " >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "# license that can be found in the LICENSE file. " >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "# git gofmt pre-commit hook " >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "#" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "# To use, store as .git/hooks/pre-commit inside your repository and make sure" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "# it has execute permissions." >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "#" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "# This script does not handle file names that contain spaces." >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "" >> $(PRECOMMIT_HOOK_FILE)

	@/usr/bin/printf "%s\n" "make generate" >> $(PRECOMMIT_HOOK_FILE)

	@/usr/bin/printf "%s\n" "gofiles=\$$(git diff --cached --name-only --diff-filter=ACM | grep '\.go$$')" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "[ -z \"\$$gofiles\" ] && exit 0" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "unformatted=\$$(gofmt -l \$$gofiles)" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "[ -z \"\$$unformatted\" ] && exit 0" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "# Some files are not gofmt'd. Print message and fail." >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "echo >&2 \"Go files must be formatted with gofmt. Please run:\"" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "for fn in \$$unformatted; do" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "	echo >&2 \"  gofmt -w \$$PWD/\$$fn\"" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "done" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "" >> $(PRECOMMIT_HOOK_FILE)
	@/usr/bin/printf "%s\n" "exit 1" >> $(PRECOMMIT_HOOK_FILE)
	@chmod +x $(PRECOMMIT_HOOK_FILE)
