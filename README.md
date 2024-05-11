# s3-terraform-aws-cicd-project

Terraform - S3 - AWS CICD

Project :

I . Need to setup terraform 
	1. Create s3 bucket
	2. Create IAM role that accesses the bucket with read permissions
	3. Store state-file in s3 bucket and lock with dynamoDB table

II . CICD pipeline 
	1. Setting AWS code pipeline
	2. Using AWS code deploy , deploy documents to s3 bucket


Description :
In this project we will create s3 bucket using terraform and create a IAM role to access this s3 bucket with read only permission. The important task is we need to store the terraform state file in another s3 bucket where we lock that state file with dynamoDB table. 
After successful completion of infrastructure, we will create cicd pipeline in AWS. When anyone from the team upload documents in private GitHub repo, then a AWS code pipeline will be triggered and deploy those documents into s3 bucket through AWS code deploy.



Procedure :
Terraform setup :

To use terraform first need to install terraform. Follow this procedure to install terraform - Click here.
Also need to install aws-cli to interact with aws .Follow this procedure for installing aws cli- Click here. 
After installing terraform and aws cli in your machine, configure aws with your machine.
Note : For access key and secret access key , you need to create them in AWS IAM -> security Credentials - > Access keys.
bash-3.2$ aws configure
AWS Access Key ID [*******************]: <Your access key>
AWS Secret Access Key [*******************]: <Your secret access key>
Default region name [**********]: ap-south-1 
Default output format [*****]: json




Terraform Backend for state file :

For every terraform architecture terraform.tfstate will be created. It consists of the whole information about the terraform configuration. 
But if we push the terraform code from your local repo to distributed repo like GitHub, your state file is also uploaded to it. There is compromise of your configuration.
To avoid this we will store that state file somewhere and protect from compromising. Here we are using s3 bucket as a state file storing purpose.
And there is one possibility that at a time many of your team members can access the state file . To avoid this conflict we are locking that state file which is stored in s3 bucket with DynamoDB table.
The backend file looks similar like this .
terraform {
  backend "s3" {
    bucket         = "s3-bucket-for-statefile-0001" 
    key            = "dev/terraform.tfstate" // path to store inside bucket
    region         = "ap-south-1" //region
    dynamodb_table = "dynamodb-table-for-locking-statefile" 
  }
}

We need to create s3 bucket and dynamoDB table and need to hard code here. While creating dynamoDB table attribute should be LockID of type string.
Now run terraform init command to initialise the terraform in this folder.


provider file creation :

We will create provider.tf file for configuring the provider and region of creation of resources.
The provider.tf file looks like this
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}


Create main.tf file and in that file write code for s3 bucket creation along with IAM read access role attachment.
In this file we will create a role after that we create a policy document regarding read only access, then create a policy by using this policy document.
After that we will attach this policy to the IAM role. 
Then while creating s3 bucket we create a policy by attaching the readonly policy role.





Resources creation :

After completion of the above steps its time to apply the configuration.
terraform validate : to validate the configuration files in that folder.

terraform plan : this command creates a plan consisting of a set of changes that will make your resources match your configuration
terraform apply : executes the configuration which we see in plan.
terraform destroy : To destroy the existing configuration.


