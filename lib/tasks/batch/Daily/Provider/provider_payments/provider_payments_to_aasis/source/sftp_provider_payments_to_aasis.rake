task :sftp_provider_payment_file_to_aasis_for_verification => :environment do
 #require 'net/ssh'
  #require 'net/sftp'
# FTP the file
require 'net/ftp'
 target_folder = '/fi0810/test/in/'

 zipfile_name = Dir.glob('batch_results/daily/Provider/provider_payments/provider_payments_to_aasis/outbound/*.zip')



#   sftp = Net::SFTP.start('disftp.state.ar.us', 'fi0810', :password =>  'zaq12wsx')
#   Rails.logger.debug("sftp -----#{sftp.dir.inspect}")


#  #puts sftp.dir.entries("/fi0810/test/in/").map { |e| e.name }
#   file = sftp.file.open("/ftpdir/fi0810/test/in/")
#   puts file.gets
#   file.close

  #sftp.upload!('batch_results/daily/Provider/provider_management/providers_to_aasis/outbound/', '/fi0810/test/in/')




#sftp_service = UploaderService.new('disftp.state.ar.us','fi0810','zaq12wsx')
#sftp_service.upload(zipfile_name,target_folder)
# find the zip fiel name

 @ftp = Net::FTP.new
 @ftp.debug_mode = true
 @ftp.passive = true
 @ftp.connect('disftp.state.ar.us')
 @ftp.login('fi0810', 'zaq12wsx')
 @ftp.chdir(target_folder)
 @ftp.putbinaryfile(zipfile_name[0])
 @ftp.close
end