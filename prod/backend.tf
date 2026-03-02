terraform {
  backend "s3" {
    bucket         = "shivamrtcbackend"
    key            = "rtcinfrastructure/prod/terraform.tfstatee"
    region         = "us-east-1"
    dynamodb_table = "rtcbackendtable"

  }
}
