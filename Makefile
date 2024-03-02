# PODMAN_BIN's and tools
PODMAN_BIN?=$(shell which podman)
SKOPEO_BIN?=$(shell which skopeo)

# FETCHMAIL_IMAGE_REGISTRY_NAME
# Defines the name of the new container to be built using several variables.
FETCHMAIL_IMAGE_REGISTRY_NAME:=docker.io
FETCHMAIL_IMAGE_REGISTRY_USER:=volkerraschek

FETCHMAIL_IMAGE_NAMESPACE?=${FETCHMAIL_IMAGE_REGISTRY_USER}
FETCHMAIL_IMAGE_NAME:=postfixadmin-fetchmail
FETCHMAIL_IMAGE_VERSION?=latest
FETCHMAIL_IMAGE_FULLY_QUALIFIED=${FETCHMAIL_IMAGE_REGISTRY_NAME}/${FETCHMAIL_IMAGE_NAMESPACE}/${FETCHMAIL_IMAGE_NAME}:${FETCHMAIL_IMAGE_VERSION}


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
	- ${PODMAN_BIN} image rm ${BASE_IMAGE_FULL}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${FETCHMAIL_IMAGE_REGISTRY_PASSWORD} | ${PODMAN_BIN} login ${FETCHMAIL_IMAGE_REGISTRY_NAME} --username ${FETCHMAIL_IMAGE_REGISTRY_USER} --password-stdin
	${PODMAN_BIN} push ${FETCHMAIL_IMAGE_FULLY_QUALIFIED}
	${PODMAN_BIN} logout ${FETCHMAIL_IMAGE_FULLY_QUALIFIED}

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