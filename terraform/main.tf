terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "local" {}

# skapar webbplats från HMTL-mall, flyttar till "C:\inetpub\wwwroot"
resource "local_file" "website" {
  filename = abspath("C:/inetpub/wwwroot/${var.website_filename}")
  content  = file("${path.module}/../templates/${var.website_filename}")
}
# skapar loggfil som bekräftar att projektstrukturen har skapats
resource "local_file" "setup" {
  filename = abspath("${path.module}/../logs/${var.log_filename}")
  content  = "Terraform har skapat projektstrukturen."

}

resource "null_resource" "start-service" {
  provisioner "local-exec" {
    interpreter = [ "Powershell", "-Command" ]
    command = "start-service -name W3SVC"
  
  }
  depends_on = [ local_file.setup ]
}

resource "null_resource" "stop-service" {
  provisioner "local-exec" {
    when = destroy
    interpreter = [ "Powershell", "-Command" ]
    command = "stop-service -name W3SVC"
    
  }
}

