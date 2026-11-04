output "website_location" {
    description = "Location of the generated website"
    value = local_file.website.filename
    
}