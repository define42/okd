all:
	DOCKER_BUILDKIT=1 docker build --target export -t skod . --output out
