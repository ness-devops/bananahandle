name             'lamp-stack'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures lamp-stack'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.5'

depends          'mysql', '~> 7.1.0'
depends          'database', '~> 5.1.2'
