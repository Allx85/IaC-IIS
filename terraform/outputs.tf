# visa ett värde som resultat, namnet är website_url
# visar efter terraform apply: website_url = "http://localhost"
output "website_url" {
    # beskrivning, bra för dokumentation
    description = "URL to website"
    value = "http://localhost"
    
}