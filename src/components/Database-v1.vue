<template>
  <div class="border-none">

    <h1 class="font-bold text-4xl">Gaps in Western sanctions against Russia</h1>
    
    <div class="grid grid-cols-1 sm:grid-cols-4 border-none inline-flex main-color mb-4 mt-6">

      <div>
        <template>
          <!--
          <v-text-field
            v-model="search"
            label="Search"
            class="mr-2"
          ></v-text-field>
          -->
          <v-autocomplete
            v-model="search"
            :items="entList"
            label="Search"
            class="mr-2"
          ></v-autocomplete>
        </template>
      </div>

      <div>
        <template>
          <v-select
            :items="selectors"
            label="Filter by Type"
            outlined
            v-model="selectedVal"
            class="border-none p-0 text-sm"
          ></v-select>
        </template>
      </div>

    </div>

    <div v-show="showLoader" class="flex justify-center">
      <div class="loader"></div>
    </div>

    <div v-show="!showLoader">
      <v-data-table
        :mobile-breakpoint="0"
        :headers="headers"
        :items="rows"
        :items-per-page="10"

        
        class="border-none main-color border-none"
        :search="search"
        :custom-filter="searchFunc"
      >
        <!-- Header customization -->
        <template v-slot:header.entity_individual="{ header }">
          <span class="font-bold text-sm main-color">{{ header.text }}</span>
        </template>

        <template v-slot:header.Australia="{ header }">
          <span class="invisible"></span>
          <span class="font-bold text-sm main-color">{{ header.text }}</span>
          <span class="invisible"></span>
        </template>

        <template v-slot:header.Canada="{ header }">
          <span class="invisible"></span>
          <span class="font-bold text-sm main-color">{{ header.text }}</span>
          <span class="invisible"></span>
        </template>

        <template v-slot:header.EU="{ header }">
          <span class="invisible"></span>
          <span class="font-bold text-sm main-color">{{ header.text }}</span>
          <span class="invisible"></span>
        </template>

        <template v-slot:header.Switzerland="{ header }">
          <span class="font-bold text-sm main-color">{{ header.text }}</span>
        </template>

        <template v-slot:header.UK="{ header }">
          <span class="invisible"></span>
          <span class="font-bold text-sm main-color">{{ header.text }}</span>
          <span class="invisible"></span>
        </template>

        <template v-slot:header.US="{ header }">
          <span class="invisible"></span>
          <span class="font-bold text-sm main-color">{{ header.text }}</span>
          <span class="invisible"></span>
        </template>

        <template v-slot:header.Type="{ header }">
          <span class="font-bold text-sm main-color">{{ header.text }}</span>
        </template>

        <!-- End of Header customization -->

        <!-- In-table customization -->

        <template v-slot:item.entity_individual="{ item }">
          <div class="text-lg" v-html="item.entity_individual"></div> 
        </template>

        <template v-slot:item.Australia="{ item }">
          <div class="flex justify-center" v-html="item.Australia"></div> 
        </template>

        <template v-slot:item.Canada="{ item }">
          <div class="flex justify-center" v-html="item.Canada"></div> 
        </template>

        <template v-slot:item.Switzerland="{ item }">
          <div class="flex justify-center" v-html="item.Switzerland"></div> 
        </template>

        <template v-slot:item.EU="{ item }">
          <div class="flex justify-center" v-html="item.EU"></div> 
        </template>

        <template v-slot:item.UK="{ item }">
          <div class="flex justify-center" v-html="item.UK"></div> 
        </template>

        <template v-slot:item.US="{ item }">
          <div class="flex justify-center" v-html="item.US"></div> 
        </template>

        <template v-slot:item.Type="{ item }">
          <span :class="colorize(item.Type)" v-html="item.Type"></span> 
        </template>
      
      </v-data-table>
    </div>

  </div>
</template>

<script>

import axios from 'axios';
import csvToJson from 'csvtojson';

let red = "#E74C3C";
let green = "#2ECC71";

let cross = `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="${red}" class="bi bi-x-circle" viewBox="-2 -2 20 20">
  <path stroke="${red}" stroke-width="0.75" d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
  <path stroke="${red}" stroke-width="0.75" d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
</svg>`;

let check = `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="${green}" class="bi bi-check-circle" viewBox="-2 -2 20 20">
  <path stroke="${green}" stroke-width="0.75" d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
  <path stroke="${green}" stroke-width="0.75" d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
</svg>`; 

export default {
    methods: {
      load() {
        axios
          .get(
            'https://docs.google.com/spreadsheets/d/1D3FmybKuCeq8AeZFlLoZfcFHJZfc1hSJsnuunTRbFxA/export?format=csv&gid=0',
            { responseType: 'blob',}
          )
          .then( (response) => {
            const file = response.data;
            file.text().then((csvStr) => {
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
                  this.entList = jsonObj.map(e => e.entity_individual);
                  console.log(this.entList);
                  this.rows = jsonObj;
                  this.showLoader = false;
                });

            });
          })
      },
      searchFunc (value, search) {
        return value != null &&
          search != null &&
          typeof value === 'string' &&
          value.toString().toLowerCase().indexOf(search.toLowerCase()) !== -1
      },
      colorize(e) {
        // item.Type == 'Individual' ? 'color-turquoise' : 'color-purple' 
        if (e == "Entity") {
          return 'color-turquoise text-lg'
        } else if (e == "Aircraft") {
          return 'color-blue text-lg'
        } else if (e == "Vessel") {
          return 'color-purple text-lg'
        } else {
          return 'color-dark text-lg'
        }
      }
    },
    created() {
      this.load();
    },
    data () {
      let entList = [];
      let search =  "";
      let info = "";
      let headers = [
        {
          text: 'Entity/Individual',
          align: 'start',
          sortable: false,
          value: 'entity_individual',
        },
        { text: 'US', value: 'US', align: 'center', sortable: false },
        { text: 'UK', value: 'UK', align: 'center', sortable: false },
        { text: 'EU', value: 'EU', align: 'center', sortable: false },
        { text: 'Canada', value: 'Canada', align: 'center', sortable: false },
        { text: 'Switzerland', value: 'Switzerland', align: 'center', sortable: false },
        { text: 'Australia', value: 'Australia', align: 'center', sortable: false },
        { text: 'Type', 
          sortable: false,
          value: 'Type',
          filter: value => {
              if (!this.selectedVal || this.selectedVal == 'ANY TYPE') return true
              else return value == this.selectedVal
            },
        },
      ];
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
      let selectors = ["Entity", "Individual", "Vessel", "Aircraft", "ANY TYPE"];
      let selectedVal = "";
      return {
        info,
        headers,
        rows,
        search,
        selectors,
        selectedVal,
        showLoader,
        entList
      }
    },
  }
</script>

<style>

.v-label {
  font-size: 1.2rem !important;
}

.text-field {
    color: #90C143 !important; /* this will override the existing property applied */
    /* add whatever properties you want */
}

.primary--text {
  color: #fff0 !important;
}

* {
  font-family: "Proxima", monospace;
}

.v-data-footer__select {
  visibility:hidden;
}

.main-color {
  color:#252525 !important;
}

tbody > tr:nth-child(odd) {
  background-color: #9B59B610 !important;
}

tbody {
  border-top: 3px solid #555;
}

.color-turquoise {
  font-weight: bold;
  padding: 4px 8px;
  border: 3px solid #1ABC9C;
  border-radius: 4px;
  color: #1ABC9C;
  text-transform: uppercase;
  font-size: 12px;
}

.color-purple {
  font-weight: bold;
  padding: 4px 8px;
  border: 3px solid #9B59B6;
  border-radius: 4px;
  color: #9B59B6;
  text-transform: uppercase;
  font-size: 12px;
}

.color-dark {
  font-weight: bold;
  padding: 4px 8px;
  border: 3px solid #7f8c8d;
  border-radius: 4px;
  color: #7f8c8d;
  text-transform: uppercase;
  font-size: 12px;
}

.color-blue {
  font-weight: bold;
  padding: 4px 8px;
  border: 3px solid #3498db;
  border-radius: 4px;
  color: #3498db;
  text-transform: uppercase;
  font-size: 12px;
}

.loader {
  border: 4px solid #f3f3f3;
  border-radius: 50%;
  border-top: 4px solid #9B59B6;
  width: 30px;
  height: 30px;
  -webkit-animation: spin 2s linear infinite; /* Safari */
  animation: spin 2s linear infinite;
}

/* Safari */
@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

</style>
