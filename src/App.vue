<template>
  <v-app>
    <v-main>
      <h1 class="font-bold text-4xl">Gaps in Western sanctions against Russia</h1>
      <GraphBlock 
        :donut-obj="donutObj"
        :total-entries="totalEntries"
      />
      <Database
        :rows="rows"
        :entList="entList"
        :showLoader="showLoader"
        :colMap="colMap"
      />
    </v-main>
  </v-app>
</template>

<script>
import axios from 'axios';
import csvToJson from 'csvtojson';

import Database from './components/Database';
import GraphBlock from './components/GraphBlock';

let red = "#E74C3C";
let green = "#2ECC71";

let cross = `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="${red}" class="bi bi-x-circle" viewBox="-2 -2 20 20">
  <path stroke="${red}" stroke-width="1.5" d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
</svg>`;

let check = `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="${green}" class="bi bi-check-circle" viewBox="-2 -2 20 20">
  <path stroke="${green}" stroke-width="1.5" d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
</svg>`; 

export default {
  name: 'App',
  metaInfo: {
    meta: [
      { name: 'viewport', content: 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no' }
    ],
    title: "Russian Sanctions",
    /*
    script: [
      {
        src: './iframe/iframeResizer.contentWindow.min.js',
      },
    ]
    */
  },
  components: {
    Database, GraphBlock
  },
  methods: {
    load() {
      axios
      .get(
        // v1 'https://docs.google.com/spreadsheets/d/1D3FmybKuCeq8AeZFlLoZfcFHJZfc1hSJsnuunTRbFxA/export?format=csv&gid=0',
        // v1
        'https://docs.google.com/spreadsheets/d/1D3FmybKuCeq8AeZFlLoZfcFHJZfc1hSJsnuunTRbFxA/export?format=csv&gid=0',
        { responseType: 'blob' }
      )
      .then( (response) => {
        // const file = response.data;
        response.data.text().then((csvStr) => {
          csvToJson()
            .fromString(csvStr)
            .then((jsonObj) => {
              jsonObj.forEach((e) => {
                e.entity_individual = e["Sanctioned Entity/Individual"];
                delete e["Sanctioned Entity/Individual"];
                e.Australia = e.Australia == '✅' ?  check : cross;
                e.Canada = e.Canada == '✅' ?  check : cross;
                e.EU = e.EU == '✅' ?  check : cross;
                e.Switzerland = e.Switzerland == '✅' ?  check : cross;
                e.UK = e.UK == '✅' ?  check : cross;
                e.US = e.US == '✅' ?  check : cross;
                // Entities/Individuals/Aircrafts/Vessels
                if (e.Type == "Entity") {
                  e.Type = "Entity";
                } else if (e.Type == "Aircraft") {
                  e.Type = "Aircraft";
                } else if (e.Type == "Vessel") {
                  e.Type = "Vessel";
                } else {
                  e.Type = "Individual";
                }
              });
              this.totalEntries = jsonObj.length;

              this.entList = jsonObj.map(function(e) {
                const item = {
                  "label": e.entity_individual,
                  "type": e.Type
                }
                return item
              });

              const flatTypes = jsonObj.map(function(e) {
                const item =  e.Type;
                return item
              });
              
              for (let i=0; i<this.donutObj.length;i++) {
                console.log();
                const filteredArray = flatTypes.filter(e => e === this.donutObj[i].label)
                this.donutObj[i].count = filteredArray.length;
              }
              this.rows = jsonObj;
              this.showLoader = false;
            });
        });
      })
    },
  },
  data() {
    let entList = [];
    let showLoader = true;
    let rows = [
      {
        entity_individual: '',
        Australia: '',
        Canada: '',
        EU: '',
        Switzerland: '',
        UK: '',
        US: '',
        Type: '',
      }
    ];
    const colMap = {
      "Individual":"#7eba37",
      "Entity":"#05a8e8",
      "Aircraft":"#ef1277",
      "Vessel":"#235a9d",
    };
    const donutObj = [
      {
        "label": "Individual",
        "id": "individual",
        "color":colMap["Individual"],
        "count": 0
      },
      {
        "label": "Entity",
        "id": "entity",
        "color":colMap["Entity"],
        "count": 0
      },
      {
        "label": "Vessel",
        "id": "vessel",
        "color":colMap["Vessel"],
        "count": 0
      },
      {
        "label": "Aircraft",
        "id": "aircraft",
        "color":colMap["Aircraft"],
        "count": 0
      }
    ];
    const totalEntries = 1;
    return {
      rows,
      showLoader,
      entList,
      donutObj,
      colMap,
      totalEntries
    }
  },
  created() {
    this.load();
  },
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
