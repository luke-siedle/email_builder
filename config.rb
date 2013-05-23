# Add handlebars 
require 'handlebars'
require 'template'

module PremailerMod
  class << self
    def registered(app)
      app.after_build do |builder|
        premailer = Premailer.new('build/index.html', :warn_level => Premailer::Warnings::SAFE)

        # Write the HTML output
        fout = File.open("build/index.preflighted.html", "w")
        fout.puts premailer.to_inline_css
        fout.close
      end
    end
    alias :included :registered
  end
end

::Middleman::Extensions.register(:premailer_mod, PremailerMod) 

module HandlebarsLoad
  class << self 
    def registered(app)

      app.before do

        @handlebars = Handlebars::Context.new
          
        Dir.foreach( Dir.pwd + '/source/templates/' ) do |t|
          next if t == '.' or t == '..'
          HandlebarTemplate.add_template t
        end

        $tmp = HandlebarTemplate.new
        true
      end
      
      alias :included :registered
    end
  end
end

::Middleman::Extensions.register(:handlebars_load, HandlebarsLoad) 

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

activate :handlebars_load

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"

  activate :premailer_mod
  activate :handlebars_load

end