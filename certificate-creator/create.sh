#!/bin/bash
openssl genrsa 2048 > my-aws-private.key
openssl req -new -x509 -nodes -sha1 -days 3650 -extensions v3_ca -key my-aws-private.key > my-aws-public.crt
openssl pkcs12 -inkey my-aws-private.key -in my-aws-public.crt -certfile my-aws-public.crt
aws acm import-certificate --certificate file://my-aws-public.crt --private-key file://my-aws-private.key --region eu-central-1