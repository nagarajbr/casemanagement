# dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
# require File.join(dir, 'httparty')
class OnetWebService
  include HTTParty
  base_uri 'https://services.onetcenter.org/ws'

  def initialize(u, p)
    @auth = {username: u, password: p}
  end

  def career_intrests_by_code_or_keyword(arg_value)
    options = {}
    options.merge!({basic_auth: @auth, verify: false})
    #fetched all the occupations based on key words ex Nurse
    url = "/mnm/search?keyword=#{arg_value}"
    response = self.class.get(url,options)
    Hash.from_xml(response.parsed_response.gsub("\n", ""))
  end

  def get_occupations(options = {})
    #fetched all the occupations from Onet
  	options.merge!({basic_auth: @auth, verify: false})
  	response = self.class.get('/online/occupations/?client=arwins&start=1&end=1110',options)
  	format_response(response, 'occupations', 'occupation')
  end

  def get_interest_profiler_questions(options = {})
    options.merge!({basic_auth: @auth, verify: false})
    response = self.class.get('/mnm/interestprofiler/questions/?client=arwins&start=1&end=60',options)
    # Rails.logger.debug("response = #{response.inspect}")
    # Rails.logger.debug("#{Hash.from_xml(response.parsed_response.gsub("\n", ""))}")
    # format_response(response, 'questions', 'question')
  end
  # def get_interest_profiler_results(options = {})
  #   options.merge!({basic_auth: @auth, verify: false})
  #   response = self.class.get('/mnm/interestprofiler/results?answers=553421321134342523523523254115342111351145453111231155343444',options)

  #   # Rails.logger.debug("response = #{response.inspect}")
  #   # Rails.logger.debug("get_interest_profiler_results data #{Hash.from_xml(response.parsed_response.gsub("\n", ""))}")
  #   # format_response(response, 'questions', 'question')
  # end

  def get_interest_profiler_job_zones(options = {})
    options.merge!({basic_auth: @auth, verify: false})
    response = self.class.get('/mnm/interestprofiler/job_zones?client=arwins',options)
    # Rails.logger.debug("response = #{response.inspect}")
    # Rails.logger.debug("get_interest_profiler_job_zones data #{Hash.from_xml(response.parsed_response.gsub("\n", ""))}")
    Hash.from_xml(response.parsed_response.gsub("\n", ""))
    # format_response(response, 'questions', 'question')
  end

  def get_interest_profiler_matching_carrers(arg_answers, arg_zone)
    options = {}
    options.merge!({basic_auth: @auth, verify: false})
    # response = self.class.get('/mnm/interestprofiler/careers?answers=553421321134342523523523254115342111351145453111231155343444',options)
    url = "/mnm/interestprofiler/careers?answers=#{arg_answers}&job_zone=#{arg_zone}"
    response = self.class.get(url,options)
    Hash.from_xml(response.parsed_response.gsub("\n", ""))
    # Rails.logger.debug("response = #{response.inspect}")
    # Rails.logger.debug("get_interest_profiler_matching_carrers data #{Hash.from_xml(response.parsed_response.gsub("\n", ""))}")
    # format_response(response, 'questions', 'question')
  end




  def get_interest_profiler_full_career_report(arg_report_code)
    options = {}
    options.merge!({basic_auth: @auth, verify: false})
    url = "/mnm/careers/#{arg_report_code}/report"
    response = self.class.get(url,options)
    Hash.from_xml(response.parsed_response.gsub("\n", ""))
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

  def get_code_description_hash(arg_code)
    options = {}
    options.merge!({basic_auth: @auth, verify: false})
    url = "/mnm/search?keyword=#{arg_code}"
    response = self.class.get(url,options)
    # Rails.logger.debug("response = #{response}")
    Hash.from_xml(response.parsed_response.gsub("\n", ""))
  end

  def get_code_description(arg_code, arg1, arg2)
    response_hash = get_code_description_hash(arg_code)
    response_hash[arg1][arg2]["title"]
  end

  def format_single_response(arg_hash, arg1, arg2)
    item_lists = arg_hash[arg1][arg2]
    cod_tab = []
    codetable_item = CodetableItem.new
    codetable_item.short_description = item_lists["code"].strip
    codetable_item.long_description = item_lists["title"].strip
    cod_tab << codetable_item
    # Rails.logger.debug("--> item_lists cod_tab = #{cod_tab.inspect}")
    # fail
    return cod_tab
  end

end