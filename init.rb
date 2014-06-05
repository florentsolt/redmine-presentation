Redmine::Plugin.register :redmine_presentation do
  name 'Redmine Presentation plugin'
  author 'Florent Solt'
  description 'Presentation plugin for Redmine that transfrom wiki pages to slides'
  version '0.1'
  url 'https://github.com/florentsolt/redmine-presentation'
  author_url 'https://github.com/florentsolt/redmine-presentation'
end

module PresentationControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def presentation
      find_existing_or_new_page
      if @page.new_record?
        redirect_to :action => :edit
      else
        @content = @page.content_for_version(params[:version])
        render :layout => false
      end
    end
  end
end

# Apply the patch
require_dependency "wiki_controller"
WikiController.send(:include, PresentationControllerPatch)

# Give "presentation" same permessions as "view_wiki_pages"
Redmine::AccessControl.permission(:view_wiki_pages).instance_eval do
  @actions << "wiki/presentation"
end

Redmine::WikiFormatting::Macros.macro :slide do |obj, args, text|
  "<section>".html_safe + 
  textilizable(text, :attachments => obj.page.attachments) +
  "</section>".html_safe
end

class PresentationViewListener < Redmine::Hook::ViewListener
  # Adds javascript and stylesheet tags
  def view_layouts_base_html_head(context)
    javascript_include_tag("run.js", :plugin => "redmine_presentation")
  end
end

module Redmine::WikiFormatting::Textile::Helper
  def heads_for_wiki_formatter_with_slide
    heads_for_wiki_formatter_without_slide
    unless @heads_for_wiki_formatter_with_slide_included
      content_for :header_tags do
        javascript_include_tag('jstoolbar', :plugin => 'redmine_presentation')
      end
      @heads_for_wiki_formatter_with_slide_included = true
    end
  end

  alias_method_chain :heads_for_wiki_formatter, :slide
end
