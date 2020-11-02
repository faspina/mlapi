#!/bin/bash

docker run -d --name="mlapi" \
--privileged="true" \
-p 5000:5000/tcp \
-e TZ="America/Chicago" \
-e SHMEM="50%" \
-e PUID="99" \
-e PGID="100" \
-e INSTALL_YOLOV3="1" \
-v "./":"/config":rw \
faspina1/mlapi