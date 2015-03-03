name             'flexibee'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures flexibee'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "postgresql"
depends "apt"
depends "locales"
depends "locale-gen"
depends "locale"
depends "java"
