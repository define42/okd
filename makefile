all:
	DOCKER_BUILDKIT=1 docker build --progress=plain --target export -t skod . --output out
