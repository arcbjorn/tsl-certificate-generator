rm *.pm

# 1. Generate CA's private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout ca-key.pem -out ca-cert.pem -subj "/C=EA/ST=Earth/L=ClientLocation/O=Example1/OU=Security/CN=*.example.com/emailAddress=test@example.com"

echo "CA's self-signed certificate"
openssl x509 -in ca-cert.pem -noout -text

# 2. Generate web servers's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout server-key.pem -out server-req.pem -subj "/C=EA/ST=Earth/L=ServerLocation/O=Example2/OU=Security/CN=*.example.com/emailAddress=test@example.com"

# 3. Use CA's private key to sign web server's CSR and get back the signed certificate
openssl x509 -req -in server-req.pem -days 60 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile server-ext.cnf

echo "Server's signed certificate"
openssl x509 -in server-cert.pem -noout -text

# 4. Verify server's certificate
echo "Verify server's certificate"
openssl verify -CAfile ca-cert.pem server-cert.pem