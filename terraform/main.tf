terraform {
    required_providers {
        local = {
            source = "hashicorp/local"
            version = "2.4.0"
        }
    }
}

provider "local" {}

resource "local_file" "website" {
    filename = "${var.project_path}/wwwroot/index.html"
    content = <<-EOT
    
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
    filename = "${var.project_path}/logs/setup.txt"
    content = "Terraform har skapat projektstrukturen."

}