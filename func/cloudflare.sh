get_api_token(){
    source $HESTIA/data/users/$user/cloudflare.conf
    success=$(curl -s -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
     -H "Authorization: Bearer $TOKEN" | jq -r '.success');
     
    if [ $success != 'true' ]; then
    echo "Unable to connect to Cloudflare API"
    exit 3;
    fi
}

