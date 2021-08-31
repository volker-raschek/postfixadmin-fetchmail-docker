# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to start and run a container image.
CONTAINER_RUNTIME?=$(shell which docker)

# FETCHMAIL_IMAGE_REGISTRY_NAME
# Defines the name of the new container to be built using several variables.
FETCHMAIL_IMAGE_REGISTRY_NAME:=docker.io
FETCHMAIL_IMAGE_REGISTRY_USER:=volkerraschek

FETCHMAIL_IMAGE_NAMESPACE?=${FETCHMAIL_IMAGE_REGISTRY_USER}
FETCHMAIL_IMAGE_NAME:=fetchmail
FETCHMAIL_IMAGE_VERSION?=latest
FETCHMAIL_IMAGE_FULLY_QUALIFIED=${FETCHMAIL_IMAGE_REGISTRY_NAME}/${FETCHMAIL_IMAGE_NAMESPACE}/${FETCHMAIL_IMAGE_NAME}:${FETCHMAIL_IMAGE_VERSION}
FETCHMAIL_IMAGE_UNQUALIFIED=${FETCHMAIL_IMAGE_NAMESPACE}/${FETCHMAIL_IMAGE_NAME}:${FETCHMAIL_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${FETCHMAIL_IMAGE_FULLY_QUALIFIED} \
		--tag ${FETCHMAIL_IMAGE_UNQUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${CONTAINER_RUNTIME} image rm ${FETCHMAIL_IMAGE_FULLY_QUALIFIED} ${FETCHMAIL_IMAGE_UNQUALIFIED}
	- ${CONTAINER_RUNTIME} image rm ${BASE_IMAGE_FULL}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${FETCHMAIL_IMAGE_REGISTRY_PASSWORD} | ${CONTAINER_RUNTIME} login ${FETCHMAIL_IMAGE_REGISTRY_NAME} --username ${FETCHMAIL_IMAGE_REGISTRY_USER} --password-stdin
	${CONTAINER_RUNTIME} push ${FETCHMAIL_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}