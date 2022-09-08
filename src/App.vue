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
    meta: [
      { name: 'viewport', content: 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no' }
    ],
    title: "hey",
    /*
    script: [
      {
        src: './iframe/iframeResizer.contentWindow.min.js',
      },
    ]
    */
  },

  components: {
    Database,
  },

  data: () => ({
    //
  }),

  mounted() {
    const resizeFrame = document.createElement("script");
    resizeFrame.setAttribute(
      "src",
      "./iframe/iframeResizer.contentWindow.min.js"
    );
    document.body.appendChild(resizeFrame);
  },

  
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
