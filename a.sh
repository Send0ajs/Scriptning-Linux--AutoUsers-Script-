#!/bin/bash
# Started the part to created users, permissions and groups.
# Phats to diferensts directories to users directory.
pathworkers="/home/PedrosadeDuero/EdAnexo/Workers"
pathnave="/home/PedrosadeDuero/Nave/NWorkers"
path01="/home"
path02="/home/BodegasAsirSL"
path03="/home/PedrosadeDuero"
path04="/home/PedrosadeDuero/Nave/NWorkers"


# Refs to the diferents files.
file="users.txt"
file2="groups.txt"
file3="users_permissions.txt"
file4="groups_permissions.txt"
file5="users_by_group"

path="/home$dir$user"
dir="/"

#################################################

# Part for created the directories.

#################################################

pathE="/home/"
dir="/"
file0="dir.txt"
cd $pathE

while read line; do 

IFS=","
pathV="$pathE"
cd $pathV

for campo in $line; do
 if [ -d $campo ];then
 rmdir .$dir$campo
 echo "El directorio ya existe"
 fi
    mkdir $campo
 pathV="$pathV$campo$dir"
 cd $pathV
 done
done < $file0

#################################################
cd $path
#################################################

# Loops to created the groups.

#################################################

while IFS=";" read -r groups; do 

  if [ $(getent group $groups) ];then
  groupdel $groups
 echo "The group $groups already exist. This group will be eliminate."
 fi
	
done < $file2

while IFS=";" read -r groups; do 
 
  groupadd $groups
 
done < $file2

#################################################

# Loops to created the users. (And add user to the groups)

#################################################

while IFS=";" read -r user potatoe; do 
 
 if [ $(getent user $user) ];then
   userdel -r $user
 echo "The user $user already exist. This user will be eliminate."
 fi


done < $file

while IFS=";" read -r user password path; do 

   useradd -m  $user -d $path$dir$user
   echo "This user now have a folder in $path"

     echo "$user:$password" | chpasswd
     
done < $file


while IFS=";" read -r user group; do 
  
    adduser $user $group
    echo "$group is now a group to the system"
done < $file5

#################################################

# Loops to add the permissions (Users).

#################################################


while IFS=";" read -r user permissions route; do 
  
 setfacl -m u:$user:$permissions $route$dir$user
    
done < $file3

#################################################

# Loops to add the permissions. (Groups)

#################################################

while IFS=";" read -r group permissions route; do # Applied to BodegasAsirSL.
  

 setfacl -m g:$group:$permissions $route

   
done < $file4
