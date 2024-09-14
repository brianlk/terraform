#!/bin/zsh

. ./development.config

device_prefix="device"
common_name="/CN=device"
openssl_config_extension="usr_cert"
cert_type_diagnostic="Leaf Device"


echo "Creating ${cert_type_diagnostic} Certificate"

openssl "${algorithm}" \
        -out "${intermediate_ca_dir}/private/${device_prefix}.key.pem" \
        ${key_bits_length}

echo "Create the ${cert_type_diagnostic} Certificate Request"

openssl req -config "${openssl_intermediate_config_file}" \
        -key "${intermediate_ca_dir}/private/${device_prefix}.key.pem" \
        -subj "${common_name}" \
        -new -sha256 -out "${intermediate_ca_dir}/csr/${device_prefix}.csr.pem"

openssl ca -batch -config "${openssl_intermediate_config_file}" \
            -passin pass:${intermediate_password} \
            -extensions "${openssl_config_extension}" \
            -days ${days_till_expire} -notext -md sha256 \
            -in "${intermediate_ca_dir}/csr/${device_prefix}.csr.pem" \
            -out "${intermediate_ca_dir}/certs/${device_prefix}.cert.pem"

echo "Verify signature of the ${cert_type_diagnostic}" \
         " certificate with the signer"

openssl verify \
            -CAfile "${intermediate_ca_dir}/certs/${ca_chain_prefix}.cert.pem" \
            "${intermediate_ca_dir}/certs/${device_prefix}.cert.pem"

echo "${cert_type_diagnostic} Certificate Generated At:"
echo "----------------------------------------"
echo "    ${intermediate_ca_dir}/certs/${device_prefix}.cert.pem"
echo ""

openssl x509 -noout -text \
        -in "${intermediate_ca_dir}/certs/${device_prefix}.cert.pem"
