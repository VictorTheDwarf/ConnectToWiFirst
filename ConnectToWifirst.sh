URL="http://www.example.org"

# Effectuer la requête avec curl et récupérer le code de retour HTTP
HTTP_CODE=$(curl -G -s -o /dev/null --write-out "{response_code}" "$URL")

# Vérifier le code de retour
if [[ "$HTTP_CODE" -eq 200 || "$HTTP_CODE" -eq 302 ]]; then
    echo "Internet available"
else
    echo "Proxy detected"
fi