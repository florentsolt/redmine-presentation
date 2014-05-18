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

