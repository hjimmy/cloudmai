# -*- coding: utf-8 -*-
#!/usr/bin/python
'''
Created on 2014-2-17

@author: houjian
'''
import subprocess
import MySQLdb
import commands

#status,output = commands.getstatusoutput("cat /opt/mysql.passwd |grep mysqlpasswd |awk -F ' ' '{print $2}'")
#if status != 0:
#    print "Get mysql password failed"
#pwd=output.strip()
conn=MySQLdb.connect(host='localhost',user='root',passwd='qwer1234',port=3306,db='neocloud')
cur=conn.cursor()

###Create user by password
def createUser(username,password):
    print "php -f /srv/cloudmai/user.php " + 'passwordtohash' + " " + password
    proc = subprocess.Popen(["php -f /srv/cloudmai/user.php " + 'passwordtohash ' + password], shell=True,
    stdout=subprocess.PIPE)
    script_response = proc.stdout.read()
    ##Get password hash
    hash=(script_response)
    #Get mysql password
    print "insert into  oc_users  values('" + username +"',NULL,'"+ hash + "'"+")"
    cur.execute("insert into  oc_users  values('" + username +"',NULL,'"+ hash + "'"+")")
    conn.commit()
    cur.close()
    conn.close()

###Delete a User
def deleteUser(username):
    cur.execute("delete from oc_users where uid = '" + username + "'")
    status,output = commands.getstatusoutput("sudo rm -rf /var/www/owncloud/data/"+username)
    if status != 0:
        print "Delete " + username + "data failed"
        
    conn.commit()
    cur.close()
    conn.close()

###Update User's Password
def updateUser(username,password):
    print "php -f /srv/cloudmai/user.php " + 'passwordtohash' + " " + password
    proc = subprocess.Popen(["php -f /srv/cloudmai/user.php " + 'passwordtohash ' + password], shell=True,
    stdout=subprocess.PIPE)
    script_response = proc.stdout.read()
    ##Get password hash
    hash=(script_response)
    #Get mysql password
    cur.execute("update  oc_users set password = '" + hash + "' where uid ='" + username + "'")
    conn.commit()
    cur.close()
    conn.close()


if __name__ == '__main__':
    createUser("houjian400","qwer1234")
    #deleteUser("houjian400")

