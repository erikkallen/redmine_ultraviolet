module Redmine
  module WikiFormatting
    module Textile
      class Formatter < RedCloth3
	       # Patch to add code highlighting support to RedCloth
        def smooth_offtags( text )
          unless @pre_list.empty?
            ## replace <pre> content
            text.gsub!(/<redpre#(\d+)>/) do
              content = @pre_list[$1.to_i]
              if content.match(/<code\s+class="([\w\-\_\+]+)">\s?(.+)/m)
                content = "<code class=\"#{$1} syntaxhl\">" + 
                  Redmine::SyntaxHighlighting.highlight_by_language($2, $1)
              end
              content
            end
          end
        end
     end
   end
  end
end
