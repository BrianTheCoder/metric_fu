module MetricFu

  class Hotspots < Generator

    def initialize(options={})
      super
    end

    def self.verify_dependencies!
      true
    end

    
    def emit
      #TODO HOTSPOTS since this runs before metric_fu has written the file it currently runs hotspots
      #against the previous metric_fu run, not the current. Have it get the yaml from mememory of the 
      #current run in progress... Ensure that hotspots runs last of all metric_fu metrics.
      report_file = 'tmp/metric_fu/report.yml'
      if File.exists?(report_file)
        yaml = File.read(report_file)
        @analyzer = MetricAnalyzer.new(yaml)
      end
    end

    def analyze
      num = nil
      worst_items = {}
      if @analyzer
        worst_items[:files] = 
          @analyzer.worst_files(num).inject([]) do |array, worst_file|
          array << 
            {:location => @analyzer.location(:file, worst_file),
            :details => @analyzer.problems_with(:file, worst_file)}
          array
        end
        worst_items[:classes] = @analyzer.worst_classes(num).inject([]) do |array, class_name|
          location = @analyzer.location(:class, class_name)
          array << 
            {:location => location,
            :details => @analyzer.problems_with(:class, class_name)}
          array
        end
        worst_items[:methods] = @analyzer.worst_methods(num).inject([]) do |array, method_name|
          location = @analyzer.location(:method, method_name)
          array << 
            {:location => location,
            :details => @analyzer.problems_with(:method, method_name)}
          array
        end
      end

      @hotspots = worst_items
    end

    def to_h
      {:hotspots => @worst_items}
    end
  end

end
