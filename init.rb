# Include hook code here

ActiveRecord::Base.class_eval do
  extend SanitizesHtml::ClassMethods
end
