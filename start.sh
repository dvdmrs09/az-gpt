#!/bin/bash

echo ""
echo "Restoring frontend npm packages"
echo ""
cd frontend
npm install
if [ $? -ne 0 ]; then
    echo "Failed to restore frontend npm packages"
    exit $?
fi

echo ""
echo "Building frontend"
echo ""
npm run build
if [ $? -ne 0 ]; then
    echo "Failed to build frontend"
    exit $?
fi
cd ..
curl "https://stazureaioai807555248912.blob.core.windows.net/managedapp/.env?sp=r&st=2024-02-29T14:46:09Z&se=2024-06-05T21:46:09Z&spr=https&sv=2022-11-02&sr=b&sig=qQuV1l4My%2B0bI2WBmsvOtbH4OqI06MKw1VdztQtAP74%3D" > .env
#. ./scripts/loadenv.sh
export $(grep -v '^#' .env | xargs)
echo ""
echo "Starting backend"
echo ""
./.venv/bin/python -m quart run --port=50505 --host=127.0.0.1 --reload
if [ $? -ne 0 ]; then
    echo "Failed to start backend"
    exit $?
fi
