module LocaleSwitchHelper
  
  def link_to_locale(*args)
    options = args.extract_options!
    locale = args.first
    name = args.second
    case action_name()
    when "create" ; action = "new"
    when "update" ; action = "edit"
    else  action = action_name()
    end
    url = "/#{locale}" + url_for(:controller => controller_name(), :action => action)
    
    link_to name, url, options
  end
  
end