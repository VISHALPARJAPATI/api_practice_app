class User < ApplicationRecord
    # has_secure_password takes the password, encrypts it, and stores the hashed value in the password_digest column.
    has_secure_password
    validates_presence_of :first_name, :email, :password
end

# has_secure_password

# The has_secure_password method takes the password provided by the user,
# encrypts (hashes) it using a one-way cryptographic function, and stores the resulting hashed value
# in the password_digest column of the model's database table.
# This approach enhances security by not storing the actual password in the database.

# For example:

# When creating a user with a password, like:
# user = User.create(first_name: 'testing', email: 'vishal@maropost.com', password: '1234')
# The has_secure_password internally encrypts the password '1234' and saves it into the password_digest column
# as an encrypted hash.

# We can use the following command to check if the password is valid or not:
# user.authenticate("1234")