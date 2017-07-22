class CodeTable < ActiveRecord::Base
has_paper_trail :class_name => 'CodeTableVersion',:on => [:update, :destroy]

  has_many :codetable_items, dependent: :destroy

  def self.get_description(arg_id)
  	find(arg_id).description
  end
end
