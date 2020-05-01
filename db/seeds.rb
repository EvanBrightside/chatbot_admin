Settings.first_or_initialize.update_attributes email: 'studio@molinos.dev', email_header_from: 'studio@molinos.dev', company_name: 'Adminos'
User.create email: 'studio@molinos.ru', password: 'changeme', roles: [:admin]
