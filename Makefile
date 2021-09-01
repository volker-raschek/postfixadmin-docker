POSTFIXADMIN_VERSION:=3.2.4
POSTFIXADMIN_SHA512:=2bd7ae05addbaf3c6c7eebea16ec1e21b2c67c8e6161446ed82a9553c26c04e19c1ec9ce248a9b9df504df56d309590259e6f04907b04b593548028b40e40d47

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