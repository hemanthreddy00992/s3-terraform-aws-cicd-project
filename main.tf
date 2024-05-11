
# Create an IAM role
resource "aws_iam_role" "s3_read_role" {
  name               = "s3_read_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "s3.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Define a read-only policy for S3 bucket
data "aws_iam_policy_document" "s3_read_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::example-bucket-name/*", "arn:aws:s3:::example-bucket-name"]
  }
}

# Create an IAM policy from the policy document
resource "aws_iam_policy" "s3_read_policy" {
  name        = "s3_read_policy"
  description = "Provides read-only access to S3 bucket"
  policy      = data.aws_iam_policy_document.s3_read_policy.json
}

# Attach the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "s3_read_attachment" {
  name       = "s3_read_attachment"
  roles      = [aws_iam_role.s3_read_role.name]
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

# Create the S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "s3-terraform-aws-cicd-project"  # Specify your bucket name

  # Attach IAM policy to the bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        AWS = aws_iam_role.s3_read_role.arn
      },
      Action    = ["s3:GetObject", "s3:ListBucket"],
      Resource  = ["arn:aws:s3:::example-bucket-name/*", "arn:aws:s3:::example-bucket-name"]
    }]
  })
}

