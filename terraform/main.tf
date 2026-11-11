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

# Deklarerar en resurs terraform ska hantera
# null_resource = låter mig koppla körning av kommandon till terraform utan skapa infrastruktur
# start-service är namnet som är valt
resource "null_resource" "start-service" {
  # Gör det möjligt att köra externa kommandon eller skript lokalt på datorn där terraform körs
  provisioner "local-exec" {
  # anger vilket program som ska tolka kommandot
  # -command talar om för powershell att nästa argument är ett kommando
    interpreter = [ "Powershell", "-Command" ]
    #anger vilket powershell kommando som ska köras
    command = "start-service -name W3SVC"
  
  }
}

resource "null_resource" "stop-service" {
  provisioner "local-exec" {
    # villkor att den körs när terraform destroy körs
    when = destroy
    interpreter = [ "Powershell", "-Command" ]
    command = "stop-service -name W3SVC"
    
  }
}

