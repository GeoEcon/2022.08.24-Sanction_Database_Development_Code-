<template>
  <div class="shadow-md w-full h-full">

    <Tooltip 
      :title="labelPlural" 
      :display="display"
      :transX="transX"
      :transY="transY"
      :widthBars="widthBars"
      :heightBars="heightBars"
      :dataBars="dataBars"
      :updateBars="updateBars"
      :color="color"
    />

    <div class="p-4 flex ">
      <div class="relative">
        <svg class="mx-auto" :width="width" :height="height" :id="id">
        </svg>
        <div class="font-bold text-lg container-fig">
          {{ formattedPercentage }}
        </div>
      </div>
      <div>
        <div class="font-bold px-2 text-2xl text-left">{{ sanctionsCountByType[label] }}</div>
        <div :style="{ color: this.color }" class="text-left font-bold p-2 text-lg">{{ labelPlural }}</div>
      </div>
    </div>
  </div>
</template>

<script>
import * as d3 from "d3";
import Tooltip from './Tooltip.vue';

export default {
  name: 'Donut',
  components: {
    Tooltip
  },
  props: ["color", "label", "labelPlural", "id", "count", "totalSanctions", "sanctionsCountByType", "dataBars", "updateBars"],
  computed: {
    formattedPercentage() {
      let val = (this.sanctionsCountByType[this.label]/this.totalSanctions) * 100;
      if (this.totalSanctions == 0) {
        val = ""
      } else {
        val = val.toFixed(1) + "%";
      }      
      return val
    }
  },
  methods: {
    donutDraw() {
      const data = [
        { 
          'val': this.sanctionsCountByType[this.label], 
          'opacity': 1,
        }, 
        {
          'val': this.totalSanctions - this.sanctionsCountByType[this.label],
          'opacity': 0.2,
        }
      ] 

      const ref = this;

      const svg = d3.select(`#${this.id}`);

      const width = this.width;
      const height = this.height;
      const margin = 5;

      const pie = d3.pie()
        .value((d) => d.val)
      
      const arc = d3.arc()
        .innerRadius(width/3 - margin)
        .outerRadius(width/2 - margin)
      
      svg.attr("width", width)
      .attr("height", height)
      .attr("viewBox", [-width / 2, -height / 2, width, height])
      .attr("style", "max-width: 100%; height: auto; height: intrinsic;");

      svg.append("g")
      .selectAll("path")
      .data(pie(data))
      .join("path")
        .attr("stroke", "#000")
        .attr("stroke-width", 2)
        .attr("stroke-opacity", 0)
        .attr("fill", this.color)
        .attr("data-graph-type", `graph-${this.id}`)
        .attr("class", "svg-arc") // should be unique based on mouseover actions
        .attr("opacity", (d,i) => data[i].opacity)
        .attr("d", arc) 
      .on('mousemove', mousemove)
      .on('mouseleave', mouseleave)

      // mouseover events
      function mousemove(e) {
        d3.selectAll(`[data-graph-type="${this.dataset['graphType']}"]`)
          .attr("stroke-opacity", 1);

        ref.display = true;
        ref.transY = e.clientY + 20;
        if (e.clientX < window.innerWidth / 2) {
          ref.transX = e.clientX + 20;
        } else {
          ref.transX = e.clientX -  ref.widthBars - 40;
        }
        
      }

      // mouseover events
      function mouseleave() {
        d3.selectAll(".svg-arc")
          .attr("stroke-opacity", 0);

        ref.display = false;
        ref.transX = 0;
        ref.transY = 0;
      }
    }
  },
  mounted() {
    this.donutDraw();
  },
  watch: {
    count() {
      this.donutDraw();
    }
  },
  data() {
    const width = 125;
    const height = 125;
    const widthBars = 350;
    const heightBars = 500;
    const display = false;
    const transX = 0;
    const transY = 0;
    return {
      width, height, display, transX, transY, widthBars, heightBars
    }
  }
}
</script>

<style scoped>
.container-fig {
  transform: translate(-50%, -50%);
  position:absolute;
  top:50%;
  left:50%;
}
</style>