param (
    [string]$dossier # Prend dossier en premier argument de commande
)
if ([string]::IsNullOrEmpty($dossier)) { # si pas d'argument de commande
    $dossier = Read-Host "Chemin complet vers le dossier"
}
$dossier = $dossier.Replace('"', '') # supprime les guillemets de la variables dossier
# Récupère les groupes de $dossier, supprime le nom de domaine dans la sortie
((Get-Acl -Path $dossier).Access).IdentityReference -match "^DOMAIN\\" -replace "^DOMAIN\\", "" | 
# Where-Object { $_ -notmatch "^(BUILTIN\\|AUTORITE NT\\)" } | # cache les groupes de BUILTIN et AUTORITE NT
Sort-Object -Descending
