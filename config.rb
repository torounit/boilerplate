require 'autoprefixer-rails'
require 'csso'


on_stylesheet_saved do |file|
  css = File.read(file)
  File.open(file, 'w') do |io|
    io << AutoprefixerRails.process(css)
  end
end

css_dir = 'assets/stylesheets'
sass_dir = 'assets/sass'
images_dir = 'assets/images'
fonts_dir = 'assets/fonts'
javascripts_dir = 'assets/javascripts'
enable_sourcemaps = true
sass_options = { :sourcemap => true }
output_style = :nested
line_comments = (environment == :production) ? false : true
relative_assets = false
add_import_path 'vendor/assets/bower_components/'
