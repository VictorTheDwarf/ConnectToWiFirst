URL="http://www.example.org"

# Effectuer la requête avec curl et récupérer le code de retour HTTP
HTTP_CODE=$(curl -G -s -o /dev/null --write-out "%{response_code}" "$URL")

echo "$HTTP_CODE"