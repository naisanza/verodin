#!/usr/bin/env ruby
#
# This script does the following:
#  - Connect to sguil mysql database
#  - Identify new events
#  - POST them to a rails server
#
#
# Created: Sat Nov  3 05:31:05 UTC 2018
#

require "mysql"
require "rest-client"
require "json"


# VARS
DBHOST = "localhost"
DBPORT = "3306"
DBNAME = "securityonion_db"
DBUSER = "sguil"
DBPASS = "password"


class SguilConnector
	def initialize(dbhost, dbuser, dbpass, dbname, dbport)
		# DataBase Info
		@DBHOST = dbhost
		@DBUSER = dbuser
		@DBPASS = dbpass
		@DBNAME = dbname
		@DBPORT = dbport
	end
	def connect
		# DBPORT is running on default port
		puts "host: #{@DBHOST}"
		puts "user: #{@DBUSER}"
		puts "pass: #{@DBPASS}"
		puts "  db: #{@DBNAME}"
		puts "port: #{@DBPORT}"
		return con = Mysql.new(@DBHOST, @DBUSER, @DBPASS, @DBNAME)
	end
end


class EventHandler
	def initialize(sguil, query)
		# Use SGUIL database connection
		@CON = sguil
		@QUERY = query
	end
	def get_events
		# Get all events from sql
		# http://nsmwiki.org/Sguil_FAQ#What_tables_are_in_the_database.3F
		# SELECT * FROM securityonion_db.event;
		return @CON.query(@QUERY)
	end
end


class Postmates
	def initialize(hashes, api_endpoint)
		# Expects a Mysql::Result object
		@HASHES = hashes
		@REMOTE = api_endpoint
	end
	def get
		# Test connection to endpoint
		puts RestClient.get @REMOTE
	end
	def put
		# Send via endpoint
		@HASHES.each_hash do |hash|
			events = []
			events << hash
			events_json = events.to_json
			puts events_json
			RestClient.put @REMOTE, events_json
			#RestClient.put @REMOTE, events_json, {:content_type => :json}
		end
	end
end

query = "SELECT * FROM securityonion_db.event;"
remote = "http://localhost:3000/api/v1"

sql = SguilConnector.new(DBHOST, DBUSER, DBPASS, DBNAME, DBPORT).connect
events = EventHandler.new(sql, query).get_events()
#get = Postmates.new(events, remote).get
post = Postmates.new(events, remote).put


sql.close

