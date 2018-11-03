
require "elasticsearch"


class ApiController < ApplicationController
  def v1
		# POST body is "params"
		# I wished they made that easier to find
		#puts params

		# Create elasticsearch client
		es_host = "localhost:9200"
		client = Elasticsearch::Client.new url: es_host, log: true
	
		client.create index: "snort_events",
									type: "doc",
									body: params

		render :json => {"message": "Cool beans"}
  end
end
