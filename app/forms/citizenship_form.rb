class CitizenshipForm < Reform::Form
		# include DSL
		include Composition
	    include Reform::Form::ActiveModel

	    properties [:citizenship, :sves_type], on: :client
	    properties [:non_citizen_type, :country_of_origin,:refugee_status,:alien_DOE,:alien_no], on: :alien

	    model :client, on: :client


        validates_presence_of :citizenship, message: "is required "
	    #validates_presence_of :residency, message: "is required"
	end
