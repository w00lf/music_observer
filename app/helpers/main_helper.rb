module MainHelper
  def make_shedule_hash(concerts)
    prev = ''
    shedule = {}
    concerts.each do |con|
      if prev == get_formated_date(con.start_date)
        shedule[prev].push(con)
      else
        shedule[get_formated_date(con.start_date)] = [con]
      end
      prev = get_formated_date(con.start_date)
    end
    shedule
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
