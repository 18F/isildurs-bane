require 'yaml'

module Jekyll

  ##
  # Loads 18F/uswds-jekyll YAML config files in ORGS_DIR and GUIDE_DIR, overriding any keys found in _data.
  # Key precedence is GUIDE_DIR, ORGS_DIR, then _data.

  class OverrideGenerator < Generator
    GUIDE_CONFIG_PATH = File.join("_guide", "_config.yml")
    GUIDE_DATA_DIR = File.join("_guide", "_data")
    ORGS_DATA_DIR = File.join("_data", "orgs")

    TITLE_KEY = "title"
    DESC_KEY = "description"
    URL_KEY = "url"
    GITHUB_KEY = "github_info"
    SEARCH_HANDLE_KEY = "search_site_handle"
    ORG_KEY = "org"

    safe true

    def generate(site)
      puts site.config[URL_KEY]
      self.mergeConfig(site, GUIDE_CONFIG_PATH)
      puts site.config[URL_KEY]


      # Supported uswds-jekyll YAMLs (minus file extension)
      yamls = ['header', 'navigation', 'footer', 'theme', 'anchor'] 

      # Org-specific key values override those set in _data
      yamls.each do |y|
        if site.config['org']
          self.mergeData(site, File.join(ORGS_DATA_DIR, site.config['org']), y)
        end
      end

      # Guide-specific key values override anything preceding it
      yamls.each do |y|
        self.mergeData(site, GUIDE_DATA_DIR, y)
      end

      # TODO Address favicons.yml special case

      puts site.config
    end

    def mergeConfig(site, path)
      puts "        TODO: Merged " + path

      required = ['title', 'description', 'github_info', 'search_site_handle']
      optional = [ORG_KEY]

      customizations = YAML.load_file(path)
      if customizations
        required.each do |k|
          site.config[k] = customizations[k]
        end
        
        optional.each do |k|
          if customizations.key?(k)
            site.config[k] = customizations[k]
          end
        end

        if not site.config.key?(URL_KEY)
          site.config[URL_KEY] = customizations[URL_KEY]
        end
      end
    end

    def mergeData(site, dir, key)
      begin
        path = File.join(dir, key + '.yml')
        customizations = YAML.load_file(path)
        if customizations
          site.data[key].merge!(customizations)
          puts "        Merged " + path
        end
      rescue
      end
    end
  end

end
