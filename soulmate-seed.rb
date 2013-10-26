require 'rest_client'
require 'soulmate'
require 'awesome_print'
require 'json'

@user 			= "bob.boyle"
@pwd 				= "rYW34347"
@fusion_url = "https://fap0912-crm.oracleads.com"
@heroku_url = "http://fusion-crm-server.herokuapp.com/"
@page_size  = 150

def parse_fusion_objects_for_soulmate (resource, id, indexes)
	item_name = ""
	puts "=========================================================================================\n"
	puts "Querying #{@page_size} #{resource} from Fusion using Web Services (please be patient) ...\n"
	resource_response = RestClient.get "fusion-crm-server.herokuapp.com/#{resource}?ws_host=#{@fusion_url}&user=#{@user}&pwd=#{@pwd}&page_size=#{@page_size}"
	f = File.open("#{resource}.json",'w')
	puts "Parsing retrieved Fusion objects ...\n"
	objects = JSON.parse(resource_response.body)
	puts "Starting indexing "
  objects = [objects] unless objects.kind_of?(Array)
	objects.each do |obj|
		indexes.each do |index|
			unless obj["#{index[:index_name]}"].nil?
				unless obj["#{index[:index_name]}"].empty?
					item_name = obj["#{index[:index_name]}"] if index[:index_score] == 100
					soulmate_obj = { :id => obj["#{id}"], :term => obj["#{index[:index_name]}"], :score => "#{index[:index_score]}", :data => {:url => "\/#{resource}/#{obj[id]}", :subtitle => item_name, :connection => "#{index[:index_name]} = #{obj[index[:index_name]]}", :level=> 0} }
					f.write(soulmate_obj.to_json + "\n")
				end
			end
		end
	end
	puts "Loading data into redis server ...\n"
	puts "Command used = soulmate load #{resource} --redis=redis://localhost:6379/0 < #{resource}.json"
	system("soulmate load #{resource} --redis=redis://localhost:6379/0 < #{resource}.json")
ensure
	puts "closing file"
	f.close
end

indexes = {
	:leads => [
		{:index_name => "name", :index_score => 100},
		{:index_name => "owner_party_name", :index_score => 70},
		{:index_name => "primary_contact_party_name", :index_score => 75},
		{:index_name => "customer_party_name", :index_score => 80}],
	:opportunities => [
		{:index_name => "name", :index_score => 100},
		{:index_name => "target_party_name", :index_score => 90},
		{:index_name => "primary_contact_party_name", :index_score => 75}],
	:sales_parties => [
		{:index_name => "party_name", :index_score => 100}],
	:contacts => [
		{:index_name => "party_name", :index_score => 100},
		{:index_name => "email_address", :index_score => 90}]
}

puts "START"

parse_fusion_objects_for_soulmate "sales_leads", "lead_id", indexes[:leads]
parse_fusion_objects_for_soulmate "opportunities", "opty_id", indexes[:opportunities]
parse_fusion_objects_for_soulmate "sales_parties", "party_id", indexes[:sales_parties]
# CANT GET THIS TO WORK !!! parse_fusion_objects_for_soulmate "people", "party_id", indexes[:contacts]
puts "END"
