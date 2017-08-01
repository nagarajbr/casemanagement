#### 07-31-2017, MB
#### Added require statements to fix uninitialized constant CitizenshipForm::DSL error
require 'capybara/dsl'
require 'uber/options'

class CitizenshipForm < Reform::Form
	include Capybara::DSL
	include Composition
	include Reform::Form::ActiveModel
	
	#### Removed symbols from array to fix [:citizenship, :sves_type] is not a symbol nor a string error
	properties :citizenship, :sves_type, on: :client
	properties :non_citizen_type, :country_of_origin,:refugee_status,:alien_DOE,:alien_no, on: :alien

	model :client, on: :client


	#### Fixed syntax, changed validates_presence_of to validates_uniqueness_of
	validates_uniqueness_of :citizenship, message: "is required"
end
