<template>
  <div>
    <div class="shadow-md p-4 flex">
      <div class="relative">
        <svg class="mx-auto" :width="width" :height="height" :id="id">
        </svg>
        <div class="font-bold text-lg container-fig">
          {{ formattedPercentage }}
        </div>
      </div>
      <div>
        <div class="font-bold px-2 text-2xl text-left">{{ count }}</div>
        <div :style="{ color: this.color }" class="text-left font-bold px-2 text-lg">{{ label }}</div>
      </div>
    </div>
  </div>
</template>

<script>
import * as d3 from "d3";

export default {
  name: 'Donut',
  props: ["color", "label", "id", "count", "totalEntries"],
  computed: {
    formattedPercentage() {
      let val = (this.count/this.totalEntries) * 100;
      val = val.toFixed(1) + "%";
      return val
    }
  },
  methods: {
    donutDraw() {
      const color = this.color;
      console.log(color, d3.selectAll("div"));

      const data = [
        { 
          'val': this.count, 
          'opacity': 1,
        }, 
        {
          'val': this.totalEntries - this.count,
          'opacity': 0.2,
        }
      ] 

      const svg = d3.select(`#${this.id}`);

      const width = this.width;
      const height = this.height;

      // const arcs = d3.pie().padAngle(padAngle).sort(null).value(i => V[i])(I);
      // const arc = d3.arc().innerRadius(innerRadius).outerRadius(outerRadius);

      const pie = d3.pie()
        .value((d) => d.val)
      
      const arc = d3.arc()
        .innerRadius(width/3)
        .outerRadius(width/2)
      
      svg.attr("width", width)
      .attr("height", height)
      .attr("viewBox", [-width / 2, -height / 2, width, height])
      .attr("style", "max-width: 100%; height: auto; height: intrinsic;");

      svg.append("g")
        //.attr("stroke", stroke)
        //.attr("stroke-width", strokeWidth)
        //.attr("stroke-linejoin", strokeLinejoin)
      .selectAll("path")
      .data(pie(data))
      .join("path")
        .attr("fill", this.color)
        .attr("opacity", (d,i) => data[i].opacity)
        .attr("d", arc) 
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
    const width = 150;
    const height = 150;
    return {
      width, height
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