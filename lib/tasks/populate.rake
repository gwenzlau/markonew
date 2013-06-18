namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		50.times do |n|
			puts "[DEBUG] creating user #{n+1} of 50"
			name = Faker::Name.name
			email = "user-#{n+1}@example.com"
			password = "password"
			User.create!( name: name,
						  email: email,
						  password: password,
						  password_confirmation: password )
			
		end

		User.all.each do |user|
		puts "[DEBUG] posts for user #{user.id} of #{User.last.id}"
	    50.times do |n|
	      body = Faker::Lorem.sentence(5)
	      user.posts.create!(body: body)
	  end
	end
  end
end