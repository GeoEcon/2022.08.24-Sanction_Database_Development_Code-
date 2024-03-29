<template>
  <v-app>
    <v-main>
      <h1 class="font-bold text-4xl pl-2">Gaps in Western sanctions against Russia</h1>
      <GraphBlock 
        :donut-obj="donutObj"
        :sanctionsCountByType="sanctionsCountByType"
        :total-entries="totalEntries"
        :total-sanctions="totalSanctions"
        :path="path"
      />
      <Database
        :rows="rows"
        :entList="entList"
        :showLoader="showLoader"
        :colMap="colMap"
        :path="path"
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

const sizeTicks = 32;

let cross = `<svg data-v-sign="cross" xmlns="http://www.w3.org/2000/svg" width=${sizeTicks} height=${sizeTicks} fill="${red}" class="bi bi-x-circle" viewBox="-2 -2 20 20">
  <path stroke="${red}" stroke-width="1.5" d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
</svg>`;

let check = `<svg data-v-sign="check" xmlns="http://www.w3.org/2000/svg" width=${sizeTicks} height=${sizeTicks} fill="${green}" class="bi bi-check-circle" viewBox="-2 -2 20 20">
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
        // v2
        'https://docs.google.com/spreadsheets/d/1tledta6ChBKWBr-LUtAI3O9FY4H24hpZpb86tTNAq4w/export?format=csv&gid=0',
        { responseType: 'blob' }
      )
      .then( (response) => {
        // const file = response.data;
        response.data.text().then((csvStr) => {
          csvToJson()
            .fromString(csvStr)
            .then((jsonObj) => {
              jsonObj.forEach((e) => {               

                // counting sanctions
                for (let [key, value] of Object.entries(e)) {
                  key == key;
                  if (value == '✅') {
                    this.totalSanctions += 1;
                    this.sanctionsCountByType[e.Type] += 1;
                  }
                }


                // sorting table
                e.entity_individual = e["Sanctioned Entity/Individual"];
                delete e["Sanctioned Entity/Individual"];
                e.Australia = e.Australia == '✅' ?  check : cross;
                e.Canada = e.Canada == '✅' ?  check : cross;
                e.EU = e.EU == '✅' ?  check : cross;
                e.Switzerland = e.Switzerland == '✅' ?  check : cross;
                e.UK = e.UK == '✅' ?  check : cross;
                e.US = e.US == '✅' ?  check : cross;
                e.Japan = e.Japan == '✅' ?  check : cross;
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
                e.SanctionList = e["Sanctions Lists"] === '' ?  '<i>List not available</i>' : e["Sanctions Lists"];
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
                const filteredArray = flatTypes.filter(e => e === this.donutObj[i].label)
                this.donutObj[i].count = filteredArray.length;
              }
              this.rows = jsonObj;
              console.log(jsonObj);
              this.showLoader = false;
            });
        });
      })
    },
  },
  data() {
    const path = '2022.12.7-Russia_Sanctions_Database_Demo/';
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
        Japan: '',
        Type: '',
        SanctionList: ''
      }
    ];
    const colMap = {
      "Individual":"#7eba37",
      "Entity":"#05a8e8",
      "Aircraft":"#235a9d ",
      "Vessel":"#ef1277",
      "Any":"#f959b5"
    };
    const donutObj = [
      {
        "label": "Individual",
        "labelPlural": "Individuals",
        "id": "individual",
        "color":colMap["Individual"],
        "count": 0
      },
      {
        "label": "Entity",
        "labelPlural": "Entities",
        "id": "entity",
        "color":colMap["Entity"],
        "count": 0
      },
      {
        "label": "Vessel",
        "labelPlural": "Vessels",
        "id": "vessel",
        "color":colMap["Vessel"],
        "count": 0
      },
      {
        "label": "Aircraft",
        "labelPlural": "Aircraft",
        "id": "aircraft",
        "color":colMap["Aircraft"],
        "count": 0
      }
    ];
    const totalEntries = 1;
    const totalSanctions = 0;
    const sanctionsCountByType = {
      "Individual":0,
      "Entity": 0,
      "Vessel": 0,
      "Aircraft": 0
    };
    return {
      path,
      rows,
      showLoader,
      entList,
      donutObj,
      colMap,
      totalEntries,
      totalSanctions,
      sanctionsCountByType
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
