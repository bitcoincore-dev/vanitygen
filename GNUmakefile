PLATFORM=$(shell uname -s)
ifeq ($(PLATFORM),linux-musl)
#Alpine Linux context

else

ifeq ($(PLATFORM),Darwin*)
#Detect Mac
OPENCL_LIBS=-framework OpenCL

else
#Else Assume Linux
OPENCL_LIBS=-lOpenCL

endif
endif

# If you see pwd_unknown showing up, this is why. Re-calibrate your system.
PWD ?= pwd_unknown

# PROJECT_NAME defaults to name of the current directory.
# should not to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

# Note. If you change this, you also need to update docker-compose.yml.
# only useful in a setting with multiple services/ makefiles.
SERVICE_TARGET := main

# if vars not set specifially: try default to environment, else fixed value.
# strip to ensure spaces are removed in future editorial mistakes.
# tested to work consistently on popular Linux flavors and Mac.
ifeq ($(user),)
# USER retrieved from env, UID from shell.
#HOST_USER ?= $(strip $(if $(USER),$(USER),nodummy))
#Always root
HOST_USER ?= root
#HOST_UID ?= $(strip $(if $(shell id -u),$(shell id -u),4000))
HOST_UID ?= $(strip $(if $(shell id -u),$(shell id -u),0))
else
# allow override by adding user= and/ or uid=  (lowercase!).
# uid= defaults to 0 if user= set (i.e. root).
HOST_USER = $(user)
HOST_UID = $(strip $(if $(uid),$(uid),0))
endif

THIS_FILE := $(lastword $(MAKEFILE_LIST))
CMD_ARGUMENTS ?= $(cmd)

# export such that its passed to shell functions for Docker to pick up.
VERSION:=3.11.6
export VERSION
export PROJECT_NAME
export HOST_USER
export HOST_UID

# all our targets are phony (no files to check).
.PHONY: docker-$(PROJECT_NAME)-shell docker-$(PROJECT_NAME)-help docker-$(PROJECT_NAME)-build docker-$(PROJECT_NAME)-rebuild docker-$(PROJECT_NAME)-clean docker-$(PROJECT_NAME)-prune

# suppress makes own output
#.SILENT:

# Regular Makefile part for buildpypi itself
docker-help: docker-$(PROJECT_NAME)-help

docker-$(PROJECT_NAME)-help:
	@echo ''
	@echo 'Usage: make [TARGET] [EXTRA_ARGUMENTS]'
	@echo 'make docker-*'
	@echo '  docker-shell    	run docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  docker-build    	build docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  docker-clean    	remove docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  docker-prune    	shortcut for docker system prune -af. Cleanup inactive containers and cache.'
	@echo ''
	@echo 'Within VM:'
	@echo 'make all'

docker-shell: docker-$(PROJECT_NAME)-shell

docker-$(PROJECT_NAME)-shell:
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) bash
else
	# run the command
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) bash -c "$(CMD_ARGUMENTS)"
endif

docker-build: docker-$(PROJECT_NAME)-build

docker-$(PROJECT_NAME)-build:
	docker-compose build $(SERVICE_TARGET)

docker-clean: docker-$(PROJECT_NAME)-clean

docker-$(PROJECT_NAME)-clean:
	# remove created images
	@docker-compose -p $(PROJECT_NAME)_$(HOST_UID) down --remove-orphans --rmi all 2>/dev/null \
	&& echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" removed.' \
	|| echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" already removed.'

docker-prune: docker-$(PROJECT_NAME)-prune

docker-$(PROJECT_NAME)-prune:
	docker system prune -af

#######################
-include Makefile
