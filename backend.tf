terraform {
  backend "s3" {
    bucket         = "s3-bucket-for-statefile-0001" // s3 bucket name which we created already
    key            = "dev/terraform.tfstate" // path to store inside bucket
    region         = "ap-south-1" //region
    dynamodb_table = "dynamodb-table-for-locking-statefile" // name of the dynamodb table which we created already
  }
}
