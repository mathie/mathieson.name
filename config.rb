# Defaults for the site.
config[:domain]                = 'mathieson.name'
config[:default_email_address] = "hello@#{config[:domain]}"
config[:default_utm_source]    = config[:domain]
config[:default_utm_medium]    = 'website'
config[:default_utm_campaign]  = 'The Mathieson Family website'

# Defaults for metadata that can be overridden on pages with more specific
# content.
config[:company]          = 'Wossname Industries'
config[:company_url]      = 'https://woss.name/'
config[:title]            = 'The Mathieson Family'
config[:copyright]        = "Copyright &copy; 2015-#{Date.today.year} #{config[:company]}. All rights reserved."
config[:default_category] = 'Family'
config[:default_tags]     = [ 'Mathieson', 'Matheson', 'Mathie', 'Graeme Mathieson', 'Brian Mathieson', 'Mathieson Family' ]
config[:telephone]        = "+44 (0)7949 077744"
config[:logo]             = 'wossname-industries.png'
config[:twitter_owner]    = 'mathie'
config[:twitter_creator]  = 'mathie'

config[:default_description] = <<-TEXT
  Wossname Industries is Graeme Mathieson's software consultancy. I build
  Ruby on Rails web apps, iOS apps, and the DevOps-ian infrastructure to manage
  it all.
TEXT

# Identifiers for various other services.
config[:gtm_id]         = 'GTM-MMFMBQ'
config[:google_plus_id] = '103001545622534344345'
config[:fb_app_id]      = '651197725035649'

config[:affiliate_tags] = {
  amazon: {
    uk: 'wossname-21'
  }
}

# Pages with no layout.
[ :xml, :json, :txt ].each do |extension|
  page "/*.#{extension}", layout: false
end

# General configuration
activate :directory_indexes
activate :asset_hash
activate :gzip
activate :automatic_image_sizes
activate :syntax

activate :external_pipeline,
  name: :gulp,
  command: "npm #{build? ? 'run build' : 'start'}",
  source: 'dist/'

# Since we're managing CSS through the external asset pipeline, ignore the less
# source internally.
ignore 'stylesheets/*.less'

set :markdown_engine, :redcarpet
set :markdown, smartypants: true, with_toc_data: true, footnotes: true,
  superscript: true, fenced_code_blocks: true, tables: true,
  no_intra_emphasis: true


# Local development-specifc configuration.
configure :development do
  # Reload the browser automatically whenever files change.
  activate :livereload

  config[:url] = "http://localhost:5000"
end

# Build-specific configuration
configure :build do
  activate :minify_html

  config[:url] = "https://#{config[:domain]}"
end

activate :s3_sync do |s3|
  s3.bucket                = config[:domain]
  s3.aws_access_key_id     = ENV['AWS_ACCESS_KEY_ID']
  s3.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
end

# Set cache-control headers to revalidate pages, but everything else is
# asset-hashed, so can live forever.
caching_policy 'text/html',       max_age: 0, must_revalidate: true
caching_policy 'application/xml', max_age: 0, must_revalidate: true
caching_policy 'text/plain',      max_age: 0, must_revalidate: true

default_caching_policy max_age: (60 * 60 * 24 * 365)
