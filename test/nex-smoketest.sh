#!/bin/bash

# DIR="${BASH_SOURCE%/*}"
# if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
# . "$DIR/nex-include.sh"

# to ensure if 1 command fails.. build fail
set -e

# ensure prefix is pass in
if [ $# -lt 1 ] ; then
	echo "NEX smoketest needs prefix"
	echo "nex-smoketest.sh acceptance"
	exit
fi

PREFIX=$1

# check if doing local smoke test
if [ "${PREFIX}" != "local" ]; then
    echo "Remote Smoke Test in CF"
    STD_APP_URL=${PREFIX}
else
    echo "Local Smoke Test"
    STD_APP_URL=http://localhost:8000
fi

echo STD_APP_URL=${STD_APP_URL}

# Test: Create Products
echo "=== Creating a product id: the_odyssey ==="
curl -s -X POST  "${STD_APP_URL}/products" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"id": "the_odyssey", "title": "The Odyssey", "passenger_capacity": 101, "maximum_speed": 5, "in_stock": 10}'
echo
# Test: Get Product
echo "=== Getting product id: the_odyssey ==="
curl -s "${STD_APP_URL}/products/the_odyssey" | jq .
echo

# Test: Delete Product
echo "=== Deleting product id: the_odyssey ==="
curl -s  -X DELETE  "${STD_APP_URL}/products/the_odyssey" | jq .
echo "Deleted the_odyssey"
echo

echo
# Test: Get deleted Product
echo "=== Getting deleted product id: the_odyssey ==="
curl -s "${STD_APP_URL}/products/the_odyssey" | jq .
echo 

# Test: Create Order
echo "=== Creating Order ==="
ORDER_ID=$(
    curl -s -XPOST "${STD_APP_URL}/orders" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"order_details": [{"product_id": "the_odyssey", "price": "100000.99", "quantity": 1}]}' 
)
echo ${ORDER_ID}
ID=$(echo ${ORDER_ID} | jq '.id')

# Test: Get Order back
echo "=== Getting Order ==="
curl -s "${STD_APP_URL}/orders/${ID}" | jq .

# # Test: Create second Order
# echo "=== Creating another Order ==="
# ORDER_ID=$(
#     curl -s -XPOST "${STD_APP_URL}/orders" \
#     -H 'accept: application/json' \
#     -H 'Content-Type: application/json' \
#     -d '{"order_details": [{"product_id": "the_new_odyssey", "price": "999.99", "quantity": 2}]}' 
# )
# echo ${ORDER_ID}
# ID=$(echo ${ORDER_ID} | jq '.id')

# # Test: Get All orders back
# echo "=== Getting All Order ==="
# curl -s "${STD_APP_URL}/orders?page=0&per_page=10" | jq .
