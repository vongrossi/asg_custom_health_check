#!/bin/bash
URL="http://localhost:9090/metrics"

INSTANCE=$(curl http://169.254.169.254/latest/meta-data/instance-id)
AWS_DEFAULT_REGION=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}')

STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

health_check() {
    if [ $STATUS -eq 200 ]; then
        echo "OK"
    else
        echo "CRITICAL"
        aws autoscaling set-instance-health --instance-id $INSTANCE --region $AWS_DEFAULT_REGION --health-status Unhealthy

    fi
}

health_check
