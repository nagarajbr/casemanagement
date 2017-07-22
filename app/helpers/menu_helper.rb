module MenuHelper

# This method is used in config\navigation.rb file

    def format_url_with_paramaters (arg_url)

        if arg_url.present?
	        url = arg_url
	    	url = url.gsub 'session[:CLIENT_ID]', session[:CLIENT_ID].to_s
	    	url = url.gsub 'session[:PROGRAM_UNIT_ID]', session[:PROGRAM_UNIT_ID].to_s
	    	url = url.gsub 'session[:PROVIDER_ID]', session[:PROVIDER_ID].to_s
	    	url = url.gsub 'session[:APPLICATION_ID]', session[:APPLICATION_ID].to_s
	    	url = url.gsub 'session[:EMPLOYER_ID]', session[:EMPLOYER_ID].to_s
	    	if session[:CLIENT_ASSESSMENT_ID].blank?
				session[:CLIENT_ASSESSMENT_ID] = 0
	    	end
	    	url = url.gsub 'session[:CLIENT_ASSESSMENT_ID]',session[:CLIENT_ASSESSMENT_ID].to_s

    	end
		return url
	end
end