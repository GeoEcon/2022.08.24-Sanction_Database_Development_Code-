<template>
  <div class="border-none">
    <div class="grid grid-cols-1 gap-2 lg:grid-cols-5 border-none inline-flex self-center main-color mb-4 mt-6">
    <!--<div class="border-none inline-flex self-center main-color mb-4 mt-6">-->
      <!--<div class="mx-2 search-size border-2 border-prim rounded-md flex items-center">-->
      <div id="search" class="sm:mx-2 mx-1 h-20 search-size border-2 col-span-2 border-prim rounded-md flex items-center">
        <div class="p-2">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#05a8e8" class="bi bi-search" viewBox="0 0 16 16">
            <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
          </svg>
        </div>
        <template>
          <v-autocomplete
            v-model="search"
            :items="entListFiltered"
            :label="searchLabel"
            :outlined=true
          ></v-autocomplete>
        </template>
        <div @click="resetSearch" class="p-2">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#05a8e8" class="bi bi-x cursor-pointer" viewBox="0 0 16 16">
            <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
          </svg>
        </div>
      </div>
      
      <div class="py-5 gap-1 grid md:grid-cols-5 grid-cols-2 col-span-2 lg:col-span-3 xl:col-span-2 flex justify-items-center">
      <!--<div class="flex ml-3">-->
        <div class="" v-for="btn in btns" :key="btn.id">

          <div 
            @click="toggle($event);animation()"
            :style="{ 
              'border-color': btn.color, 
              'color': selectedVals.includes(btn.label) ? '#fff' : btn.color,
              'background-color': selectedVals.includes(btn.label) ? btn.color : '#fff',
              'opacity': selectedVals.includes(btn.label) ? 1 : 0.6
            }" 
            class="btn-margin flex justify-center font-bold cursor-pointer px-4 py-2 rounded-lg border-2"
          >
            <button>{{ btn.label }}</button>
          </div>
        </div>
      </div>


      <div id="selection-countries" class="flex items-center justify-center flex-col">
        
        <div :style="{'background-color': 'transparent'}" class="mx-4 h-20 rounded-md border-2 border-prim overflow-hidden overflow-clip rounded-md">
          <div  
          class=""
          >
            
            <v-select
              id="dropdown-countries"
              v-model="activeColumns"
              :items="countries"
              :menu-props="{ maxHeight: '400' }"
              label="Select Countries"
              hint="Selected Countries"
              multiple
              return-object
              dense
              single-line
              item-color="#05a8e8"
              color="#05a8e8"
          ></v-select>
          </div>
        </div>
        <div class="italic">Selected countries</div>
      </div>
    </div>

    <div v-show="showLoader" class="flex justify-center">
      <div class="loader"></div>
    </div>

    <div v-show="!showLoader">
      <!-- :custom-sort="sortItems" has been removed -->

      <!-- displayHeadersNew() -->

      <v-data-table
        :mobile-breakpoint="0"
        :headers="displayHeaders()" 
        :items="rows"
        :items-per-page="10"
        id="main-table"
        class="border-none main-color"
        :search="search"
        :custom-filter="searchFunc"
      >
        <!-- Header customization -->
        <template v-slot:header.entity_individual="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
        </template>

        <template v-slot:header.US="{ header }">
          <div class="flex flex-col items-center">
            <div class="flex">
              <img :src="path + 'flags/us_min.png'" class="rounded-full my-1 mx-1">
              <span class="font-bold text-lg main-color">{{ header.text }}</span>
            </div>

            <v-select
              id="sanctions-US"
              v-model="defaultUS"
              :items="['All', '✅ Sanctioned', '❌ Not Sanctioned']"
              label="All"
              dense
              return-object
            ></v-select>

          </div>
        </template>

        <template v-slot:header.UK="{ header }">
          <div class="flex flex-col items-center">
            <div class="flex">
              <img :src="path + 'flags/uk_min.png'" class="rounded-full my-1 mx-1">
              <span class="font-bold text-lg main-color">{{ header.text }}</span>
            </div>

            <v-select
              id="sanctions-UK"
              v-model="defaultUK"
              :items="['All', '✅ Sanctioned', '❌ Not Sanctioned']"
              label="All"
              dense
              return-object
            ></v-select>
            
          </div>
        </template>

        <template v-slot:header.EU="{ header }">
          <div class="flex flex-col items-center">
            <div class="flex">
              <img :src="path + 'flags/eu_min.png'" class="rounded-full my-1 mx-1">
              <span class="font-bold text-lg main-color">{{ header.text }}</span>
            </div>
            
            <v-select
              id="sanctions-EU"
              v-model="defaultEU"
              :items="['All', '✅ Sanctioned', '❌ Not Sanctioned']"
              label="All"
              dense
              return-object
            ></v-select>

          </div>
        </template>

        <template v-slot:header.Canada="{ header }">
          <div class="flex flex-col items-center">
            <div class="flex">
              <img :src="path + 'flags/canada_min.png'" class="rounded-full my-1 mx-1">
              <span class="font-bold text-lg main-color">{{ header.text }}</span>
            </div>

            <v-select
              id="sanctions-Canada"
              v-model="defaultCanada"
              :items="['All', '✅ Sanctioned', '❌ Not Sanctioned']"
              label="All"
              dense
              return-object
            ></v-select>

          </div>
        </template>

        <template v-slot:header.Switzerland="{ header }">
          <div class="flex flex-col items-center">
            <div class="flex">
              <img :src="path + 'flags/sw_min.png'" class="rounded-full my-1 mx-1">
              <span class="font-bold text-lg main-color">{{ header.text }}</span>
            </div>

            <v-select
              id="sanctions-Switzerland"
              v-model="defaultSwitzerland"
              :items="['All', '✅ Sanctioned', '❌ Not Sanctioned']"
              label="All"
              dense
              return-object
            ></v-select>

          </div>
        </template>

        <template v-slot:header.Australia="{ header }">
          <div class="flex flex-col items-center">
            <div class="flex">
              <img :src="path + 'flags/australia_min.png'" class="rounded-full my-1 mx-1">
              <span class="font-bold text-lg main-color">{{ header.text }}</span>
            </div>

            <v-select
              id="sanctions-Australia"
              v-model="defaultAustralia"
              :items="['All', '✅ Sanctioned', '❌ Not Sanctioned']"
              label="All"
              dense
              return-object
            ></v-select>

          </div>
        </template>
        
        <template v-slot:header.Japan="{ header }">
          <div class="flex flex-col items-center">
            <div class="flex">
              <img :src="path + 'flags/japan_min.png'" class="rounded-full my-1 mx-1">
              <span class="font-bold text-lg main-color">{{ header.text }}</span>
            </div>

            <v-select
              id="sanctions-Japan"
              v-model="defaultJapan"
              :items="['All', '✅ Sanctioned', '❌ Not Sanctioned']"
              label="All"
              dense
              return-object
            ></v-select>

          </div>
        </template>

        <template v-slot:header.Type="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
        </template>

        <template v-slot:header.SanctionList="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
        </template>
        <!-- End of Header customization -->



        <!-- In-table customization -->
        <template v-slot:item.entity_individual="{ item }">
          <div class="text-lg col-entity" v-html="item.entity_individual"></div> 
        </template>

        <template v-slot:item.US="{ item }">
          <div class="flex justify-center col-generic" v-html="item.US"></div> 
        </template>

        <template v-slot:item.UK="{ item }">
          <div class="flex justify-center col-generic" v-html="item.UK"></div> 
        </template>

        <template v-slot:item.EU="{ item }">
          <div class="flex justify-center col-generic" v-html="item.EU"></div> 
        </template>

        <template v-slot:item.Canada="{ item }">
          <div class="flex justify-center col-generic" v-html="item.Canada"></div> 
        </template>

        <template v-slot:item.Switzerland="{ item }">
          <div class="flex justify-center col-generic" v-html="item.Switzerland"></div> 
        </template>
        
        <template v-slot:item.Australia="{ item }">
          <div class="flex justify-center col-generic" v-html="item.Australia"></div> 
        </template>
        
        <template v-slot:item.Japan="{ item }">
          <div class="flex justify-center col-generic" v-html="item.Japan"></div> 
        </template>

        <template v-slot:item.Type="{ item }">
          <span 
            :style="{ 'background-color': colMap[item.Type] }"
            class="text-lg font-bold px-2 py-1 text-white rounded-lg text-md col-type" v-html="item.Type"
          ></span> 
        </template>

        <template v-slot:item.SanctionList="{ item }">
          <div class="col-sanction-list" v-html="item.SanctionList"></div>  
        </template>

      </v-data-table>
    </div>
  </div>
</template>

<script>
import anime from 'animejs';

const red = "#E74C3C";
const green = "#2ECC71";
const sizeTicks = 32;
let crossInner = `<svg data-v-sign="cross" xmlns="http://www.w3.org/2000/svg" width=${sizeTicks} height=${sizeTicks} fill="${red}" class="bi bi-x-circle" viewBox="-2 -2 20 20">
  <path stroke="${red}" stroke-width="1.5" d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
</svg>`;

let checkInner = `<svg data-v-sign="check" xmlns="http://www.w3.org/2000/svg" width=${sizeTicks} height=${sizeTicks} fill="${green}" class="bi bi-check-circle" viewBox="-2 -2 20 20">
  <path stroke="${green}" stroke-width="1.5" d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
</svg>`;

export default {
  props: {
    path: {
      type: String
    },
    showLoader: {
      type: Boolean,
      default: true
    },
    entList: {
      type: Array,
      default: () => []
    },
    rows: {
      type: Array,
      default: () => [
        {
          entity_individual: '',
          US: '',
          UK: '',
          EU: '',
          Canada: '',
          Switzerland: '',
          Australia: '',
          Japan: '',
          Type: '',
          SanctionList:'',
        }
      ]
    },
    colMap: {
      type: Object
    }
  },
  computed: {
    entListFiltered() {
      const filtre = this.entList.filter(e => this.selectedVals.includes(e.type));
      let listNew = filtre.map(e => e.label);
      listNew.sort((a, b) => a.localeCompare(b));
      return listNew
    },
    searchLabel() {
      return `Search`
    },
    checkInner() {
      return checkInner
    },
    crossInner() {
      return crossInner
    },
  },
  methods: {
    displayHeaders() {
      const filteredHeaders = [];
      const selectedColumns = ["entity_individual","SanctionList","Type"];
      this.activeColumns.forEach(e => selectedColumns.push(e));
      
      // update headers
      this.headers.forEach(it => {
        if (selectedColumns.indexOf(it.value) != -1) {
          filteredHeaders.push(it);
        }
        this.sanctionFiltersChange('All', it.value);
      })

      // reset filters to update rows
      this.defaultUS = 'All';
      this.defaultUK = 'All';
      this.defaultEU = 'All';
      this.defaultCanada = 'All';
      this.defaultSwitzerland = 'All';
      this.defaultAustralia = 'All';
      this.defaultJapan = 'All';
        
      return filteredHeaders
    },
    resetSearch() {
      this.search =  "";
    },
    animation() {
      anime({
        targets: 'tr',
        opacity: 0,
        duration: 1, 
        delay: 1,
        complete: function() {
          anime({
            targets: 'tr',
            opacity: 1,
            duration: 300,
            delay: function(el, i) {
              return i*50
            },
          })
        }
      });
    },
    searchFunc (value, search) {
      return value != null &&
        search != null &&
        typeof value === 'string' &&
        value.toString().toLowerCase().indexOf(search.toLowerCase()) !== -1
    },
    toggle(e) {
      // normal button filtering
      if ( this.selectedVals.includes(e.target.innerText) ) {
        this.selectedVals = this.selectedVals.filter(it => it !== e.target.innerText);
      } else {
        this.selectedVals.push(e.target.innerText);
      }
      // if not any selection
      if ( e.target.innerText != 'Any' ) {
        this.selectedVals = this.selectedVals.filter(it => it !== 'Any');
      }
      // if any selection
      if ( e.target.innerText == 'Any' ) {
        this.selectedVals = [ "Individual", "Entity", "Vessel", "Aircraft", "Any"];
      }
    },
    sanctionFiltersChange(e, c) { 
      
      const country = c;
      const val = e;
      
      if (val == "✅ Sanctioned") {
        this.colDict[country] = ["check"];
      } else if ( val == "❌ Not Sanctioned") {
        this.colDict[country] = ["cross"];
      } else {
        this.colDict[country] = ["check", "cross"];
      }    
      
    },
    vuetifyUpdate() {
      
      // removing search bar arrow
      const searchIcons = document.getElementsByClassName('mdi-menu-down');
      const c = searchIcons[0];
      c.classList.replace('mdi-menu-down', 'mdi-magnify');
      c.style.display = "none"
      c.style.color = "rgba(0,0,0,0)";
      
      const leftArrow = document.getElementsByClassName('mdi-chevron-left');
      for (const c of leftArrow) {
        c.classList.replace('mdi-chevron-left', 'mdi-chevron-left-circle');
        c.style.color = "#05a8e8";
      }
      const rightArrow = document.getElementsByClassName('mdi-chevron-right');
      for (const c of rightArrow) {
        c.classList.replace('mdi-chevron-right', 'mdi-chevron-right-circle');
        c.style.color = "#05a8e8";
      }
      const searchOutline = document.getElementsByClassName('.primary--text');
      for (const c of searchOutline) {
        c.style.color = "#05a8e8 !important";
      }


      const searchOutlineGlobal = document.getElementsByClassName('.v-application');
      for (const c of searchOutlineGlobal) {
        c.style.color = "#05a8e8 !important";
      }

      // updating filter on header
      const detailsToRemove = document.getElementsByClassName('v-text-field__details');
      for (const c of detailsToRemove) {
        c.style.display = "none";
      }


      // header-country color
      // v-label
      const headerCountriesColor = document.getElementsByClassName('v-label');
      headerCountriesColor[0].style.color = "#05a8e8";

      //const inputToCenter = document.getElementsByClassName('v-label v-label--active theme--light primary--text');
      // v-label v-label--active theme--light primary--text
      
      const fieldset = document.getElementsByTagName('fieldset');
      for (const c of fieldset) {
        c.style.border = "1px solid purple !important";
        c.style["border-radius"] = "3px !important";
      }
    }
  },
  mounted() {
    this.vuetifyUpdate();

    document.querySelectorAll('.mdi-chevron-right-circle').forEach(item => {
      item.addEventListener('click', () => {
        this.animation();
      })
    });

    document.querySelectorAll('.mdi-chevron-left-circle').forEach(item => {
      item.addEventListener('click', () => {
        this.animation();
      })
    });
  },
  watch: {
    defaultUS(n) {
      this.sanctionFiltersChange(n, 'US');
    },
    defaultUK(n) {
      this.sanctionFiltersChange(n, 'UK');
    },
    defaultEU(n) {
      this.sanctionFiltersChange(n, 'EU');
    },
    defaultCanada(n) {
      this.sanctionFiltersChange(n, 'Canada');
    },
    defaultSwitzerland(n) {
      this.sanctionFiltersChange(n, 'Switzerland');
    },
    defaultAustralia(n) {
      this.sanctionFiltersChange(n, 'Australia');
    },
    defaultJapan(n) {
      this.sanctionFiltersChange(n, 'Japan');
    },
  },
  data () {
    let search =  "";
    let info = "";
    let headers = [
      {
        text: 'Entity/Individual',
        align: 'start',
        sortable: false,
        value: 'entity_individual',
      },
      { text: 'US', 
        value: 'US', 
        align: 'center', 
        sortable: false,
        filter: (value) => {
          const range = document.createRange();
          const fragment = range.createContextualFragment(value);
          const val = fragment.firstChild;
          if (val != null) {
            if (this.colDict.US.includes(val.dataset.vSign)) {
              return value
            }
          }
        }
      },
      { text: 'UK', 
        value: 'UK', 
        align: 'center', 
        sortable: false,
        filter: (value) => {
          const range = document.createRange();
          const fragment = range.createContextualFragment(value);
          const val = fragment.firstChild;
          if (val != null) {
            if (this.colDict.UK.includes(val.dataset.vSign)) {
              return value
            }
          }
        } 
      },
      { text: 'EU', 
        value: 'EU', 
        align: 'center', 
        sortable: false,
        filter: (value) => {
          const range = document.createRange();
          const fragment = range.createContextualFragment(value);
          const val = fragment.firstChild;
          if (val != null) {
            if (this.colDict.EU.includes(val.dataset.vSign)) {
              return value
            }
          }
        } 
      },
      { text: 'CA', 
        value: 'Canada', 
        align: 'center', 
        sortable: false,
        filter: (value) => {
          const range = document.createRange();
          const fragment = range.createContextualFragment(value);
          const val = fragment.firstChild;
          if (val != null) {
            if (this.colDict.Canada.includes(val.dataset.vSign)) {
              return value
            }
          }
        } 
      },
      { text: 'SW', 
        value: 'Switzerland', 
        align: 'center', 
        sortable: false,
        filter: (value) => {
          const range = document.createRange();
          const fragment = range.createContextualFragment(value);
          const val = fragment.firstChild;
          if (val != null) {
            if (this.colDict.Switzerland.includes(val.dataset.vSign)) {
              return value
            }
          }

        } 
      },
      { text: 'AU', 
        value: 'Australia', 
        align: 'center', 
        sortable: false,
        filter: (value) => {
          const range = document.createRange();
          const fragment = range.createContextualFragment(value);
          const val = fragment.firstChild;
          if (val != null) {
            if (this.colDict.Australia.includes(val.dataset.vSign)) {
              return value
            }
          }
        }
      },
      { text: 'JP', 
        value: 'Japan', 
        align: 'center', 
        sortable: false,
        filter: (value) => {
          const range = document.createRange();
          const fragment = range.createContextualFragment(value);
          const val = fragment.firstChild;
          if (val != null) {
            if (this.colDict.Japan.includes(val.dataset.vSign)) {
              return value
            }
          }
        }
      },
      { text: 'Type', 
        sortable: false,
        value: 'Type',
        filter: value => {
          if (!this.selectedVals || this.selectedVals == 'ANY TYPE') {
            return true
          } else {
            return this.selectedVals.includes(value)
          }
        },
      },
      { text: 'Sanctions Lists/Programs', 
        value: 'SanctionList', 
        align: 'left', 
        sortable: false 
      },
    ];
    let selectors = ["Entity", "Individual", "Vessel", "Aircraft", "ANY TYPE"];
    let selectedVals = ["Individual"];
    const btns = [
      {
        id: "btn-individual",
        label: "Individual",
        color: this.colMap["Individual"]
      },
      {
        id: "btn-entity",
        label: "Entity",
        color: this.colMap["Entity"]
      },
      {
        id: "btn-vessel",
        label: "Vessel",
        color: this.colMap["Vessel"]
      },
      {
        id: "btn-aircraft",
        label: "Aircraft",
        color: this.colMap["Aircraft"]
      },
      {
        id: "btn-any",
        label: "Any",
        color: this.colMap["Any"]
      }
      
      
    ];
    const colDict = {
      US: ["check", "cross"],
      UK: ["check", "cross"],
      EU: ["check", "cross"],
      Canada: ["check", "cross"],
      Switzerland: ["check", "cross"],
      Australia: ["check", "cross"],
      Japan: ["check", "cross"],
    };

    const countries = [
      'US', 'UK', 'EU', 'Canada', 'Switzerland', 'Australia', 'Japan' 
    ];
    const activeColumns = [
      'US', 'UK', 'EU', 'Canada', 'Switzerland', 'Australia', 'Japan'
    ];

    const defaultUS = 'All';
    const defaultUK = 'All';
    const defaultEU = 'All';
    const defaultCanada = 'All';
    const defaultSwitzerland = 'All';
    const defaultAustralia = 'All';
    const defaultJapan = 'All';
    
    return {
      info,
      headers,
      search,
      selectors,
      selectedVals,
      btns,
      colDict,
      countries,
      activeColumns,
      defaultUS, defaultUK, defaultEU, defaultCanada, defaultSwitzerland, defaultAustralia, defaultJapan
    }
  },
}
</script>

<style>

table {
  width:110% !important;
}

.col-entity {
  min-width: 300px;
  max-width: 400px;
}

.col-type {
  text-align: center !important;
  display:block !important;
}

.col-sanction-list {
  min-width: 300px;
  max-width: 400px;
}

.btn-margin {
  margin-right:2px;
  width:100px;
  text-align:center;
}

.search-size {
  min-width:400px;
}

.v-data-footer {
  padding-right: 80px !important;
}

@media screen and (max-width: 992px) {
  .col-entity {
    min-width: 200px;
    max-width: 300px;
  }
  .search-size {
    min-width:300px;
  }
  .btn-margin {
    margin-right:2px;
    width:130px;
    text-align:center;
  }
  .v-data-footer {
    padding-right: 40px !important;
  }
}

@media screen and (max-width: 600px) {
  .col-entity {
    min-width: 200px;
    max-width: 300px;
  }
  .search-size {
    min-width:200px;
  }
  .btn-margin {
    margin-right:0px;
    width:130px;
    text-align:center;
  }
  .v-data-footer {
    padding-right: 20px !important;
  }
}


/* SOME STYLING IS DEFINED IN THE VUETIFY PLUGIN */

img {
  max-width:20px !important;
  margin: 0 auto;
  border: 1px solid #bbb;
}

/* to debate
th {
  max-width:70px;
}
*/

th {
  padding: 0 !important;
}

th.text-start {
  padding: 0 8px !important;
}

.v-text-field__details {
  display: none !important;
}

tr {
  opacity:1;
}

.v-label {
  font-size: 1.2rem !important;
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

.v-text-field .v-label--active {
  max-width: 133%;
  transform: translateY(0px) scale(0) !important;
  pointer-events: auto;
}

tbody {
  border-top: 3px solid #555;
}

th .v-input__slot {
  width: fit-content !important;
}

.loader {
  border: 4px solid #f3f3f3;
  border-radius: 50%;
  border-top: 4px solid #05a8e8;
  width: 30px;
  height: 30px;
  -webkit-animation: spin 2s linear infinite; /* Safari */
  animation: spin 2s linear infinite;
}





.v-data-footer__pagination {
  font-size: 16px !important;
}

.v-input.v-textarea>.v-input__control>.v-input__slot:before {
    border: none;
    outline:none;
}


.v-input__slot {
  padding: 5px;
  border-radius:10px !important;
  margin: 4px 2px !important;
}

.select-sanctions > .v-input > .v-input__control > .v-input__slot {
  padding: 5px;
  border-radius:10px !important;
  margin: 6px !important;
}



/*
.mdi-menu-down {
  display: none !important;
}

.select-sanctions > .v-input > .v-input__control > .v-input__slot > .v-select__slot > .v-input__append-inner > .v-input__icon > .mdi-menu-down {
  display: inherit !important;
}
*/


#search fieldset {
  border: 3px solid transparent !important;
}

.v-label .v-label--active .theme--light .primary--text {
  color: purple !important;
  
}


/*
.v-label {
  color: #05a8e8 !important;
}
*/

.mdi-chevron-left-circle, .mdi-chevron-right-circle {
  font-size: 35px !important;
}


.mdi-magnigy {
  display: none !important;
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

.v-input__slot {
  border:1px solid #e3e3e3 ;
  border-radius: 5px !important;
  background-color: #e6f1d9 ;
}

.v-input__slot::after {
  border:1px solid #bbb;
  border-radius: 5px !important;
  background-color: #d7eefc ;
}

/* for country selection */ 
#selection-countries .v-input__slot::after {
  background-color: transparent;
}

#selection-countries .v-input__slot {
  background-color: transparent;
}

#selection-countries div div .v-input .v-input__control .v-input__slot .v-select__slot .v-select__selections {
  color: #05a8e8;
}

#selection-countries div div .v-input .v-input__control .v-input__slot .v-select__slot .v-input__append-inner .v-input__icon .v-icon {
  color: #05a8e8;
}

#search .v-input__slot, #selection-countries .v-input__slot{
  border:0px solid transparent !important;
}

#search .v-input__slot::after, #selection-countries .v-input__slot::after{
  border:0px solid transparent !important;
}

.theme--light.v-text-field > .v-input__control > .v-input__slot::before {
  border:transparent;
}

.theme--light.v-text-field > .v-input__control > .v-input__slot::after {
  border:transparent;
}

/* select countries */

/*

.v-sheet div, .v-sheet div div::before {
  color: #05a8e8 !important;
}

.v-application .primary--text {
  color: #05a8e8 !important;
  caret-color: #05a8e8 !important;
}

.v-list-item--link::before, .v-list-item--link {
  background-color: #ffffff;
}

div[aria-selected="true"], div[aria-hidden="true"]{
  background-color: #ffffff;
}

.mdi-checkbox-marked {
  color: #05a8e8 !important;
}

*/

.v-list-item--active {
  color: #05a8e8 !important;
}


</style>
