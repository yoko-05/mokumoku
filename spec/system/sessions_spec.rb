require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { create :user }

  describe 'session関係' do
    it '登録されているユーザーでログインを行い、イベント一覧ページにリダイレクトされる。' do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: 'password'
      click_button 'ログイン'

      expect(page).to have_content('もくもく会を作る')
    end

    it '登録されていないユーザーでログインを行うと、ログインページが表示される。' do
      visit login_path
      fill_in 'email', with: 'hogehogee4674@exmaple.com'
      fill_in 'password', with: 'password'
      click_button 'ログイン'

      expect(page).to have_content('Sign up')
      expect(page).not_to have_content('I agree to the Terms of Service and Privacy Policy.')
    end
  end
end
