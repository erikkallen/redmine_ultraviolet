require 'redmine'

require 'uv'
require 'ultraviolet_syntax_patch'
require 'redmine_class_parse_patch'
RAILS_DEFAULT_LOGGER.info "Starting redmine ultraviolet plugin"
Redmine::Plugin.register :redmine_ultraviolet do
  name "Redmine Ultraviolet Syntax highlighting plugin"
  author "Chris Gahan, Andy Bailey"
  description "Uses Textmate's syntaxes highlighters to highlight files in the source code repository."
  version "0.0.3"

  settings(:default => {
              'theme' => Uv::DEFAULT_THEME,
              'possible_values' => Uv::THEMES
             },
            :partial => 'ultraviolet_settings/redmine_ultraviolet_settings')
  # Create a dropdown list in the UI so the user can pick a theme.
  #unless UserCustomField.find_by_name('Ultraviolet Theme')
  #  UserCustomField.create(
  #    :name             => 'Ultraviolet Theme', 
  #    :default_value    => Uv::DEFAULT_THEME, 
  #    :possible_values  => Uv::THEMES,  # see ultraviolet_syntax_patch.rb
  #    :field_format     => 'list',
  #    :is_required      => true
  #  )
  #end
  config.to_prepare do 
    Setting.class_eval do
      after_save :clear_textile_cache

      private
      def clear_textile_cache
        ActionController::Base.cache_store.delete_matched(/formatted_text/)
      end
    end
  end
end
