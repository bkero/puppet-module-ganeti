# Ganeti::Webmgr parameters
#
#   path          The location of the ganeti-webmgr install
#   template      An apache config template to use for the webmgr
#   vhost_name    The name of the apache vhost. e.g. ganeti.cat.pdx.edu
#   ssl           Boolean. Whether or not to enable ssl on the apache vhost
#   ssl_cert_file If ssl, the path to the cert file
#   ssl_cert_key  If ssl, the path to the key file
#
# This should probably be converted to a define instead of a parameterized
# class. No matter. It compiles; release it!
#
class ganeti::webmgr (
  $path,
  $template      = "ganeti/webmgr/apache.erb",
  $vhost_name    = "ganeti.$domain",
  $ssl           = true,
  $ssl_cert_file = "/etc/apache2/certs/${::fqdn}.cert.pem",
  $ssl_cert_key  = "/etc/apache2/certs/${::fqdn}.key.pem"
) {
  include apache
  include apache::mod::wsgi

  apache::vhost {
    "ganeti-webmgr":
      vhost_name => $vhost_name,
      docroot    => $path,
      ssl        => true,
      port       => $ssl ? {
        true  => "443",
        false => "80",
      },
      template   => $template;
  }

  File {
    ensure => file,
    owner  => "root",
    group  => "root",
    mode   => "755",
  }

  file {
    "init/vncap":
      path    => "/etc/init.d/vncap",
      content => template("ganeti/webmgr/vncap.init.erb");
    "init/flashpolicy":
      path    => "/etc/init.d/flashpolicy",
      content => template("ganeti/webmgr/flashpolicy.init.erb");
    "init/gwm_cache":
      path    => "/etc/init.d/gwm_cache",
      content => template("ganeti/webmgr/gwm_cache.init.erb");
  }

  Service {
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

  service {
    "vncap":
      require => File["init/vncap"];
    "flashpolicy":
      require => File["init/flashpolicy"];
    "gwm_cache":
      require => File["init/gwm_cache"];
  }

}
