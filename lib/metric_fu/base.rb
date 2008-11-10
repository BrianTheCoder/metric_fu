module MetricFu
  module Base
    class Generator
      
      def initialize(base_dir, options={})
        @base_dir = base_dir
      end      
      
      def self.generate_report(base_dir, options={})
        self.new(base_dir, options).generate_report          
      end
              
      def save_html(content, file='index')
        open("#{@base_dir}/#{file}.html", "w") do |f|
          f.puts content
        end
      end
      
      def generate_report
        save_html(generate_html)
      end
      
      def generate_html    
        analyze
        template_file = File.join(MetricFu::TEMPLATE_DIR, "#{template_name}.html.erb")
        html = ERB.new(File.read(template_file)).result(binding)        
      end
      
      def link_to_filename(name, line = nil)
        filename = File.expand_path(name)
        if PLATFORM['darwin']
          %{<a href="txmt://open/?url=file://#{filename}&line=#{line}">#{name}</a>}
        else
          %{<a href="file://#{filename}">#{name}</a>}
        end
      end      
    end
  end
end