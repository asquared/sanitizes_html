class Page < ActiveRecord::Base
  sanitizes_html :body, :allowed_tags => [ 'p','b','i','u','img' ], :safe_attributes => { 'img' => [ 'src' ] }
end
