
class Race < CodetableItem
	 has_many :client_races, dependent: :destroy

  	 has_many :clients, through: :client_races
end
