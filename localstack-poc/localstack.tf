provider "aws" {
  region                      = "us-east-2"
  access_key                  = "fake"
  secret_key                  = "fake"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://s3.localhost.localstack.cloud:4566"
    ec2 = "http://localhost:4566"
    kinesis  = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "test-bucket" {
  bucket = "test-bucket"

  tags = {
    Name        = "test-bucket"
    Environment = "Dev"
  }
}

data "aws_ami" "amazon_eks_node_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon-eks-node-linux"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_eks_node_linux.id
  instance_type = "t2.micro"
 
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_kinesis_stream" "kinesis_stream" {
  name = "stream_publisher"
  shard_count = 1
  retention_period = 30

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}
