param (
    [string]$dossier # Prend dossier en premier argument de commande
)
if ([string]::IsNullOrEmpty($dossier)) { # si pas d'argument de commande
    $dossier = Read-Host "Chemin complet vers le dossier"
}
$dossier = $dossier.Replace('"', '') # supprime les guillemets de la variables dossier
# Récupère les groupes de $dossier, supprime le nom de domaine dans la sortie
((Get-Acl -Path $dossier).Access).IdentityReference -replace "^DOMAIN\\", "" | 
Where-Object { $_ -notmatch "^(BUILTIN\\|AUTORITE NT\\)" } | # cache les groupes de BUILTIN et AUTORITE NT
Group-Object | 
Where-Object { $_.Count -eq 2 } | # Sélectionne le groupe valide, c'est celui qui apparaît 2 fois
Select-Object -ExpandProperty Name | 
Sort-Object -Descending

# Créé une liste pour stocker les adresses email
$emailArray = @()

# Pour chaque Objet / utilisateur dans chaque groupe
$groups | ForEach-Object {
	"Membres de " + $groups
    Get-ADGroupMember -Identity $_ | 
    ForEach-Object {
        $user = Get-ADUser -Identity $_.SamAccountName -Properties Mail # Ajoute le mail de l'utilisateur dans l'Objet user
        $email = $user.Mail
        
        # Ajoute les adresses email dans la liste
        $emailArray += $email
        
        [PSCustomObject]@{
            Identity = $_.Name
            Login    = $_.SamAccountName
            Email    = if ($email) { $email } else { "pas de mail" }
        }
    } | Sort-Object Login | Format-Table -AutoSize
}

# Affiche la liste des adresses email séparées par un ;
$emailArray -join ';'
