URL="http://www.example.org"

# Effectuer la requête avec curl et récupérer le code de retour HTTP
HTTP_CODE=$(curl -G -s -o /dev/null --write-out "%{response_code}" "$URL")

# Vérifier le code de retour
if [[ "$HTTP_CODE" -eq 200 ]]; then
    echo "Internet available"
    /usr/bin/logger "Internet available"
elif [[ "$HTTP_CODE" -eq 302 ]]; then
    echo "Proxy detected"
    /usr/bin/logger "Proxy detected"
else
    echo "Internet Failure"
    /usr/bin/logger "Internet Failure"
fi