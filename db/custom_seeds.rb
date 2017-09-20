require 'database_cleaner'

DatabaseCleaner.clean_with :truncation

print "Creando las configuraciones..."

Setting.create(key: 'official_level_1_name', value: 'Empleados públicos')
Setting.create(key: 'official_level_2_name', value: 'Organización Municipal')
Setting.create(key: 'official_level_3_name', value: 'Directores generales')
Setting.create(key: 'official_level_4_name', value: 'Concejales')
Setting.create(key: 'official_level_5_name', value: 'Alcalde')
Setting.create(key: 'max_ratio_anon_votes_on_debates', value: '50')
Setting.create(key: 'max_votes_for_debate_edit', value: '1000')
Setting.create(key: 'max_votes_for_proposal_edit', value: '1000')
Setting.create(key: 'proposal_code_prefix', value: 'PR')
Setting.create(key: 'votes_for_proposal_success', value: '100')
Setting.create(key: 'months_to_archive_proposals', value: '12')
Setting.create(key: 'comments_body_max_length', value: '1000')

Setting.create(key: 'twitter_handle', value: '@ayto_preal')
Setting.create(key: 'twitter_hashtag', value: '#decidepuertoreal')
Setting.create(key: 'facebook_handle', value: 'ayuntamientodepuertoreal')
Setting.create(key: 'youtube_handle', value: '')
Setting.create(key: 'telegram_handle', value: '')
Setting.create(key: 'instagram_handle', value: '')
Setting.create(key: 'blog_url', value: '')
Setting.create(key: 'url', value: 'http://decide.puertoreal.es')
Setting.create(key: 'org_name', value: 'Decide Puerto Real')
Setting.create(key: 'place_name', value: 'Puerto Real')
Setting.create(key: 'feature.debates', value: "true")
Setting.create(key: 'feature.polls', value: "true")
Setting.create(key: 'feature.spending_proposals', value: nil)
Setting.create(key: 'feature.spending_proposal_features.voting_allowed', value: nil)
Setting.create(key: 'feature.budgets', value: "false")
Setting.create(key: 'feature.twitter_login', value: "false")
Setting.create(key: 'feature.facebook_login', value: "false")
Setting.create(key: 'feature.google_login', value: "false")
Setting.create(key: 'feature.signature_sheets', value: "true")
Setting.create(key: 'feature.legislation', value: "true")
Setting.create(key: 'per_page_code_head', value: "")
Setting.create(key: 'per_page_code_body', value: "")
Setting.create(key: 'comments_body_max_length', value: '1000')
Setting.create(key: 'mailer_from_name', value: 'Decide Puerto Real')
Setting.create(key: 'mailer_from_address', value: 'noreply@consul.dev')
Setting.create(key: 'meta_description', value: 'Citizen Participation and Open Government Application')
Setting.create(key: 'meta_keywords', value: 'citizen participation, open government')
Setting.create(key: 'verification_offices_url', value: 'http://oficinas-atencion-ciudadano.url/')
Setting.create(key: 'min_age_to_participate', value: '16')
Setting.create(key: 'proposal_improvement_path', value: nil)

puts " ✅"

print "Creando los usuarios..."
def create_user(email, username = Faker::Name.name)
  pwd = '12345678'
  User.create!(
    username:               username,
    email:                  email,
    password:               pwd,
    password_confirmation:  pwd,
    confirmed_at:           Time.current,
    terms_of_service:       "1",
    gender:                 ['Male', 'Female'].sample,
    date_of_birth:          rand((Time.current - 80.years) .. (Time.current - 16.years)),
    public_activity:        (rand(1..100) > 30)
  )
end

admin = create_user('admin@consul.dev', 'admin')
admin.create_administrator
admin.update(residence_verified_at: Time.current, confirmed_phone: Faker::PhoneNumber.phone_number, document_type: "1", verified_at: Time.current, document_number: "1111111111")

moderator = create_user('mod@consul.dev', 'mod')
moderator.create_moderator

manager = create_user('manager@consul.dev', 'manager')
manager.create_manager

valuator = create_user('valuator@consul.dev', 'valuator')
valuator.create_valuator

poll_officer = create_user('poll_officer@consul.dev', 'Paul O. Fisher')
poll_officer.create_poll_officer

level_2 = create_user('leveltwo@consul.dev', 'level 2')
level_2.update(residence_verified_at: Time.current, confirmed_phone: Faker::PhoneNumber.phone_number, document_number: "2222222222", document_type: "1")

verified = create_user('verified@consul.dev', 'verified')
verified.update(residence_verified_at: Time.current, confirmed_phone: Faker::PhoneNumber.phone_number, document_type: "1", verified_at: Time.current, document_number: "3333333333")

(1..3).each do |i|
  org_name = Faker::Company.name
  org_user = create_user("org#{i}@consul.dev", org_name)
  org_responsible_name = Faker::Name.name
  org = org_user.create_organization(name: org_name, responsible_name: org_responsible_name)

  verified = [true, false].sample
  if verified
    org.verify
  else
    org.reject
  end
end

(1..3).each do |i|
  official = create_user("official#{i}@consul.dev")
  official.update(official_level: i, official_position: "Official position #{i}")
end

(1..10).each do |i|
  user = create_user("user#{i}@consul.dev")
  level = [1, 2, 3].sample
  if level >= 2
    user.update(residence_verified_at: Time.current, confirmed_phone: Faker::PhoneNumber.phone_number, document_number: Faker::Number.number(10), document_type: "1", geozone:  Geozone.reorder("RANDOM()").first)
  end
  if level == 3
    user.update(verified_at: Time.current, document_number: Faker::Number.number(10))
  end
end

org_user_ids = User.organizations.pluck(:id)
not_org_users = User.where(['users.id NOT IN(?)', org_user_ids])

puts " ✅"

print "Creando las categorías..."

ActsAsTaggableOn::Tag.category.create!(name:  "Asociaciones")
ActsAsTaggableOn::Tag.category.create!(name:  "Cultura")
ActsAsTaggableOn::Tag.category.create!(name:  "Deportes")
ActsAsTaggableOn::Tag.category.create!(name:  "Derechos Sociales")
ActsAsTaggableOn::Tag.category.create!(name:  "Economía")
ActsAsTaggableOn::Tag.category.create!(name:  "Empleo")
ActsAsTaggableOn::Tag.category.create!(name:  "Equidad")
ActsAsTaggableOn::Tag.category.create!(name:  "Sostenibilidad")
ActsAsTaggableOn::Tag.category.create!(name:  "Participación")
ActsAsTaggableOn::Tag.category.create!(name:  "Movilidad")
ActsAsTaggableOn::Tag.category.create!(name:  "Medios")
ActsAsTaggableOn::Tag.category.create!(name:  "Salud")
ActsAsTaggableOn::Tag.category.create!(name:  "Transparencia")
ActsAsTaggableOn::Tag.category.create!(name:  "Seguridad y Emergencias")
ActsAsTaggableOn::Tag.category.create!(name:  "Medio Ambiente")

puts " ✅"

print "Creando las zonas..."

Geozone.create(name: "Zona Río San Pedro", html_map_coordinates: "5,131,107,133,107,205,8,207", external_code: "", census_code: "")
Geozone.create(name: "Zona Oeste", html_map_coordinates: "124,126,133,119,143,112,150,109,165,110,168,117,170,119,176,118,185,112,197,117,192,133,185,153,180,172,176,182,168,179,163,175,161,170,157,167,150,164,142,161,135,158,126,155,123,153,123,140", external_code: "", census_code: "")
Geozone.create(name: "Zona Centro", html_map_coordinates: "198,116,212,122,221,127,229,130,233,132,238,135,244,140,253,143,257,144,255,152,252,157,251,160,259,168,256,177,253,184,251,188,251,191,245,196,238,198,232,197,228,195,224,194,219,192,217,192,214,199,211,198,212,193,205,191,196,189,188,187,181,184,177,183,182,168,186,152,191,136,195,124", external_code: "", census_code: "")
Geozone.create(name: "Zona Este 2", html_map_coordinates: "259,142,270,147,282,151,295,156,307,159,315,161,325,163,336,166,341,167,343,167,339,177,335,187,331,195,328,206,325,211,324,214,290,199,285,198,280,199,274,192,268,189,261,187,256,188,253,189,251,190,254,179,257,172,259,167,251,161,254,151", external_code: "", census_code: "")
Geozone.create(name: "Zona Este 1", html_map_coordinates: "343,168,355,173,363,175,368,179,375,184,383,191,390,197,396,202,402,207,406,209,408,213,415,228,407,230,400,231,394,234,387,232,375,229,362,226,351,222,338,218,333,216,326,215,324,213,330,197,338,180", external_code: "", census_code: "")
Geozone.create(name: "Zona Norte", html_map_coordinates: "322,162,313,161,304,160,292,155,276,148,263,144,260,142,257,144,248,142,240,137,233,132,220,125,208,120,198,117,184,113,170,119,164,110,174,79,182,73,186,71,201,64,217,58,233,53,248,47,261,43,271,42,291,42,310,43,326,44,336,45,343,45,384,78,304,136,318,149", external_code: "", census_code: "")
Geozone.create(name: "Zona Rural 2", html_map_coordinates: "35,309,35,424,80,455,129,440,134,411,118,386,112,366,107,344,108,318,94,307,59,301", external_code: "", census_code: "")
Geozone.create(name: "Zona Rural 1", html_map_coordinates: "139,373,190,308,247,280,303,277,346,315,348,367,408,392,411,465,409,511,403,553,398,564,163,562,186,477,176,423", external_code: "", census_code: "")

puts " ✅"

puts "Todos los datos fueron satisfactoriamente insertados. 👍"
