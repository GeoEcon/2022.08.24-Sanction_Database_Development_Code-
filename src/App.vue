<template>
  <v-app>
    <v-main>
      <Database/>
    </v-main>
  </v-app>
</template>

<script>
import Database from './components/Database';

export default {
  name: 'App',

  metaInfo: {
      title: 'About Us'    
  },

  components: {
    Database,
  },

  data: () => ({
    //
  }),
};
</script>

<style>



@font-face {
  font-family: "Proxima";
  src: url("~@/assets/fonts/ProximaNova-Regular.woff2") format("woff2");
  font-weight: 400;
  font-style: normal;
} 

</style>
