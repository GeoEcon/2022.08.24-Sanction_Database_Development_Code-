#!/bin/bash
echo
read -p "You are deploying the application. Are you sure? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # do dangerous stuff
	echo "cleaning production repo";
	cd "../2022.08.15-Sanction_Database/";
	rm -rf css/ && rm -rf fonts/ && rm -rf js/ && rm -rf index.html;
  echo "cleaning done... building now";
  cd "../dev_env_Sanction_Database/";
  npm run build;
	echo "building done... copying now";
	cp -R dist/* ../2022.08.15-Sanction_Database/;
  cd "../2022.08.15-Sanction_Database/";
	echo "deploying to github";
	git add .;
	git commit -m "build";
	git push;
	cd "../dev_env_Sanction_Database/";
	echo;
	echo "Deployed!";
else
	echo;
	echo "Aborted";
fi