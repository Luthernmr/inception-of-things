#!/bin/bash

GITLAB_URL="http://localhost:8181"  
ACCESS_TOKEN="glpat-yTmzKFQNcywcZL5LGPsw"     
PROJECT_NAME="lnemor-will-iot.git"           

curl --request POST "$GITLAB_URL/api/v4/projects" \
     --header "PRIVATE-TOKEN: $ACCESS_TOKEN" \
     --data "name=$PROJECT_NAME" \
     --data "visibility=public"

PROJECT_ID=$(curl --header "PRIVATE-TOKEN: $ACCESS_TOKEN" \
                  "$GITLAB_URL/api/v4/projects?search=$PROJECT_NAME" \
                  | jq '.[0].id')
