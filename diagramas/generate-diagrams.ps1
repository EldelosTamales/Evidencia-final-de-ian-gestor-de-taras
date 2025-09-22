# generate-diagrams.ps1
# PowerShell script to download plantuml.jar (if missing) and generate PNGs from .puml files in this folder.
# Requires: Java (JDK/JRE) installed and Graphviz (dot) on PATH for complex layouts.

$jar = "$PSScriptRoot\plantuml.jar"
if (-not (Test-Path $jar)) {
  Write-Host "plantuml.jar not found. Downloading..."
  $url = 'https://github.com/plantuml/plantuml/releases/latest/download/plantuml.jar'
  Invoke-WebRequest -Uri $url -OutFile $jar
}

# Verify Java
$java = (Get-Command java -ErrorAction SilentlyContinue)
if (-not $java) {
  Write-Error "Java not found in PATH. Please install JDK or JRE and ensure 'java' is available."
  exit 1
}

# Generate PNGs
Write-Host "Generating PNGs from .puml files in $PSScriptRoot"
Get-ChildItem -Path $PSScriptRoot -Filter *.puml | ForEach-Object {
  $puml = $_.FullName
  Write-Host "Rendering $($_.Name)..."
  & java -jar $jar -tpng $puml
}

Write-Host "Done. PNGs generated next to each .puml file."