# IaC-IIS

## Goal

This project automates the deployment and management of a local website on Windows using Internet Information Services (IIS). Its goal is to make it easy to install IIS, deploy a website, remove the deployment, and check that the service and site are available.

## Method

The project uses:

- **PowerShell** for the menu, IIS installation, and website checks.
- **DISM** to enable IIS features in Windows.
- **Terraform**, with `local` and `null` resources, to place the website file, create a log file, and start or stop the `W3SVC` service.
- **HTML** for two website templates: a standard page and a submarine-themed page.

The Terraform configuration places the site in IIS default directory `C:/inetpub/wwwroot/` and validates that an allowed template is selected.

## Results

The project includes a PowerShell menu for installing IIS, selecting and deploying a website template, removing the deployment, and checking the service and website at `http://localhost`. There are two HTML templates to choose from.

The project is intended for a Windows environment with PowerShell, Terraform, and IIS. Its execution and results have not been confirmed in other environments, which may require changes.

## Reflection

One of the most challenging parts of this project was learning how IIS installation differs between Windows client and Windows Server. On a Windows client, IIS features can be enabled with DISM, while Windows Server uses the `Install-WindowsFeature` PowerShell cmdlet. Understanding which command applies to each environment took some extra research and troubleshooting.

This helped me better understand that infrastructure automation depends on the operating system and the tools it provides. I also learned how PowerShell and Terraform can work together to install and check IIS and deploy a website.

## GitHub Link

[https://github.com/Allx85/IaC-IIS](https://github.com/Allx85/IaC-IIS)
