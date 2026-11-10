# visa ett värde som resultat, namnet är website_url
# visar efter terraform apply: website_url = "http://localhost"
output "website_url" {
    description = "URL to website"
    value = "http://localhost"
    
}