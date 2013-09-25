class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def concert_notification(concerts, user)
  	@concerts = concerts
    @user = user.email
    @url  = 'http://example.com/login'
    concerts.each do |concert|
      attachments.inline[concert.id.to_s] = File.read(concert.photo.path)
    end
    subject = t('concert_notfctn_subj', groups: concerts.map(&:artist).map(&:name).join(', ') )
    mail(to: @user, subject: subject) do |format|
      format.html { render }
    end 
  end
end
