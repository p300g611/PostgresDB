set SVNExe="C:\Program Files\SlikSvn\bin\svn.exe" 
set SVNURL="https://code.cete.us/svn/dlm/aart/trunk/aart-web-dependencies/data_support/db/centos64-test/" 
set CheckOutLocation="C:\vagrant\centos64-test" 
cd c:\
mkdir vagrant
cd vagrant
mkdir scripts
mkdir logs
mkdir pgdump
mkdir centos64-test
%SVNExe% checkout %SVNURL% %checkOutLocation%
cd centos64-test
vagrant up