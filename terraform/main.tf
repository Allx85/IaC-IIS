terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "local" {}

resource "local_file" "website" {
  filename = abspath("${path.module}/../wwwroot/index.html")
  content  = <<-EOT
    
        <html>
            <head>
                <title>Välkommen till min hemsida</title>
            </head>
            <body>
                <h1> Min webbserver fungerar! </h1>
            </body>
        </html>
        EOT
}

resource "local_file" "setup" {
  filename = abspath("${path.module}/../logs/setup.txt")
  content  = "Terraform har skapat projektstrukturen."

}