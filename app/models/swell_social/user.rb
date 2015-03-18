module SwellSocial

	class User < SwellMedia::User

		has_many	:notifications


	end

end