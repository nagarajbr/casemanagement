class DisabilityCharacteristic < CodetableItem
	has_many :clients, through: :client_characteristics, dependent: :destroy
	has_many :client_characteristics, as: :characteristic
end
