## usersテーブルにgenderカラム追加

    $ rails g migration AddGenderToUsers

マイグレーションファイル修正

    class AddGenderToUsers < ActiveRecord::Migration[6.1]
        def change
            add_column :users, :gender, :integer, default: 0
        end
    end

更新

    rails db:migrate

enumを宣言

    class User < ApplicationRecord
        enum gender: {other: 0 , man: 1, woman: 2}
    end

日本語化

    config/locals/ja.yml
    ja:
        enums:    
            user:
                gender:
                    other: その他
                    man: 男性
                    woman: 女性

users_controllerのuser_paramsにgenderを追加

ユーザー登録時に、セレクト形式で性別登録できるようにする


# eventsテーブルにonly_womanカラム追加

    $ rails g migration AddOnryWomanToEvents

マイグレーションファイル修正

    class AddOnryWomanToEvents < ActiveRecord::Migration[6.1]
        def change
            add_column :events, :only_woman, :boolean, default: false
        end
    end

    ※真（true）か偽（false）のどちらかの値が入るため、boolean型にする

更新

    $ rails db:migrate


# イベント作成画面にOnly womanのチェックボックスにチェックを入れるだけで女性限定イベントを作できる。

    app/views/events/_form.html.erb
    <% if current_user&.woman? %>
        <div class="mb-3">
            <%= f.check_box :only_woman, { value: "true"}, class: 'form-check-label', for:'flexCheckDefault' %>
            <%= f.label :only_woman %>
        </div>
    <% end %>


    app/models/event.rb
    scope :only_woman, -> { where(only_woman: true) }

    def woman_only?
        only_woman
    end

    def can_attend?(user)
        return true unless woman_only?
        user&.woman?
    end


# ユーザーが女性以外の場合、イベント作成時にOnly womanは表示されず、女性限定イベントが作成できない。

    app/controllers/events_controller.erb
    def create
        @event = current_user.events.build(event_params)

            if current_user.woman? && params[:event][:only_woman] == "1"
                @event.only_woman = true
            end

    〜〜略〜〜

    def event_params
        params.require(:event).permit(:only_woman, :title, :content, :held_at, :prefecture_id, :thumbnail)
    end

# 女性限定イベントは一覧・詳細画面にて「女性限定」が表記される。

    app/views/events/_event.html.erb
    <div class="col">
        <div class="card h-100">
            <% if event&.woman_only? %>
                <span class="badge bg-secondary">女性限定</span>
            <% end %>

    app/views/events/show.html.erb
    <h5 class="m-0">
        <% if @event&.woman_only? %>
            <span class="badge bg-secondary">女性限定</span>
        <% end %>


# 女性限定イベントには女性のみが参加できる。

参加者のコントローラーを修正

    app/controller/events/attendances_controller.rb
    def create
        @event = Event.find(params[:event_id])

        if @event.only_woman? && !current_user.woman?
            redirect_back(fallback_location: root_path, alert: '女性限定のイベントです')
            return
        end


# 女性以外の場合、女性限定イベントの詳細ページを開いた際に「このもくもく会に参加する」が表示されない。

    app/views/events/show.html.erb
    <% elsif !@event.only_woman? || current_user.woman? %>
        <%= link_to 'このもくもく会に参加する',
                    event_attendance_url(@event),
                    class: 'btn btn-primary',
                    method: :post,
                    data: { confirm: '申し込みます' }
         %>
    <% end %>