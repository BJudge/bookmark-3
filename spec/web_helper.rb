def sign_up(email: 'bart@example.com', password: '1234', password_confirmation: '1234')
  visit '/users/new'
  expect(page.status_code).to eq(200)
  fill_in :email,    with: email
  fill_in :password, with: password
  fill_in :password_confirmation, with: password_confirmation
  click_button 'Sign up'
end


def sign_in(email:, password:)
    visit '/sessions/new'
    fill_in :email, with: email
    fill_in :password, with: password
    click_button 'Sign in'
  end

  # def recover_password
  #   visit '/user/recover'
  #   fill_in :email, with: 'bart@example.com'
  #   click_button "Submit"
  # end
