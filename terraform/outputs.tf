output "website_path" {
    description = "Sökväg till Webbplatsens startsida"
    value = local_file.website.filename
}

output "setup_path" {
    description = "Sökväg till setup-filen"
    value = local_file.setup.filename
}