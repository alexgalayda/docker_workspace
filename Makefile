.PHONY: all start up attach stop
CONFIG=config/config.env
include ${CONFIG}
#export CONFIG=${CONFIG}

ifeq (,$(wildcard ${XDG_RUNTIME_DIR}/docker.sock))
	DOCKER_SOCK=/var/run/docker.sock
else
	DOCKER_SOCK=${XDG_RUNTIME_DIR}/docker.sock
endif
HOST_IP=$(shell hostname -I | cut -d\  -f1)
all: test attach

start: up attach

test:
	./utils/copy_keys.sh
	./utils/gpu.sh
	$(eval export DOCKER_SOCK := ${DOCKER_SOCK})
	docker-compose -f ${COMPOSE_PATH} --env-file ${CONFIG} up --build --detach
up:
	$(eval export HOST_IP := ${HOST_IP})
	docker-compose -f ${COMPOSE_PATH} --env-file ${CONFIG} up --build --detach
attach:
	docker attach ${CONTAINER}
stop:
	docker-compose down
