LOGIN=$1
PASSWORD=$2

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

echo "$LOGIN"
/usr/bin/logger "$LOGIN"
echo "$PASSWORD"
/usr/bin/logger "$PASSWORD"

NEW_CONNECT_URL="https://selfcare.wifirst.net/sessions/new"
CONNECT_URL="https://selfcare.wifirst.net/sessions"
PORTAL_URL="https://connect.wifirst.net/?perform=true"
ERROR_PORTAL_URL="https://connect.wifirst.net/login_error"


PRIV_CONNECT_URL="https://wireless.wifirst.net:8090/goform/HtmlLoginRequest"

TOKEN_RGX="s/^.*authenticity_token.*value=\"\(.*\)\" \/><\/div>/\1/p"
USERNAME_RGX="s/^.*username.*value=\"\(.*\)\" \/>/\1/p"
PASSWORD_RGX="s/^.*password.*value=\"\(.*\)\" \/>/\1/p"

COOKIES=cookies.txt



PORTAL_RESP=$(curl -sLkb $COOKIES -c $COOKIES $NEW_CONNECT_URL)
# -s = silent
# -L = autorise redirection
# -k = no secure
# -b = lire fichier de cookies et l'envoyer
# -c = fichier pour ecrire cookie de reponse
# -h = header
echo "portal: "
echo $PORTAL_RESP

TOKEN=$(echo "$PORTAL_RESP" | sed -n "$TOKEN_RGX")
echo "token: "
echo $TOKEN
echo ""

CONNECT_RESP=$(curl -sLkb $COOKIES -c $COOKIES \
	--data-urlencode "utf8=&#x2713;" \
	--data-urlencode "authenticity_token=$CSRF_TOKEN" \
	--data-urlencode "login=$LOGIN" \
	--data-urlencode "password=$PASSWORD" \
	$CONNECT_URL)
echo "connect: "
echo $CONNECT_RESP

PRIV_USERNAME=$(echo "$CONNECT_RESP" | sed -n "$USERNAME_RGX")
PRIV_PASSWORD=$(echo "$CONNECT_RESP" | sed -n "$PASSWORD_RGX")
echo "priv usr: "
echo $PRIV_USERNAME
echo "priv passwd: "
echo $PRIV_PASSWORD
echo ""

PRIV_CONNECT_RESP=$(curl -sLkb $COOKIES -c $COOKIES  \
	--data-urlencode "commit=Se connecter" \
	--data-urlencode "username=$PRIV_USERNAME" \
	--data-urlencode "password=$PRIV_PASSWORD" \
	--data-urlencode "qos_class=" \
	--data-urlencode "success_url=$URL" \
	--data-urlencode "error_url=$ERROR_PORTAL_URL" \
	$PRIV_CONNECT_URL)
echo "priv: "
echo $PRIV_CONNECT_RESP

rm $COOKIES