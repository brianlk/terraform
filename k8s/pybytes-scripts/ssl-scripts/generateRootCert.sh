#!/bin/sh
. $1

COLOR_GREEN='\033[0;32m'
NO_COLOR='\033[0m'

rm -rf ${root_ca_dir}

mkdir -p ${root_ca_dir}/csr
mkdir -p ${root_ca_dir}/private
mkdir -p ${root_ca_dir}/certs
mkdir -p ${root_ca_dir}/newcerts

touch ${root_ca_dir}/index.txt

echo 01 > ${root_ca_dir}/serial

common_name="/CN=${root_common_name}"
password_cmd=" -aes256 -passout pass:${root_password} "

echo "${COLOR_GREEN}Creating the Root CA Private Key${NO_COLOR}"
openssl $algorithm \
        ${password_cmd} \
        -out "${root_ca_dir}/private/${root_ca_prefix}.key.pem" \
        ${key_bits_length}

echo "${COLOR_GREEN}Creating the Root CA Certificate${NO_COLOR}"
password_cmd=" -passin pass:${root_password} "
openssl req \
        -new \
        -x509 \
        -config "${openssl_root_config_file}" \
        ${password_cmd} \
        -key "${root_ca_dir}/private/${root_ca_prefix}.key.pem" \
        -subj "${common_name}" \
        -days ${days_till_expire} \
        -sha256 \
        -extensions v3_ca \
        -out "${root_ca_dir}/certs/${root_ca_prefix}.cert.pem"
