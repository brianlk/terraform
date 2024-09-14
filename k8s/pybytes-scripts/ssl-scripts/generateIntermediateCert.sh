#!/bin/sh
. $1

COLOR_GREEN='\033[0;32m'
NO_COLOR='\033[0m'

common_name="/CN=${intermediate_common_name}"
password_cmd="-aes256 -passout pass:${intermediate_password}"

echo "${COLOR_GREEN}Creating the Intermediate Device CA${NO_COLOR}"
openssl $algorithm \
        ${password_cmd} \
        -out "${intermediate_ca_dir}/private/${intermediate_ca_prefix}.key.pem" \
        ${key_bits_length}

echo "${COLOR_GREEN}Creating the Intermediate Device CA CSR${NO_COLOR}"
password_cmd=" -passin pass:${intermediate_password} "
openssl req -new -sha256 \
        ${password_cmd} \
        -config "${openssl_intermediate_config_file}" \
        -subj "$common_name" \
        -key "${intermediate_ca_dir}/private/${intermediate_ca_prefix}.key.pem" \
        -out "${intermediate_ca_dir}/csr/${intermediate_ca_prefix}.csr.pem"

echo "${COLOR_GREEN}Signing the Intermediate Certificate with Root CA Cert${NO_COLOR}"
password_cmd=" -passin pass:${root_password} "
openssl ca -batch \
        -config "${openssl_root_config_file}" \
        ${password_cmd} \
        -extensions v3_intermediate_ca \
        -days ${days_till_expire} -notext -md sha256 \
        -in "${intermediate_ca_dir}/csr/${intermediate_ca_prefix}.csr.pem" \
        -out "${intermediate_ca_dir}/certs/${intermediate_ca_prefix}.cert.pem"

echo "${COLOR_GREEN}Verify signature of the Intermediate Device Certificate with Root CA${NO_COLOR}"
openssl verify \
            -CAfile "${root_ca_dir}/certs/${root_ca_prefix}.cert.pem" \
            "${intermediate_ca_dir}/certs/${intermediate_ca_prefix}.cert.pem"

cat "${intermediate_ca_dir}/certs/${intermediate_ca_prefix}.cert.pem" \
        "${root_ca_dir}/certs/${root_ca_prefix}.cert.pem" > \
        "${intermediate_ca_dir}/certs/${ca_chain_prefix}.cert.pem"