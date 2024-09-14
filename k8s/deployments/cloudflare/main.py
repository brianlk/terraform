#!/usr/bin/env python

import os
import cloudflare


bearer_token = os.environ['CF_API_TOKEN']

# Initialize the CloudFlare API client
cf = cloudflare.Cloudflare(api_token=bearer_token)
try:
    all_records = cf.dns.records.list(zone_id='1efb162a1ee83815613b57f40ec02cdd')
except cloudflare.APIError as e:
    print(f"Failed to retrieve DNS records: {e}")

for row in all_records:
    print(f"{row.id} ==> {row.name}")


print('\n' * 10)


res = cf.dns.records.get(zone_id='1efb162a1ee83815613b57f40ec02cdd', 
                           dns_record_id='1675fcd1c3bc19b3df2f97adbead2eda')

print(res)
# res = cf.dns.records.update(
#                     zone_id='1efb162a1ee83815613b57f40ec02cdd', 
#                     dns_record_id='1675fcd1c3bc19b3df2f97adbead2eda',
#                     name='forum.sgwireless.com',
#                     content='3.67.66.100',
#                     type='A'
#                     )

#cf.dns.records.create(zone_id='1efb162a1ee83815613b57f40ec02cdd',
#                       name='gateway.stage1.ctrl', 
#                       type='CNAME', 
#                       content='a09396886a2a94862ac7e807e69db1e2-466479490.ap-east-1.elb.amazonaws.com.',
#                       ttl=120
#                     )
