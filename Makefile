# POSTFIXADMIN_VERSION
# Only required to install a specifiy version
POSTFIXADMIN_VERSION?=3.3.15

# PODMAN_BIN's and tools
PODMAN_BIN?=$(shell which podman)

# POSTFIXADMIN_IMAGE
POSTFIXADMIN_IMAGE_REGISTRY_HOST:=git.cryptic.systems
POSTFIXADMIN_IMAGE_REPOSITORY?=volker.raschek/postfixadmin
POSTFIXADMIN_IMAGE_VERSION?=latest
POSTFIXADMIN_IMAGE_FULLY_QUALIFIED=${POSTFIXADMIN_IMAGE_REGISTRY_HOST}/${POSTFIXADMIN_IMAGE_REPOSITORY}:${POSTFIXADMIN_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${PODMAN_BIN} build \
		--build-arg POSTFIXADMIN_VERSION=${POSTFIXADMIN_VERSION} \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${POSTFIXADMIN_IMAGE_FULLY_QUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${PODMAN_BIN} image rm ${POSTFIXADMIN_IMAGE_FULLY_QUALIFIED}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${POSTFIXADMIN_IMAGE_REGISTRY_PASSWORD} | ${PODMAN_BIN} login ${POSTFIXADMIN_IMAGE_REGISTRY_NAME} --username ${POSTFIXADMIN_IMAGE_REGISTRY_USER} --password-stdin
	${PODMAN_BIN} push ${POSTFIXADMIN_IMAGE_FULLY_QUALIFIED}
	${PODMAN_BIN} logout ${POSTFIXADMIN_IMAGE_REGISTRY_HOST}

# PUSH CONTAINER IMAGE TO DOCKER
# ==============================================================================
PHONY+=container-image/push-to-docker-daemon
container-image/push-to-docker-daemon:
	${PODMAN_BIN} push ${POSTFIXADMIN_IMAGE_FULLY_QUALIFIED} docker-daemon:${POSTFIXADMIN_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}
