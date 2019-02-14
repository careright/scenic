module Scenic
  # @api private
  class Definition
    def initialize(name, version)
      @name = name
      @version = version.to_i
    end

    def to_sql
      content = File.read(full_path)
      if content.empty?
        raise "Define view query in #{path} before migrating."
      end
      @erb ? ERB.new(content).result : content
    end

    def full_path
      plain = Rails.root.join(path)
      erb = Rails.root.join(path_erb)
      if File.exist?(erb)
        raise "#{path} and #{path_erb} must not both exist" if File.exist?(plain)
        @erb = true
        erb
      else
        @erb = false
        plain
      end
    end

    def path
      File.join("db", "views", filename)
    end

    def path_erb
      "#{path}.erb"
    end

    def version
      @version.to_s.rjust(2, "0")
    end

    private

    def filename
      "#{@name}_v#{version}.sql"
    end
  end
end
