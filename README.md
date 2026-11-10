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

An important part of the work is coordinating PowerShell and Terraform so that files and the IIS service are handled in the right order. Terraform makes file management repeatable, while PowerShell gives the user a simple way to choose an action and check the result.

The project is still under development. Before use, the script paths and functions should be checked for consistency; for example, the main script refers to `Set-IISwebsite.ps1`, which is not present among the project files.

## GitHub Link

[https://github.com/Allx85/IaC-IIS](https://github.com/Allx85/IaC-IIS)
