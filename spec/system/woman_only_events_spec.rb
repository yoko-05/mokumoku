require 'rails_helper'

RSpec.describe "WomanOnlyEvents", type: :system do
  let(:user)  { create :user }
  let(:woman) { create :user, :woman_user }
  let(:event) { create :event }
  let(:woman_only_event) { create :event, :woman_only_event }

  describe '女性限定event' do
    context '女性以外のユーザーがログインした場合' do
      before do
        woman_only_event
        login(user)
      end

      it '一覧に"女性限定"の表記のイベントがある。' do
        visit root_path
        expect(page).to have_content(woman_only_event.title)
        expect(page).to have_content('女性限定')
      end

      it '"女性限定"イベントには参加できない。' do
        visit event_path(woman_only_event)
        expect(page).to have_content(woman_only_event.title)
        expect(page).to have_content('女性限定')
        expect(page).not_to have_content('このもくもく会に参加する')
      end

      it '新規イベント作成時に"Only woman"チェックボックスが表示されない。' do
        visit new_event_path
        expect(page).to have_content('もくもく会作成')
        expect(page).not_to have_content('Only woman')
      end
    end

    context '女性ユーザーがログインした場合' do
      before do
        woman_only_event
        login(woman)
      end

      it '一覧に"女性限定"の表記のイベントがある。' do
        visit root_path
        expect(page).to have_content(woman_only_event.title)
        expect(page).to have_content('女性限定')
      end

      it '"女性限定"イベントに参加できる。' do
        visit event_path(woman_only_event)
        expect(page).to have_content(woman_only_event.title)
        expect(page).to have_content('女性限定')
        expect(page).to have_content('このもくもく会に参加する')

        click_link 'このもくもく会に参加する'
      end

      it '"女性限定"イベントを作成できる。' do
        visit new_event_path
        fill_in 'Title', with: 'RUNTEQもくもく会-woman-'
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会-woman-'
        fill_in 'Held at', with: '002055-10-02-1300'
        select '東京都', from: 'Prefecture'
        find('#event_only_woman').click
        click_button '登録'

        expect(page).to have_content('RUNTEQもくもく会-woman-')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会-woman-')
        expect(page).to have_content(woman.name)
        expect(page).to have_content('開催前')
        expect(page).to have_content('女性限定')

        visit root_path
        expect(page).to have_content('RUNTEQもくもく会-woman-')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会-woman-')
        expect(page).to have_content(woman.name)
        expect(page).to have_content('女性限定')
      end

      it '"女性限定"イベントを更新できる。' do
        visit new_event_path
        fill_in 'Title', with: 'RUNTEQもくもく会-vol2-'
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会-vol2-'
        fill_in 'Held at', with: '002055-10-02-1300'
        select '東京都', from: 'Prefecture'
        click_button '登録'

        visit edit_event_path(woman.events.last)
        fill_in 'Title', with: 'RUNTEQもくもく会-woman vol2-'
        fill_in 'Content', with: '渋谷にあるRUNTEQ教室でもくもく会-woman vol2-'
        fill_in 'Held at', with: '002055-10-02-1300'
        select '東京都', from: 'Prefecture'
        find('#event_only_woman').click
        click_button '登録'

        expect(page).to have_content('RUNTEQもくもく会-woman vol2-')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会-woman vol2-')
        expect(page).to have_content(woman.name)
        expect(page).to have_content('開催前')
        expect(page).to have_content('女性限定')

        visit root_path
        expect(page).to have_content('RUNTEQもくもく会-woman vol2-')
        expect(page).to have_content('渋谷にあるRUNTEQ教室でもくもく会-woman vol2-')
        expect(page).to have_content(woman.name)
        expect(page).to have_content('女性限定')
      end
    end
  end
end
