# Define the base directory
$baseDir = "terraform"

# Create the root directory and files
New-Item -Path $baseDir -ItemType Directory -Force
New-Item -Path "$baseDir\main.tf" -ItemType File -Force
New-Item -Path "$baseDir\variables.tf" -ItemType File -Force
New-Item -Path "$baseDir\terraform.tfvars" -ItemType File -Force

# Define module names
$modules = @("vpc", "eks", "ecr")

# Create module directories and files
foreach ($module in $modules) {
    $modulePath = "$baseDir\modules\$module"
	New-Item -Path $modulePath -ItemType Directory -Force
    New-Item -Path "$modulePath\main.tf" -ItemType File -Force
    New-Item -Path "$modulePath\variables.tf" -ItemType File -Force
    New-Item -Path "$modulePath\outputs.tf" -ItemType File -Force
}

Write-Host "Terraform project structure created successfully."