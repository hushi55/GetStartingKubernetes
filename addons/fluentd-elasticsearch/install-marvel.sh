#!/bin/bash

export NODE_MASTER=${NODE_MASTER:-true}
export NODE_DATA=${NODE_DATA:-true}
export HTTP_PORT=${HTTP_PORT:-9200}
export TRANSPORT_PORT=${TRANSPORT_PORT:-9300}

/elasticsearch-1.5.2/bin/plugin -i elasticsearch/marvel/latest