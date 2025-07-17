module RequestHelpers
  def login_as(user)
    post sessions_path, params: { email: user.email, password: 'password123' }
  end

  def logout
    delete logout_path
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end 