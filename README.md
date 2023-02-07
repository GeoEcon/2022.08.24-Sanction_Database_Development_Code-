# Russians Sanctions

Beware, the env changes at every update. Either 
`2022.08.15-Sanction_Database` or `2022.12.7-Russia_Sanctions_Database_Demo`

## Project Info

- using vuejs with `vuetify`. First, set up vue and right after, **vuetify**
- setting up tailwind:
```
npm install tailwindcss@npm:@tailwindcss/postcss7-compat postcss@^7 autoprefixer@^9
```  

then create the **tailwind.config.js**  
then create the **postcss.config.js**  
then create the **./src/main.css**  
then update the **./src/main.js** with the following `import './main.css'`

[guide](https://www.sanity.io/guides/tailwind-css-with-vue-js)

## Project setup
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### test env

```
npm run build && surge dist/ -d atlantic-sanctions.surge.sh
```

### new test env on github

UPDATE the `vue.config.js` file prior to deploying:  
```
publicPath: '/2022.12.7-Russia_Sanctions_Database_Demo/',
```

build and push the `dist` folder to github:  
```
npm run build
open ../
``` 
remove then copy then past then 
```
cd ../2022.12.7-Russia_Sanctions_Database_Demo/
git add .
gm "test build"
git push
cd ../dev_env_Sanction_Database/
```

### Compiles and minifies for production, updating the repo

UPDATE the `vue.config.js` file prior to deploying:  
```
publicPath: '/2022.08.15-Sanction_Database/',
```

```
sh deploy.sh
```

### To Github, built app (official app)

[Link](https://geoecon.github.io/2022.08.15-Sanction_Database/)

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).

## Design
[Figma File](https://www.figma.com/file/M0d4yTkbXDvSInXqR0J7Vd/Database-Sanctions?node-id=0%3A1)  
