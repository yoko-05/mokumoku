require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'Sign up関係' do
    context '成功系' do
      it 'Sign upを行い、ログイン処理を行うとイベント一覧ページにリダイレクトされる。' do
        visit signup_path
        fill_in 'Name', with: 'らんてくん'
        fill_in 'Email', with: 'sample@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_button '登録'

        visit login_path
        fill_in 'email', with: 'sample@example.com'
        fill_in 'password', with: 'password'
        click_button 'ログイン'

        expect(page).to have_content('もくもく会を作る')
      end

      it 'Sign up時に性別を選ばないで登録すると、その他として登録される。' do
        visit signup_path
        fill_in 'Name', with: 'らんてくん'
        fill_in 'Email', with: 'sample@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_button '登録'

        visit login_path
        fill_in 'email', with: 'sample@example.com'
        fill_in 'password', with: 'password'
        click_button 'ログイン'

        expect(page).to have_content('もくもく会を作る')
        expect(User.last.gender).to eq 'other'
      end

      it 'Sign up時に性別(男性)を選んで登録することができる。' do
        visit signup_path
        fill_in 'Name', with: 'らんてくん'
        fill_in 'Email', with: 'sample@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        select '男性', from: 'Gender'
        click_button '登録'

        visit login_path
        fill_in 'email', with: 'sample@example.com'
        fill_in 'password', with: 'password'
        click_button 'ログイン'

        expect(page).to have_content('もくもく会を作る')
        expect(User.last.gender).to eq 'man'
      end

      it 'Sign up時に性別(女性)を選んで登録することができる。' do
        visit signup_path
        fill_in 'Name', with: 'らんてくん'
        fill_in 'Email', with: 'sample@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        select '女性', from: 'Gender'
        click_button '登録'

        visit login_path
        fill_in 'email', with: 'sample@example.com'
        fill_in 'password', with: 'password'
        click_button 'ログイン'

        expect(page).to have_content('もくもく会を作る')
        expect(User.last.gender).to eq 'woman'
      end
    end

    context '失敗系' do
      it 'passwordが未入力だと。Sign upページが表示される。' do
        visit signup_path
        fill_in 'Name', with: 'らんてくん'
        fill_in 'Email', with: 'sample@example.com'
        fill_in 'Password', with: ''
        fill_in 'Password confirmation', with: 'password'
        click_button '登録'

        expect(page).to have_content('I agree to the Terms of Service and Privacy Policy.')
      end

      it 'password_confirmationが未入力だと。Sign upページが表示される。' do
        visit signup_path
        fill_in 'Name', with: 'らんてくん'
        fill_in 'Email', with: 'sample@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: ''
        click_button '登録'

        expect(page).to have_content('I agree to the Terms of Service and Privacy Policy.')
      end

      it 'password, password_confirmationが未入力だと。Sign upページが表示される。' do
        visit signup_path
        fill_in 'Name', with: 'らんてくん'
        fill_in 'Email', with: 'sample@example.com'
        fill_in 'Password', with: ''
        fill_in 'Password confirmation', with: ''
        click_button '登録'

        expect(page).to have_content('I agree to the Terms of Service and Privacy Policy.')
      end
    end
  end
end
