# SanitizesHtml

require 'rubygems'
require 'hpricot'

module SanitizesHtml
  module HtmlStripper
    # configuration
    def self.strip(html, allow_tags, safe_attributes = {})
      doc = Hpricot(html)
      doc.traverse_all_element do |e|
        if e.is_a?(Hpricot::Elem)
          unless allow_tags.include?(e.name)
            # remove the whole tag if we don't allow it
            e.parent.replace_child e, Hpricot.make(e.inner_html)
          else
            # remove attributes considered 'unsafe'
            safe = safe_attributes[e.name]
            if safe.nil?
              safe = []
            end

            e.attributes.each do |attr|
              unless safe.include?(attr[0])
                e.remove_attribute(attr[0])
              end
            end
          end
        end
      end
      doc.to_html
    end
  end

  module ClassMethods
    def sanitizes_html(field, options={})
      options[:allowed_tags] ||= [ 'b', 'p', 'i', 'u' ]
      options[:safe_attributes] ||= {}
    
      method_name = "sanitize_html_in_#{field.to_s}".to_sym
      reader = field.to_sym
      writer = "#{field.to_s}=".to_sym

      define_method(method_name) do 
        input = self.send(reader)
        self.send(writer, HtmlStripper::strip(input, options[:allowed_tags], options[:safe_attributes]))
      end

      before_save method_name
    end
  end
end

