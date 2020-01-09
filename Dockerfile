FROM clustertech/postfix
ENV container docker
RUN curl -Lo /MailScanner-5.2.1-1.rhel.noarch.rpm https://github.com/MailScanner/v5/raw/master/builds/MailScanner-5.2.1-1.rhel.noarch.rpm; \
curl -Lo /unrar-5.0.3-1.x86_64.rpm https://s3.amazonaws.com/msv5/rpm/unrar-5.0.3-1.x86_64.rpm; \
yum -y install epel-release rsyslog cronie; \
yum -y update; \
yum install tnef unrar binutils gcc glibc-devel libaio make man-pages man-pages-overrides patch rpm tar time unzip which zip libtool-ltdl perl curl wget openssl openssl-devel bzip2-devel perl-Filesys-Df perl-Sys-Hostname-Long perl-Archive-Tar perl-Archive-Zip perl-Compress-Raw-Zlib perl-Compress-Zlib perl-Convert-BinHex perl-CPAN perl-Data-Dump perl-DBD-SQLite perl-DBI perl-Digest-HMAC perl-Digest-SHA1 perl-Env perl-ExtUtils-MakeMaker perl-File-ShareDir-Install perl-File-Temp perl-Filesys-Df perl-Getopt-Long perl-IO-String perl-IO-stringy perl-HTML-Parser perl-HTML-Tagset perl-Inline perl-IO-Zlib perl-Mail-DKIM perl-Mail-IMAPClient perl-Mail-SPF perl-MailTools perl-Net-CIDR perl-Net-DNS perl-Net-DNS-Resolver-Programmable perl-MIME-tools perl-Convert-TNEF perl-Net-IP perl-OLE-Storage_Lite perl-Pod-Escapes perl-Pod-Simple perl-Scalar-List-Utils perl-Storable perl-Pod-Escapes perl-Pod-Simple perl-Razor-Agent perl-Sys-Hostname-Long perl-Sys-SigAction perl-Test-Manifest perl-Test-Pod perl-Time-HiRes perl-TimeDate perl-URI perl-YAML pyzor re2c unrar tnef perl-Encode-Detect perl-LDAP perl-IO-Compress-Bzip2 p7zip p7zip-plugins perl-LWP-Protocol-https perl-Test-Simple spamassassin perl-MailTools-2.12-2.el7.noarch perl-ExtUtils-CBuilder.noarch perl-Module-Build.noarch perl-Net-CIDR-Lite perl-App-cpanminus; \
yum clean all; \
yum -y install MailScanner-5.2.1-1.rhel.noarch.rpm unrar-5.0.3-1.x86_64.rpm; \
ms-configure --MTA=none --installEPEL=Y --installClamav=N --configClamav=N --installTNEF=Y --installUnrar=Y --installCPAN=Y --installDf=Y --SELPermissive=N --ignoreDeps=N --ramdiskSize=0; \
sed -i 's/^run_mailscanner=0/run_mailscanner=1/' /etc/MailScanner/defaults; \
sed -i 's/^#SAUPDATE=yes/SAUPDATE=yes/' /etc/sysconfig/sa-update; \
rm -f /*.rpm /startpostfix.sh; \
mkdir -p /var/spool/mqueue /var/spool/mqueue.in
COPY . /
ENTRYPOINT ["/tini", "/startmailscanner.sh"]
