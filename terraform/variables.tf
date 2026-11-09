
#deklarerar variabel, namn och den får innehålla string(text)
variable "website_filename" {
    type = string

    #Validering, måste vara index.html eller sumbarine.html
    #contains: funktion som innehåller en lista med värden
    validation {
      condition = contains(
        ["index.html", "submarine.html"],
        #hämtar värdet från variabeln website_filename
        var.website_filename
      )
      #vid fel visa detta meddelande
      error_message = "Invanlid website template selected"
    }

}

variable "log_filename" {
    description = "Name of the log file"
    type        = string
    default     = "setup.txt"

}