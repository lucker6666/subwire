module Subwire
  module RSpecHelper
    def login(user)
      post login_path, login: user.email, password: user.password
    end

    def current_user
      subject.send(:current_user)
    end
  end
end