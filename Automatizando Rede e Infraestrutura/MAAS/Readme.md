snap install --channel=3.4 maas
snap install maas-test-db
maas init region+rack --database-uri maas-test-db:///
maas createadmin

https://www.linkedin.com/pulse/canonical-maas-lab-example-ivan-synianskyi
