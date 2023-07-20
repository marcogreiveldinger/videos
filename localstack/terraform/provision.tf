provider "aws" {
  region     = "us-east-1"
  access_key = "test"
  secret_key = "test"

  # only required for non virtual hosted-style endpoint use case.
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#s3_use_path_style
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3  = "http://localhost:4566"
    sns = "http://localhost:4566"
    sqs = "http://localhost:4566"
  }
}

resource "aws_sns_topic" "example" {
  name = "tf-topic"
}

resource "aws_sqs_queue" "example" {
  name = "tf-queue"
}

resource "aws_s3_bucket" "example" {
  bucket = "tf-bucket"
}
