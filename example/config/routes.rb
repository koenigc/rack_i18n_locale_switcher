ActionController::Routing::Routes.draw do |map|

  map.root :controller => :pages, :action => :home
  map.home '/home', :controller => :pages, :action => :home
  map.imprint '/imprint', :controller => :pages, :action => :imprint

end
