<template>
  <div class="grid sm:grid-cols-4 p-8 gap-4 text-center" >
    <div v-for="graph in donutObj" :key="graph.id">
      <Donut 
        :color="graph.color"
        :label="graph.label"
        :id="graph.id"
        :count="graph.count"
        :totalEntries="totalEntries"
      />
    </div>
  </div>
</template>

<script>
import Donut from './Donut.vue'; 

export default {
  components: {
    Donut
  },
  props: ["donutObj", "totalEntries"]
}
</script>