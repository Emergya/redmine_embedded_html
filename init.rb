#require 'response_time/application_helper_patch'

Redmine::Plugin.register :redmine_embedded_html do
  name 'Redmine Embedded HTML'
  author 'jresinas'
  description "Embedded HTML on Redmine issues"
  version '0.0.1'
  author_url 'http://www.emergya.es'

  settings :default => { 
    'html_tags' => "strong,em,ins,del,cite,code,pre,ul,ol,li,h1,h2,h3,a,img,b,i,span,div,p,hr,br",
    'html_attrs' => "href,src,alt,class,style,rel,id,title"
    },
    :partial => 'settings/embedded_html_settings'

  Redmine::WikiFormatting::Macros.register do
    desc "Embed HTML code on issues description or notes. Example:\n\n{{html\nHTML CODE\n}}"
    macro :html, :parse_args => false do |obj, args, text|
      content = text || args 
      case obj.class.name
      when 'Issue', 'Journal'
        if Setting.plugin_redmine_embedded_html['projects'].include?(obj.project.id.to_s)
          tags = Setting.plugin_redmine_embedded_html['html_tags'].present? ? Setting.plugin_redmine_embedded_html['html_tags'].split(',') : []
          attrs = Setting.plugin_redmine_embedded_html['html_attrs'].present? ? Setting.plugin_redmine_embedded_html['html_attrs'].split(',') : []
          return "#{ sanitize(CGI::unescapeHTML(content), {tags: tags, attributes: attrs}) }".html_safe
        end 
      end

      "#{textilizable(content, :obj => obj)}".html_safe
    end 
  end
end