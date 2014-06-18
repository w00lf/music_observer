module MainHelper
  def make_shedule_hash(concerts)
    concerts.group_by{ |item| item.start_date.localtime.to_date }
  end

  def main_page_hash
    concerts_ids = @concerts.pluck(:id).join('_')
    digit = Digest::MD5.hexdigest(concerts_ids)
    "main_concerts_#{digit}"
  end

  private

  def get_formated_date date
    I18n.localize(date, :format => "%e %B %Y")
  end
end
