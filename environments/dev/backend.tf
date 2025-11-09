# remote backend configuration
# backend do not support variable interpolation, so hardcoding values here
# values are manually imported from `bootstrap/backend/backend-outputs.json` (see README/backend_instructions)

terraform {
  backend "s3" {
    bucket       = "yourprojectname-dev-ibrahim-remote-backend"
    key          = "projectname/dev/terraform.tfstate"
    region       = "us-east-1" # region where the s3 bucket for terraform state is located
    encrypt      = true
    use_lockfile = true
  }
}
    