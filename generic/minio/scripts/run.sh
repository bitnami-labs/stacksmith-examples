#!/usr/bin/bash

sudo -H -u minio /bin/sh -c "$UPLOADS_DIR/minio server --address 0.0.0.0:8080 /data"
