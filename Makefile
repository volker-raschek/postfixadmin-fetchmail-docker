# PODMAN_BIN's and tools
PODMAN_BIN?=$(shell which podman)

# FETCHMAIL_IMAGE
FETCHMAIL_IMAGE_REGISTRY_HOST:=git.cryptic.systems
FETCHMAIL_IMAGE_REPOSITORY?=volker.raschek/postfixadmin-fetchmail
FETCHMAIL_IMAGE_VERSION?=latest
FETCHMAIL_IMAGE_FULLY_QUALIFIED=${FETCHMAIL_IMAGE_REGISTRY_HOST}/${FETCHMAIL_IMAGE_REPOSITORY}:${FETCHMAIL_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${PODMAN_BIN} build \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${FETCHMAIL_IMAGE_FULLY_QUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${PODMAN_BIN} image rm ${FETCHMAIL_IMAGE_FULLY_QUALIFIED}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${FETCHMAIL_IMAGE_REGISTRY_PASSWORD} | ${PODMAN_BIN} login ${FETCHMAIL_IMAGE_REGISTRY_HOST} --username ${FETCHMAIL_IMAGE_REGISTRY_USER} --password-stdin
	${PODMAN_BIN} push ${FETCHMAIL_IMAGE_FULLY_QUALIFIED}
	${PODMAN_BIN} logout ${FETCHMAIL_IMAGE_REGISTRY_HOST}

# PUSH CONTAINER IMAGE TO DOCKER
# ==============================================================================
PHONY+=container-image/push-to-docker-daemon
container-image/push-to-docker-daemon:
	${PODMAN_BIN} push ${FETCHMAIL_IMAGE_FULLY_QUALIFIED} docker-daemon:${FETCHMAIL_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}
