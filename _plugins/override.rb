require 'yaml'

module Jekyll

  ##
  # Loads 18F/uswds-jekyll YAML config files in ORGS_DIR and GUIDE_DIR, overriding any keys found in _data.
  # Key precedence is GUIDE_DIR, ORGS_DIR, then _data.

  class OverrideGenerator < Generator
    GUIDE_DIR = File.join("_guide", "_data")
    ORGS_DIR = File.join("_data", "orgs")

    safe true

    def generate(site)
      yamls = ['header', 'navigation', 'footer', 'theme', 'anchor'] 

      # Org-specific key values override those set in _data
      yamls.each do |y|
        if site.config['org']
          self.merge(site, File.join(ORGS_DIR, site.config['org']), y)
        end
      end

      # Guide-specific key values override anything preceding it
      yamls.each do |y|
        self.merge(site, GUIDE_DIR, y)
      end

      # TODO Address favicons.yml special case
    end

    def merge(site, dir, key)
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
