API_PATH=$(python3 -c 'import docker.api; print(docker.api.container.__file__)')
patch -N -u $API_PATH -i ./utils/container.patch
rm -f $API_PATH.rej
