POSTFIXADMIN_VERSION:=3.3.10
POSTFIXADMIN_SHA512:=e00fc9ea343a928976d191adfa01020ee0c6ddbe80a39e01ca2ee414a18247958f033970f378fe4a9974636172a5e094e57117ee9ac7b930c592f433097a7aca

# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to start and run a container image.
CONTAINER_RUNTIME?=$(shell which docker)

# POSTFIXADMIN_IMAGE_REGISTRY_NAME
# Defines the name of the new container to be built using several variables.
POSTFIXADMIN_IMAGE_REGISTRY_NAME:=docker.io
POSTFIXADMIN_IMAGE_REGISTRY_USER:=volkerraschek

POSTFIXADMIN_IMAGE_NAMESPACE?=${POSTFIXADMIN_IMAGE_REGISTRY_USER}
POSTFIXADMIN_IMAGE_NAME:=postfixadmin
POSTFIXADMIN_IMAGE_VERSION?=latest
POSTFIXADMIN_IMAGE_FULLY_QUALIFIED=${POSTFIXADMIN_IMAGE_REGISTRY_NAME}/${POSTFIXADMIN_IMAGE_NAMESPACE}/${POSTFIXADMIN_IMAGE_NAME}:${POSTFIXADMIN_IMAGE_VERSION}
POSTFIXADMIN_IMAGE_UNQUALIFIED=${POSTFIXADMIN_IMAGE_NAMESPACE}/${POSTFIXADMIN_IMAGE_NAME}:${POSTFIXADMIN_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--build-arg POSTFIXADMIN_VERSION=${POSTFIXADMIN_VERSION} \
		--build-arg POSTFIXADMIN_SHA512=${POSTFIXADMIN_SHA512} \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${POSTFIXADMIN_IMAGE_FULLY_QUALIFIED} \
		--tag ${POSTFIXADMIN_IMAGE_UNQUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${CONTAINER_RUNTIME} image rm ${POSTFIXADMIN_IMAGE_FULLY_QUALIFIED} ${POSTFIXADMIN_IMAGE_UNQUALIFIED}
	- ${CONTAINER_RUNTIME} image rm ${PHP_IMAGE_FULL}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${POSTFIXADMIN_IMAGE_REGISTRY_PASSWORD} | ${CONTAINER_RUNTIME} login ${POSTFIXADMIN_IMAGE_REGISTRY_NAME} --username ${POSTFIXADMIN_IMAGE_REGISTRY_USER} --password-stdin
	${CONTAINER_RUNTIME} push ${POSTFIXADMIN_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}