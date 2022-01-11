#!/bin/bash

echo "To get token for accessing kind:"
echo "kubectl -n kubernetes-dashboard get secrets \$(kubectl -n kubernetes-dashboard get sa kubernetes-dashboard -ojsonpath=\"{.secrets[0].name}\") -ojsonpath=\"{.data.token}\" | echo \"\$(base64 -d)\""

docker exec -it k8s-dashboard-dev gosu user bash

