class AlterProviderTable < ActiveRecord::Migration
  def up
  	change_column :providers, :provider_mailing_state, 'integer USING CAST(provider_mailing_state AS integer)'
  end
end
