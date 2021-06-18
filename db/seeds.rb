Settings.first_or_initialize(
  email: 'mate@assistant.dev',
  email_header_from: 'mate@assistant.dev',
  company_name: 'MateAssistant'
).save!(validate: false)
User.create email: 'mate@assistant.dev', password: 'yourbodydance', roles: [:admin]
