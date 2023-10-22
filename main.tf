// AWS provider configuration
provider "aws" {
  // AWS region where resources will be created
  region = "us-east-1"
}


variable "pgp_key" {
  description = "The PGP key used to encrypt the IAM user password"
}


// AWS EC2 instance resource
resource "aws_instance" "deep-racer-ec2" {
  // Amazon Machine Image (AMI) ID
  ami  = "ami-0ff834984748eaef2"
  
  // Type of instance to launch
  instance_type = "g4dn.2xlarge"
  
  // Tags to assign to the instance
  tags = {
    // Name tag for the instance
    Name = "deep-racer-machine"
  }

  // IAM instance profile to associate with the EC2 instance
  iam_instance_profile = aws_iam_instance_profile.s3_access_profile.name

  subnet_id               = aws_subnet.deep_racer_subnet.id  // Associate with the created subnet

}

resource "aws_iam_role" "s3_access_role" {
  name = "S3AccessRole"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
    }
    EOF
}



resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "S3AccessProfile"
  role = aws_iam_role.s3_access_role.name
}


resource "aws_vpc" "deep_racer_vpc" {
  cidr_block = "10.0.0.0/16"  // This CIDR block does not overlap with 192.168.2.0/24
}

resource "aws_subnet" "deep_racer_subnet" {
  vpc_id                  = aws_vpc.deep_racer_vpc.id
  cidr_block              = "10.0.1.0/24"  // A subnet within the VPC's CIDR block
  availability_zone       = "us-east-1a"  // Adjust to match your desired AZ within us-east-1
}




resource "aws_iam_role_policy_attachment" "s3_access_policy_attachment" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_policy" "ec2_access_policy" {
  name        = "EC2AccessPolicy"
  description = "Policy to allow basic EC2 actions"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy to allow access to specified S3 bucket"
  policy      = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [
            "s3:GetObject",
            "s3:PutObject"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::aws-deep-racer/*"
        }
    ]
    }
    EOF
}

resource "aws_iam_user" "andrew" {
  name = "andrew"
}

resource "aws_iam_user_login_profile" "andrew_login_profile" {
  user    = aws_iam_user.andrew.name
  pgp_key = var.pgp_key
}

resource "aws_iam_access_key" "andrew_access_key" {
  user = aws_iam_user.andrew.name
}



