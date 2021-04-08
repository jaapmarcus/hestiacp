get_api_token(){
    if [ -e "$HESTIA/data/users/$user/cloudflare.conf" ]; then 
        source $HESTIA/data/users/$user/cloudflare.conf
        if [ ! -z "$CF_TOKEN" ]; then
            success=$(curl -s -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
             -H "Authorization: Bearer $CF_TOKEN" | jq -r '.success');
            if [ $success != 'true' ]; then
                echo "Unable to connect to Cloudflare API"
                exit 3;
            fi
        else
            echo "No Cloudflare token set in config"
            exit 3;
        fi
    else
        echo "No Cloudflare token set"
        exit 3;
    fi
}
