# startar terraform blocket
terraform {
  # vilken provider som ska användas, provider är tillägg(plugin)
  required_providers {
    # Hanterar filer och mappar på lokal dator
    local = {
      # Identifierar  för att hitta rätt provider i Terraform Registry
      # 
      source  = "hashicorp/local"
      # vilken version som används
      version = "2.4.0"
    }
  }
}

provider "local" {}

# Hantera en resurs från providern hasicorp/local döpt till website.
resource "local_file" "website" {
  #filens absolutasökväg, IIS standardkatalog för webbplatsens filer
  #oavsett mall heter filen index.html
  filename = "C:/inetpub/wwwroot/index.html"
  #vilket innehåll filen får,file() läser innehåll från fil
  #path.module hittar katalog terraform, oavsett vart den är
  #hämtar värdet från variabeln website_filename för godkända i listan
  content = file("${path.module}/../templates/${var.website_filename}")
}
# skapar loggfil som bekräftar att projektstrukturen har skapats

resource "null_resource" "start-service" {
  provisioner "local-exec" {
    interpreter = [ "Powershell", "-Command" ]
    command = "start-service -name W3SVC"
  
  }
}

resource "null_resource" "stop-service" {
  provisioner "local-exec" {
    when = destroy
    interpreter = [ "Powershell", "-Command" ]
    command = "stop-service -name W3SVC"
    
  }
}

