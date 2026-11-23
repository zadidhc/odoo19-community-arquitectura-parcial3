$ErrorActionPreference = "Stop"

$commit = "b155a99fd5881fde0d5c182a523b1bd2e541f74e"

Set-Location $PSScriptRoot

if (Test-Path ".\odoo") {
    throw "La carpeta odoo ya existe. Verificar antes de continuar."
}

git -c core.longpaths=true clone `
    --depth 1 `
    --single-branch `
    --branch 19.0 `
    --no-checkout `
    https://github.com/odoo/odoo.git odoo

if ($LASTEXITCODE -ne 0) {
    throw "No se pudo clonar Odoo."
}

$actual = (git -C ".\odoo" rev-parse HEAD).Trim()

if ($actual -ne $commit) {
    git -C ".\odoo" fetch --depth 1 origin $commit

    if ($LASTEXITCODE -ne 0) {
        throw "No se pudo obtener el commit exacto."
    }
}

git -C ".\odoo" -c core.longpaths=true checkout --detach $commit

if ($LASTEXITCODE -ne 0) {
    throw "No se pudo seleccionar el commit."
}

$final = (git -C ".\odoo" rev-parse HEAD).Trim()

if ($final -ne $commit) {
    throw "El commit final no coincide."
}

if (-not (Test-Path ".\odoo\odoo-bin")) {
    throw "Falta odoo-bin."
}

Write-Host "CODIGO ODOO 19 VERIFICADO: $final" -ForegroundColor Green