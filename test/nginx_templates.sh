#!/bin/bash
# create a new temp user
v-add-user 'hestia101' "1234test" "info@hestiacp.com" 
v-add-web-domain 'hestia101' 'test.hestiacp.com'
for template in $(v-list-web-templates plain)
do
    v-change-web-domain-tpl 'hestia101' 'test.hestiacp.com' "$template"
    echo "$template:"
    nginx -t > ./template.txt 
done
v-delete-user 'hestia101'