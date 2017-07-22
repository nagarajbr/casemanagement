class ServiceAuthorizationLineItemHistory < ActiveRecord::Base
has_paper_trail :class_name => 'SerizAuthLineItemHistoryVersion',:on => [:update, :destroy]

end
