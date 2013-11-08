require 'erb'
require 'ostruct'

module Template
  ROOT = File.join(File.dirname(__FILE__), '..', 'templates')

  def self.render(template_name, attributes={})
    opts = OpenStruct.new(attributes)

    template_file = File.join(ROOT, template_name+'.erb')
    template = File.read(template_file)
    ERB.new(template).result(opts.instance_eval { binding })
  end
end
