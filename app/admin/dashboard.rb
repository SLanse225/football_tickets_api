# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Match Statistics" do
          para "Total Matches: #{Match.count}"
        end
      end

      column do
        panel "Team Statistics" do
          para "Total Teams: #{Team.count}"
        end
      end
    end
  end # content
end
