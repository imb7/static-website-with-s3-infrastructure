provider "aws" {
  region = var.region # replace with specific region you want

  default_tags {
    tags = {
      Project     = var.project_name
      Owner       = var.owner
      Environment = var.environment_name
    }
  }
}