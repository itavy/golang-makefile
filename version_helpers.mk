# git
GIT_CMD                ?= $(shell which git)
ifeq ($(GIT_CMD),)
$(error Please put git binary in path or set GIT_CMD env variable with full path to binary)
endif

GIT_COMMIT_HASH  = $(word 1, $(shell $(GIT_CMD) rev-parse HEAD))
GIT_COMMIT_SHORT = $(word 1, $(shell $(GIT_CMD) rev-parse --short HEAD))
GIT_TAG          = $(word 1, $(shell $(GIT_CMD) describe --tags --abbrev=0 --exact-match 2>/dev/null))
GIT_DIRTY        = $(shell test -n "`$(GIT_CMD) status --porcelain`" && echo "dirty" || echo "clean")

LDFLAGS        += -X $(PROJ_NAME)/internal/version.Version=$(BUILD_VERSION)
LDFLAGS        += -X $(PROJ_NAME)/internal/version.GitCommit=$(GIT_COMMIT_HASH)
LDFLAGS        += -X $(PROJ_NAME)/internal/version.GitShortCommit=$(GIT_COMMIT_SHORT)
LDFLAGS        += -X $(PROJ_NAME)/internal/version.GitTreeState=$(GIT_DIRTY)

info:
	 @echo "Version:           ${BUILD_VERSION}"
	 @echo "Git Tag:           ${GIT_TAG}"
	 @echo "Git Commit:        ${GIT_COMMIT_HASH}"
	 @echo "Git ShortCommit:   ${GIT_COMMIT_SHORT}"
	 @echo "Git Tree State:    ${GIT_DIRTY}"

