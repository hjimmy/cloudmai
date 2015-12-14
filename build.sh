name="cloudmai"
version="1.0.0"
fullname=$name-$version
cp -rf  source $fullname
tar -zcvf $fullname.tar.gz $fullname
cp -rf $fullname.tar.gz   ~/rpmbuild/SOURCES
cp -rf *.spec ~/rpmbuild/SPECS
rm -rf $fullname
rm -rf $fullname.tar.gz 
rpmbuild -bs --nodeps ~/rpmbuild/SPECS/$name.spec
rpmbuild -ba  ~/rpmbuild/SPECS/$name.spec
