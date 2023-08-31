require 'rails_helper'

RSpec.describe "WomanUsers", type: :system do
  let(:user)  { create :user }
  let(:woman) { create :user, :woman}
  let(:event) { create :event }

  describe 'womanがログインした場合' do
    before do
      login(woman)
      event
    end

    it '一覧ページにアクセスすると、イベント一覧にアクセスでき、イベント(一般)を閲覧できる。' do
      visit root_path
      expect(page).to have_content(event.title)
      expect(page).to have_content(event.prefecture.name)
      expect(page).to have_content(event.user.name)
    end

    it '一般イベントに参加することができる。' do
      visit event_path(event)
      expect(page).to have_content(event.title)
      expect(page).to have_content(event.user.name)
      expect(page).not_to have_content('女性限定')
      expect(page).to have_content('このもくもく会に参加する')
    end
  end
end
