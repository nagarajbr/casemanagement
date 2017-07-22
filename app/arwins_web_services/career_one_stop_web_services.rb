# dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
# require File.join(dir, 'httparty')
class CareerOneStopWebServices
  include HTTParty
  base_uri ''

  def initialize(u, p)
    @auth = {username: u, password: p}

  end

  def get_skill_and_knowledge_gaps_between_two_occupations(options = {})
    options.merge!({basic_auth: @auth, verify: false})
    response = self.class.get('http://webservices.myskillsmyfuture.org/SkillsGap.svc/skillsgap/userid/uHJilyjTE3YGOan/currentoccupation/47215202/targetoccupation/47211100/location/0/radius/20',options)
     Rails.logger.debug("response = #{response.inspect}")
    Hash.from_xml(response.parsed_response.gsub("\n", ""))
  end

  def get_education_and_training_by_occupation(arg_occupation_code,options = {})
    options.merge!({basic_auth: @auth, verify: false})
    url = URI.encode("http://webservices.myskillsmyfuture.org/Training.svc/training/userid/uHJilyjTE3YGOan/onetcode/#{arg_occupation_code}/location/0/radius/10/start/1/end/1")
    Rails.logger.debug("-->url = #{url}")
    response = self.class.get(url,options)
    Rails.logger.debug("get_education_and_training_by_occupation --- > response = #{response.inspect}")
    #Hash.from_xml(response.parsed_response.gsub("\n", ""))
    return response
  end

  def get_job_count_by_occupation(arg_key_word,options = {})
    options.merge!({basic_auth: @auth, verify: false})
    url = URI.encode("http://webservices.myskillsmyfuture.org/JobsModule.svc/jobslist?userid=uHJilyjTE3YGOan&keyword=#{arg_key_word}&location=72205&radius=25&sortfield=rel&sortdirection=rel&startrow=1&endrow=1&days=60")
    response = self.class.get(url,options)
    Rails.logger.debug("get_job_count_by_occupation ----->response = #{response.inspect}")
    return response
    #Hash.from_xml(response.parsed_response.gsub("\n", ""))
  end




  def format_response(arg_response, arg1, arg2)
  	hash = Hash.from_xml(arg_response.parsed_response.gsub("\n", ""))
  	item_lists = hash[arg1][arg2]
   	cod_tab = []
   	item_lists.each do |item|
   		codetable_item = CodetableItem.new
   		codetable_item.short_description = item["code"].strip
      	codetable_item.long_description = item["title"].strip
      	cod_tab << codetable_item
   	end
   	# Rails.logger.debug("--> item_lists cod_tab = #{cod_tab.inspect}")
   	return cod_tab
  end

end