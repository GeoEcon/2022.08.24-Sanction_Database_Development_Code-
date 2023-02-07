<template>
  <div class="grid sm:grid-cols-5 sm:p-8 p-2 gap-4 items-stretch text-center" >
    <TotalSanctions 
      :totalSanctions="totalSanctions"
      :path="path"
    />
    <div v-for="graph in donutObj" :key="graph.id">
      <Donut 
        :color="graph.color"
        :label="graph.label"
        :labelPlural="graph.labelPlural"
        :id="graph.id"
        :count="graph.count"
        :totalSanctions="totalSanctions"
        :sanctionsCountByType="sanctionsCountByType"
      />
    </div>
  </div>
</template>

<script>
import Donut from './Donut.vue';
import TotalSanctions from './TotalSanctions.vue';  

export default {
  components: {
    Donut, TotalSanctions
  },
  props: ["donutObj", "totalEntries", "totalSanctions", "sanctionsCountByType", "path"]
}
</script>