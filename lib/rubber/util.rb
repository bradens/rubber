

module Rubber
  module Util

    def self.symbolize_keys(map)
      map.inject({}) do |options, (key, value)|
        options[key.to_sym || key] = value
        options
      end
    end
    
    def self.stringify(val)
      case val
      when String
        val
      when Hash
        val.inject({}) {|h, a| h[stringify(a[0])] = stringify(a[1]); h}
      when Enumerable
        val.collect {|v| stringify(v)}
      else
        val.to_s
      end
      
    end

    # Opens the file for writing by root
    def self.sudo_open(path, perms, &block)
      open("|sudo tee #{path} > /dev/null", perms, &block)
    end

    def self.is_rails?
      File.exist?(File.join(RUBBER_ROOT, 'config', 'boot.rb'))
    end

    def self.is_rails_gems_install?
      is_rails? && `cd #{RUBBER_ROOT}; rake -T | grep gems:install` != ''
    end

    def self.is_bundler?
      File.exist?(File.join(RUBBER_ROOT, 'Gemfile'))
    end

  end
end
