require 'net/http'
class XmlReaderService

	def self.read_xml
		path = Dir.pwd
		# xml_content = Net::HTTP.get(URI.parse('http://www.heureka.cz/direct/xml-export/shops/heureka-sekce.xml'))
		# xml_content = Net::HTTP.get("#{Dir.pwd}"+"/client_details.xml")
		xml_content = File.open("#{Dir.pwd}/client_details.xml").read
		data = Hash.from_xml(xml_content)
		# Rails.logger.debug("path = #{path}")
		# Rails.logger.debug("data.inspect = #{data.inspect}")
	end
end