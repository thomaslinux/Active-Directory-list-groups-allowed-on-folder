@echo OFF
:: récupère tous les arguments de la commande dans une variable a
set a="%*"
:: supprime les guillements dans la variable a
set a=%a:""="%
:: exécute dossier.ps1 depuis CMD Batch en bypassant les règles de sécurité
powershell.exe -ExecutionPolicy Bypass -File "dossier.ps1" %a%
