class FillablePdfForm

  attr_writer :template_path
  attr_reader :attributes

  def initialize
    fill_out
  end

  def export(output_file_path=nil)
    output_path = output_file_path || "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf" # make sure tmp/pdfs exists
    pdftk.fill_form template_path, output_path, attributes
    Rails.logger.debug("path = #{output_path}" )
    output_path
  end



  def get_field_names
    pdftk.get_field_names template_path
  end

  def template_path
    @template_path ||= "#{Rails.root}/lib/pdf_templates/#{self.class.name.gsub('Pdf', '').underscore}.pdf" # makes assumption about template file path unless otherwise specified
  end

  protected

  def attributes
    @attributes ||= {}
  end

  def fill(key, value)
    attributes[key.to_s] = value
  end

  def pdftk
    @pdftk ||= PdfForms.new( '/usr/bin/pdftk') # On my Mac, the location of pdftk was different than on my linux server.
    #@pdftk ||= PdfForms.new('C:/PDFtk/bin/pdftk') # On my Mac, the location of pdftk was different than on my linux server.
  end

  def fill_out
    raise 'Must be overridden by child class'
  end

end