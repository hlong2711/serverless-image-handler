#!/bin/bash
source ./config.sh

aws s3 sync ./regional-s3-assets/ s3://$DIST_OUTPUT_BUCKET-$REGION/$SOLUTION_NAME/$VERSION/ --acl bucket-owner-full-control