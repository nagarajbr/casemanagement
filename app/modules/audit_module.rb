module AuditModule
	def self.get_current_user
		Thread.current[:user]
	end

	def self.set_current_user=(arg_user)
		Thread.current[:user] = arg_user
	end
end