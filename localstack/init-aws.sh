#!/bin/bash
echo "Create SQS queue"
awslocal sqs create-queue --queue-name my-queue
echo "Create SNS Topic testTopic"
awslocal sns create-topic --name my-topic
echo "Subscribe testQueue to testTopic"
awslocal sns subscribe --topic-arn arn:aws:sns:us-east-1:000000000000:my-topic --protocol sqs --notification-endpoint arn:aws:sqs:us-east-1:000000000000:my-queue
echo "Create S3 bucket"
awslocal s3api create-bucket --bucket my-bucket
