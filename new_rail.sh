#!/usr/bin/env bash
#
# Generate new rails server
#
#


project="restingrail"


rm -rf $project
rails new $project --api
cd $project

echo "gem 'elasticsearch'" >> Gemfile
bundle install
rm -rf ./bin
rake app:update:bin
#bundle install --binstubs

# [  
#    {  
#       "sid":"1",
#       "cid":"1",
#       "signature":"[OSSEC] Interface entered in promiscuous(sniffing) mode.",
#       "signature_gen":"10001",
#       "signature_id":"5104",
#       "signature_rev":"1",
#       "timestamp":"2018-11-02 19:32:58",
#       "unified_event_id":"1",
#       "unified_event_ref":"1",
#       "unified_ref_time":"2018-11-02 19:32:58",
#       "priority":"8",
#       "class":"",
#       "status":"0",
#       "src_ip":"0",
#       "dst_ip":"0",
#       "src_port":null,
#       "dst_port":null,
#       "icmp_type":null,
#       "icmp_code":null,
#       "ip_proto":"0",
#       "ip_ver":"0",
#       "ip_hlen":"0",
#       "ip_tos":"0",
#       "ip_len":"0",
#       "ip_id":"0",
#       "ip_flags":"0",
#       "ip_off":"0",
#       "ip_ttl":"0",
#       "ip_csum":"0",
#       "last_modified":null,
#       "last_uid":null,
#       "abuse_queue":null,
#       "abuse_sent":null
#    }
# ]

./bin/rails generate model Elastic \
	sid:string \
	cid:string \
	signature:string \
	signature_gen:string \
	signature_id:string \
	signature_rev:string \
	timestamp:string \
	unified_event_id:string \
	unified_event_ref:string \
	unified_ref_time:string \
	priority:string \
	class:string \
	status:string \
	src_ip:string \
	dst_ip:string \
	src_port:string \
	dst_port:string \
	icmp_type:string \
	icmp_code:string \
	ip_proto:string \
	ip_ver:string \
	ip_hlen:string \
	ip_tos:string \
	ip_len:string \
	ip_id:string \
	ip_flags:string \
	ip_off:string \
	ip_ttl:string \
	ip_csum:string \
	last_modified:string \
	last_uid:string \
	abuse_queue:string \
	abuse_sent:string

./bin/rails db:migrate

#./bin/rails generate controller api new create update edit destroy index show
./bin/rails generate controller api v1


sed -i 's/get/put/' config/routes.rb
cp -av ../api_controller.rb app/controllers/api_controller.rb


./bin/rails server

