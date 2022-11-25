<template>
  <div class="border-none">
    <div class="grid grid-cols-1 gap-2 sm:grid-cols-3 border-none inline-flex self-center main-color mb-4 mt-6">
      <div class="">
        <template>
          <v-autocomplete
            v-model="search"
            :items="entListFiltered"
            label="Search"
            class="mx-2"
            :outlined=true
          ></v-autocomplete>
        </template>
      </div>
      <div class="self-center grid grid-cols-4 flex justify-items-center  gap-2">
        <div v-for="btn in btns" :key="btn.id">
          <TheButton 
            @click="toggle($event)"
            :style="{ 
              'border-color': btn.color, 
              'color': selectedVals.includes(btn.label) ? '#fff' : btn.color,
              'background-color': selectedVals.includes(btn.label) ? btn.color : '#fff',
              'opacity': selectedVals.includes(btn.label) ? 1 : 0.6
            }" 
            class="text-center font-bold cursor-pointer px-4 py-2 rounded-lg border-2"
          >
            {{ btn.label }}
          </TheButton>
        </div>
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

        
        class="border-none main-color"
        :search="search"
        :custom-filter="searchFunc"
      >
        <!-- Header customization -->
        <template v-slot:header.entity_individual="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
        </template>

        <template v-slot:header.Australia="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
          <img src="/flags/australia_min.png" class="rounded-full my-1">
        </template>

        <template v-slot:header.Canada="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
          <img src="/flags/canada_min.png" class="rounded-full my-1">
        </template>

        <template v-slot:header.EU="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
          <img src="/flags/eu_min.png" class="rounded-full my-1">
        </template>

        <template v-slot:header.Switzerland="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
          <img src="/flags/sw_min.png" class="rounded-full my-1">
        </template>

        <template v-slot:header.UK="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
          <img src="/flags/uk_min.png" class="rounded-full my-1">
        </template>

        <template v-slot:header.US="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
          <img src="/flags/us_min.png" class="rounded-full my-1">
        </template>

        <template v-slot:header.Type="{ header }">
          <span class="font-bold text-lg main-color">{{ header.text }}</span>
          <img src="/flags/us_min.png" class="rounded-full my-1 opacity-0">
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
          <span 
            :style="{ 'background-color': colMap[item.Type] }"
            class="text-lg font-bold px-2 py-1 text-white rounded-lg text-md" v-html="item.Type"
          ></span> 
        </template>

      </v-data-table>
    </div>
  </div>
</template>

<script>
export default {
  props: {
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
          Australia: '',
          Canada: '',
          EU: '',
          Switzerland: '',
          UK: '',
          US: '',
          Type: '',
        }
      ]
    },
    colMap: {
      type: Object
    }
  },
  methods: {
    searchFunc (value, search) {
      return value != null &&
        search != null &&
        typeof value === 'string' &&
        value.toString().toLowerCase().indexOf(search.toLowerCase()) !== -1
    },
    toggle(e) {
      if ( this.selectedVals.includes(e.target.innerText) ) {
        this.selectedVals = this.selectedVals.filter(it => it !== e.target.innerText);
      } else {
        this.selectedVals.push(e.target.innerText);
      }
    },
    vuetifyUpdate() {
      const searchIcons = document.getElementsByClassName('mdi-menu-down');
      for (const c of searchIcons) {
        c.classList.replace('mdi-menu-down', 'mdi-magnify');
        c.style.color = "#05a8e8";
      }
      const leftArrow = document.getElementsByClassName('mdi-chevron-left');
      for (const c of leftArrow) {
        c.classList.replace('mdi-chevron-left', 'mdi-chevron-left-circle');
        c.style.color = "#05a8e8";
      }
      // leftArrow.style.color = "purple";
      const rightArrow = document.getElementsByClassName('mdi-chevron-right');
      for (const c of rightArrow) {
        c.classList.replace('mdi-chevron-right', 'mdi-chevron-right-circle');
        c.style.color = "#05a8e8";
      }
      const details = document.getElementsByClassName('v-text-field__details');
      details[0].remove();
      const searchOutline = document.getElementsByClassName('.primary--text');
      for (const c of searchOutline) {
        c.style.color = "#05a8e8 !important";
      }
      const searchOutlineGlobal = document.getElementsByClassName('.v-application');
      for (const c of searchOutlineGlobal) {
        c.style.color = "#05a8e8 !important";
      }
    }
  },
  computed: {
    entListFiltered() {
      const filtre = this.entList.filter(e => this.selectedVals.includes(e.type));
      const listNew = filtre.map(e => e.label);
      return listNew
    }
  },
  mounted() {
    this.vuetifyUpdate();
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
      { text: 'US', value: 'US', align: 'center', sortable: false },
      { text: 'UK', value: 'UK', align: 'center', sortable: false },
      { text: 'EU', value: 'EU', align: 'center', sortable: false },
      { text: 'CA', value: 'Canada', align: 'center', sortable: false },
      { text: 'SW', value: 'Switzerland', align: 'center', sortable: false },
      { text: 'AU', value: 'Australia', align: 'center', sortable: false },
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
      
      
    ];
    return {
      info,
      headers,
      search,
      selectors,
      selectedVals,
      btns
    }
  },
}
</script>

<style>


/* SOME STYLING IS DEFINED IN THE VUETIFY PLUGIN */

img {
  max-width:20px !important;
  margin: 0 auto;
  border: 1px solid #bbb;
}

th {
  max-width:70px;
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

tbody > tr:nth-child(odd) {
  /* background-color: #05a8e810 !important; */
}

tbody {
  border-top: 3px solid #555;
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

.v-input.v-textarea>.v-input__control>.v-input__slot:before {
    border: none;
    outline:none;
}

.v-input__slot {
  padding: 5px;
  border-radius:10px !important;
  margin: 0px 0px !important;
}

fieldset {
  border: 3px solid #05a8e8 !important;
}

.v-label {
  color: #05a8e8 !important;
}

.mdi-chevron-left-circle, .mdi-chevron-right-circle {
  font-size: 35px !important;
}

.mdi-menu-down {
  display: none !important;
}

.mdi-magnigy {
  display: inherit !important;
}

.v-data-footer {
  padding-right: 20px !important;
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
