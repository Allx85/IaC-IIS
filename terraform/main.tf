terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "local" {}

# skapar webbplats från HMTL-mall
resource "local_file" "website" {
  filename = abspath("${path.module}/../wwwroot/${var.website_filename}")
  content  = file("${path.module}/../templates/${var.website_filename}")
}
# skapar loggfil som bekräftar att projektstrukturen har skapats
resource "local_file" "setup" {
  filename = abspath("${path.module}/../logs/${var.log_filename}")
  content  = "Terraform har skapat projektstrukturen."

}