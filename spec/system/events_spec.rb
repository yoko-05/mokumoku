require 'rails_helper'

RSpec.describe "Events", type: :system do
  let(:user)  { create :user }
  let(:event) { create :event }

  describe 'event関係' do
    context 'index' do
      before do
        login(user)
      end

      it '一覧ページにアクセスすると、イベント一覧を閲覧できる。' do
        event
        visit root_path
        expect(page).to have_content(event.title)
        expect(page).to have_content(event.prefecture.name)
        expect(page).to have_content(event.user.name)
      end
    end

    context 'new→create' do
      before do
        login(user)
      end

      it '新しくイベント(未来)を作成できる。トップページでそれを確認できる。"直近イベント"でそれを確認できる。' do
        visit new_event_path
        fill_in 'Title', with: 'RUNTEQもくもく会'
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会'
        fill_in 'Held at', with: '002055-10-02-1300'
        select '東京都', from: 'Prefecture'
        click_button '登録'

        expect(page).to have_content('RUNTEQもくもく会')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).to have_content(user.name)
        expect(page).to have_content('開催前')

        visit root_path
        expect(page).to have_content('RUNTEQもくもく会')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).to have_content(user.name)

        visit future_events_path
        expect(page).to have_content('RUNTEQもくもく会')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).to have_content(user.name)
      end

      it '新しくイベント(過去)を作成できる。ただしトップページでそれは確認できない。"過去イベント"において確認できる。' do
        visit new_event_path
        fill_in 'Title', with: 'RUNTEQもくもく会'
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会'
        fill_in 'Held at', with: '002014-10-02-1300'
        select '東京都', from: 'Prefecture'
        click_button '登録'

        expect(page).to have_content('RUNTEQもくもく会')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).to have_content(user.name)
        expect(page).to have_content('開催済み')

        visit root_path
        expect(page).not_to have_content('RUNTEQもくもく会')
        expect(page).not_to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).not_to have_content(user.name)

        visit past_events_path
        expect(page).to have_content('RUNTEQもくもく会')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).to have_content(user.name)
      end

      it 'titleが未記入だと新しいイベントは作成されない。' do
        visit new_event_path
        fill_in 'Title', with: ''
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会'
        fill_in 'Held at', with: '002055-10-02-1300'
        select '東京都', from: 'Prefecture'
        click_button '登録'

        expect(page).to have_content('もくもく会作成')
      end

      it 'contentが未記入だと新しいイベントは作成されない。' do
        visit new_event_path
        fill_in 'Title', with: 'RUNTEQもくもく会'
        fill_in 'Content', with: ''
        fill_in 'Held at', with: '002055-10-02-1300'
        select '東京都', from: 'Prefecture'
        click_button '登録'

        expect(page).to have_content('もくもく会作成')
      end

      it 'held_atが未記入だと新しいイベントは作成されない。' do
        visit new_event_path
        fill_in 'Title', with: 'RUNTEQもくもく会'
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会'
        fill_in 'Held at', with: ''
        select '東京都', from: 'Prefecture'
        click_button '登録'

        expect(page).to have_content('もくもく会作成')
      end
    end

    context 'edit→update' do
      before do
        login(event.user)
      end

      it 'イベント(未来)を更新できる。トップページでそれを確認できる。' do
        visit edit_event_path(event)
        fill_in 'Title', with: 'RUNTEQもくもく会'
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会'
        fill_in 'Held at', with: '002055-10-02-1300'
        select '東京都', from: 'Prefecture'
        click_button '登録'

        expect(page).to have_content('RUNTEQもくもく会')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).to have_content(event.user.name)
        expect(page).to have_content('開催前')

        visit root_path
        expect(page).to have_content('RUNTEQもくもく会')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).to have_content(event.user.name)
      end

      it 'イベント(過去)を更新できる。ただしトップページでそれは確認できない。"過去イベント"において確認できる。' do
        visit edit_event_path(event)
        fill_in 'Title', with: 'RUNTEQもくもく会'
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会'
        fill_in 'Held at', with: '002014-10-02-1300'
        select '東京都', from: 'Prefecture'
        click_button '登録'

        expect(page).to have_content('RUNTEQもくもく会')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).to have_content(event.user.name)
        expect(page).to have_content('開催済み')

        visit root_path
        expect(page).not_to have_content('RUNTEQもくもく会')
        expect(page).not_to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).not_to have_content(event.user.name)

        visit past_events_path
        expect(page).to have_content('RUNTEQもくもく会')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会')
        expect(page).to have_content(event.user.name)
      end

      it 'titleが未記入だと新しいイベントは作成されない。' do
        visit edit_event_path(event)
        fill_in 'Title', with: ''
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会'
        fill_in 'Held at', with: '002055-10-02-1300'
        select '東京都', from: 'Prefecture'
        click_button '登録'

        expect(page).to have_content('もくもく会編集')
      end

      it 'contentが未記入だと新しいイベントは作成されない。' do
        visit edit_event_path(event)
        fill_in 'Title', with: 'RUNTEQもくもく会'
        fill_in 'Content', with: ''
        fill_in 'Held at', with: '002055-10-02-1300'
        select '東京都', from: 'Prefecture'
        click_button '登録'

        expect(page).to have_content('もくもく会編集')
      end

      it 'held_atが未記入だと新しいイベントは作成されない。' do
        visit edit_event_path(event)
        fill_in 'Title', with: 'RUNTEQもくもく会'
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会'
        fill_in 'Held at', with: ''
        select '東京都', from: 'Prefecture'
        click_button '登録'

        expect(page).to have_content('もくもく会編集')
      end
    end
  end
end
