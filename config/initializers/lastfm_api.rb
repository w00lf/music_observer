lastfm_data = YAML.load_file(File.join(Rails.root, 'config', 'protected.yml'))
LASTFM_KEY = lastfm_data['lastfm_key']
LASTFM_SECRET = lastfm_data['lastfm_secrtet']
LASTFM_HOST =  'ws.audioscrobbler.com'
LASTFM_API_VER = '/2.0/'
LOCATION_LAT = 55..56
LOCATION_LON = 37..38
