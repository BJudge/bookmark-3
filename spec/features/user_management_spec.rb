feature 'User sign up' do
  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, bart@example.com')
    expect(User.first.email).to eq('bart@example.com')
  end

  scenario 'requires a matching confirmation password' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
  end

  scenario 'with a password that does not match' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario " I can't sign up without an email address" do
    expect { sign_up(email: nil) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Email must not be blank')
  end

  scenario "I can't sign up with an invalid email address" do
    expect { sign_up(email: "invalid@email") }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Email has an invalid format')
  end

  scenario 'I cannot sign up with an existing email' do
    sign_up
    expect {sign_up }.to_not change(User, :count)
    expect(page).to have_content('Email is already taken')
  end
end

feature 'User Sign in' do

  let!(:user) do
    User.create(email: 'john@example.com', password: 'secret1234', password_confirmation: 'secret1234')
  end

  scenario 'with correct credentials' do
    sign_in(email: user.email, password: user.password)
    expect(page).to have_content "Welcome, #{user.email}"
  end
end

feature 'User signs out' do

  scenario 'while being signed in' do
    sign_up
    sign_in(email: 'bart@example.com', password: '1234')
    click_button 'Sign out'
    expect(page).to have_content('goodbye!')
    expect(page).not_to have_content('Welcome, test@test.com')
  end
end

feature 'Resetting Password' do
  scenario 'When I forget my password I can see a link to Reset' do
    visit '/sessions/new'
    click_link 'I forgot my password'
    expect(page).to have_content("Please enter your email address")
  end
  scenario 'When I enter my email I am told to check my inbox' do
    recover_password
    expect(page).to have_content 'Thanks, Please check your inbox for the link'
  end
  scenario 'assigned a reset token to the user when they recover' do
    sign_up
    expect{ recover_password }.to change{User.first.password_token}
  end
  it 'saves a password recovery token when we generate a token' do
    expect{user.generate_token}.to change{user.password_token}
  end
  def recover_password
    visit '/user/recover'
    fill_in :email, with: 'bart@example.com'
    click_button "Submit"
  end
end
